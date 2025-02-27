//
//  ResultType.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/16/24.
//

import Foundation

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
    case reLogin
    case error(CommonError)
}

enum ValidateEmailResult {
    case success(ValidateEmailResponse)
    case badRequest
    case invalidEmail(ValidateEmailResponse)
    case error(CommonError)
}

enum WithdrawResult {
    case success(SignUpResponse)
    case invalidToken
    case forbidden
    case error(CommonError)
}
