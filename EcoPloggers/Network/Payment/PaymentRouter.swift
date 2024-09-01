//
//  PaymentRouter.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 9/1/24.
//

import Foundation

import Alamofire

enum PaymentRouter {
    case payment(query: PaymentQuery)
    case paymentList
}

extension PaymentRouter: TargetType {
    var baseURL: String {
        guard let base = Constant.NetworkComponents.baseURL else { return "" }
        return base
    }
    var method: HTTPMethod {
        switch self {
        case .payment:
            return .post
        case .paymentList:
            return .get
        }
    }
    var path: String {
        switch self {
        case .payment:
            return "/v1/payments/validation"
        case .paymentList:
            return "/v1/payments/me"
        }
    }
    var header: HTTPHeaders {
        guard let apiKey = Constant.NetworkComponents.apiKey else {
            print("🔑 API Key error")
            return ["": ""]
        }
        let baseHeaders: HTTPHeaders = [
            Constant.NetworkHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
            Constant.NetworkHeader.sesacKey.rawValue: apiKey,
            Constant.NetworkHeader.contentType.rawValue: Constant.NetworkHeader.json.rawValue
        ]
        return baseHeaders
    }
    
    var query: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .payment(let query):
            return try? encoder.encode(query)
        case .paymentList:
            return nil
        }
    }
}
