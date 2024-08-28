//
//  FollowRouter.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import Foundation

import Alamofire

enum FollowRouter {
    case follow(userID: String)
    case canceledFollow(userID: String)
}
extension FollowRouter: TargetType {
    var baseURL: String {
        guard let base = Constant.NetworkComponents.baseURL else { return "" }
        return base
    }
    var method: Alamofire.HTTPMethod {
        switch self {
        case .follow:
                .post
        case .canceledFollow:
                .delete
        }
    }
    var path: String {
        switch self {
        case .follow(let userID):
            return "/v1/follow/\(userID)"
        case .canceledFollow(let userID):
            return "/v1/follow/\(userID)"
        }
    }
    var header: HTTPHeaders {
        guard let apiKey = Constant.NetworkComponents.apiKey else {
            print("🔑 API Key error")
            return ["": ""]
        }
        let baseHeaders: HTTPHeaders = [
            Constant.NetworkHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
            Constant.NetworkHeader.sesacKey.rawValue: apiKey
        ]
        return baseHeaders
    }
    
    var query: [URLQueryItem]? {
        return []
    }
    
    var body: Data? {
        nil
    }
}
