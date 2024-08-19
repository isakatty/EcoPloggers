//
//  PostRequest.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import Foundation

enum PostRequest {
    case viewPost(ViewPostQuery?)
}

extension PostRequest: EndpointType {
    var scheme: Scheme {
        return .http
    }
    var host: String {
        guard let baseURL = Constant.NetworkComponents.baseURL else { return "" }
        return baseURL
    }
    var path: String {
        switch self {
        case .viewPost:
            return "/v1/posts"
        }
    }
    var port: String {
        guard let portString = Constant.NetworkComponents.portString else { return "" }
        return portString
    }
    var query: [URLQueryItem] {
        switch self {
        case .viewPost(let viewPostQuery):
            guard let viewPostQuery else { return [] }
            return [URLQueryItem(name: "product_id", value: viewPostQuery.product_id)]
        }
    }
    var header: [String : String] {
        guard let apiKey = Constant.NetworkComponents.apiKey else {
            print("🔑 API Key error")
            return ["": ""]
        }
        let baseHeader = [Constant.NetworkHeader.sesacKey.rawValue: apiKey]
        let tokenHeader = [Constant.NetworkHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken]
        let contentHeader = [Constant.NetworkHeader.contentType.rawValue: Constant.NetworkHeader.json.rawValue]
        let combinedHeaders = baseHeader.merging(contentHeader) { value1, _ in
            value1
        }
        switch self {
        case .viewPost:
            return baseHeader.merging(tokenHeader) { value1, _ in
                value1
            }
        }
    }
    var body: Data? {
        switch self {
        case .viewPost:
            return nil
        }
    }
    var method: _HTTPMethod {
        switch self {
        case .viewPost:
            return .get
        }
    }
}
