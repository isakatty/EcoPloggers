//
//  UserRouter.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/19/24.
//

import Foundation

import Alamofire

enum UserRouter {
    case signup(signup: SignUpQuery)
    case login(login: LogInQuery)
    case refreshToken(refreshToken: String)
    case validateEmail(email: ValidateEmailQuery)
    case withdraw
}
extension UserRouter: TargetType {
    var baseURL: String {
        guard let base = Constant.NetworkComponents.baseURL else { return "" }
        return base
    }
    var method: HTTPMethod {
        switch self {
        case .signup, .login, .validateEmail:
                .post
        case .refreshToken, .withdraw:
                .get
        }
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
    var header: HTTPHeaders {
        guard let apiKey = Constant.NetworkComponents.apiKey else {
            print("🔑 API Key error")
            return ["": ""]
        }
        
        let accessToken: String = UserDefaultsManager.shared.accessToken
        let refreshToken: String = UserDefaultsManager.shared.refreshToken
        switch self {
        case .signup, .login, .validateEmail:
            return [
                Constant.NetworkHeader.contentType.rawValue: Constant.NetworkHeader.json.rawValue,
                Constant.NetworkHeader.sesacKey.rawValue : apiKey
            ]
        case .refreshToken(let refreshToken):
            return [
                Constant.NetworkHeader.authorization.rawValue: accessToken,
                Constant.NetworkHeader.sesacKey.rawValue: apiKey,
                Constant.NetworkHeader.refresh.rawValue: refreshToken
            ]
        case .withdraw:
            return [
                Constant.NetworkHeader.authorization.rawValue: accessToken,
                Constant.NetworkHeader.sesacKey.rawValue : apiKey
            ]
        }
    }
    
    var query: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        
        switch self {
        case .signup(let signup):
            return try? encoder.encode(signup)
        case .login(let login):
            return try? encoder.encode(login)
        case .refreshToken:
            return nil
        case .validateEmail(let email):
            return try? encoder.encode(email)
        case .withdraw:
            return nil
        }
    }
}
