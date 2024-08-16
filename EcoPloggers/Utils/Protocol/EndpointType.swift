//
//  EndpointType.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/16/24.
//

import Foundation

enum Scheme: String {
    case http, https
}

protocol EndpointType {
    var scheme: Scheme { get }
    var host: String { get }
    var path: String { get }
    var port: String { get }
    var query: [URLQueryItem] { get }
    var header: [String: String] { get }
    var body: Data? { get }
    var method: HTTPMethod { get }
}

extension EndpointType {
    var toURLRequest: URLRequest? {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme.rawValue
        urlComponent.host = host
        urlComponent.port = Int(port)
        urlComponent.path = path
        if !query.isEmpty {
            urlComponent.queryItems = query
        }
        guard let url = urlComponent.url else {
            print("여기서 에러?")
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.toString
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpBody = body
        return urlRequest
    }
}
