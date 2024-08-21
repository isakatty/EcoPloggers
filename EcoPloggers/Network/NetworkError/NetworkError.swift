//
//  NetworkError.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/16/24.
//

import Foundation

enum CommonError: Int, Error {
    case invaildHeader = 420
    case tooManyRequests = 429
    case invalidURL = 444
    case serverError = 500
    case unknown = 999
}

enum LoginResult {
    case success(LoginResponse)
    case badRequest
    case unauthorized
    case error(CommonError)
}

enum SignUpResult {
    case success(SignUpResponse)
    case badRequest
    case whiteSpacesNickname
    case alreadyOwned
    case error(CommonError)
}

enum RefreshTokenResult {
    case success(RefreshResponse)
    case unauthorized
    case forbidden
    case ReLogin
    case error(CommonError)
}

enum ValidateEmailResult {
    case success(ValidateEmailResponse)
    case badRequest
    case invalidEmail(ValidateEmailResponse)
    case error(CommonError)
}
