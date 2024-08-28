//
//  TargetType.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/19/24.
//

import Foundation

import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: HTTPHeaders { get }
    var query: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        var url = try baseURL.asURL().appendingPathComponent(path, conformingTo: .url)
        if let query {
            url.append(queryItems: query)
        }
        var urlRequest = try URLRequest(url: url, method: method)
        urlRequest.headers = header
        urlRequest.httpBody = body
        return urlRequest
    }
}
  
