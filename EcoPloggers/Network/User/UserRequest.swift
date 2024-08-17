//
//  UserRequest.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import Foundation

enum UserRequest {
    case signup(login: SignUpQuery)
    case login(login: LogInQuery)
    case refreshToken(refreshToken: String)
    case validateEmail(email: ValidateEmailQuery)
    case withdraw
}

extension UserRequest: EndpointType {
    var scheme: Scheme {
        .http
    }
    var host: String {
        guard let baseURL = Constant.NetworkComponents.baseURL else { return "" }
        return baseURL
    }
    var path: String {
        switch self {
        case .signup:
            "/v1/users/join"
        case .login:
            "/v1/users/login"
        case .refreshToken:
            "/v1/auth/refresh"
        case .validateEmail:
            "/v1/validation/email"
        case .withdraw:
            "/v1/users/withdraw"
        }
    }
    var port: String {
        guard let portString = Constant.NetworkComponents.portString else { return "" }
        return portString
    }
    var query: [URLQueryItem] {
        []
    }
    var body: Data? {
        let encoder = JSONEncoder()
        
        switch self {
        case .signup(let signup):
            return try? encoder.encode(signup)
        case .login(let login):
            return try? encoder.encode(login)
        case .refreshToken(let refreshToken):
            return nil
        case .validateEmail(let email):
            return try? encoder.encode(email)
        case .withdraw:
            return nil
        }
    }
    
    var header: [String : String] {
        guard let apiKey = Constant.NetworkComponents.apiKey else {
            print("🔑 API Key error")
            return ["": ""]
        }
        let baseHeader = [Constant.NetworkHeader.sesacKey.rawValue: apiKey]
        let contentHeader = [Constant.NetworkHeader.contentType.rawValue: Constant.NetworkHeader.json.rawValue]
        let combinedHeaders = baseHeader.merging(contentHeader) { value1, _ in
            value1
        }
        switch self {
        case .signup, .login, .validateEmail, .withdraw:
            return combinedHeaders
        case .refreshToken(let token):
            let refresh = [Constant.NetworkHeader.refresh.rawValue: token]
            return combinedHeaders.merging(refresh) { value1, _ in
                value1
            }
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signup, .login, .validateEmail:
                .post
        case .refreshToken, .withdraw:
                .get
        }
    }
}
