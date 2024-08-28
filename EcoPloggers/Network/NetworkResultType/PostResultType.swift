//
//  PostResultType.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/21/24.
//

import Foundation

enum CommonResult {
    case success(ViewPostResponseDTO)
    case badRequest
    case invalidToken
    case forbidden
    case expiredToken
    case invalidPost
    case error(CommonError)
}

enum UploadPostResultType {
    case success(ViewPostResponseDTO)
    case badRequest
    case invalidToken
    case forbidden
    case emptyPost
    case expiredToken
    case error(CommonError)
}

enum FetchPostResult {
    case success(ViewPostResponseDTO)
    case badRequest
    case invalidToken
    case forbidden
    case expiredToken
    case error(CommonError)
}

enum FetchFavResult {
    case success(ViewPostResponseDTO)
    case badRequest
    case invalidToken
    case forbidden
    case invalidPost
    case expiredToken
    case error(CommonError)
}

enum FetchHashtagsResult {
    case success(ViewPostResponseDTO)
    case badRequest
    case invalidToken
    case forbidden
    case expiredToken
    case error(CommonError)
}

extension FetchPostResult {
    func toCommonResult() -> CommonResult {
        switch self {
        case .success(let response):
            return .success(response)
        case .badRequest:
            return .badRequest
        case .invalidToken:
            return .invalidToken
        case .forbidden:
            return .forbidden
        case .expiredToken:
            return .expiredToken
        case .error(let error):
            return .error(error)
        }
    }
}

extension FetchFavResult {
    func toCommonResult() -> CommonResult {
        switch self {
        case .success(let response):
            return .success(response)
        case .badRequest:
            return .badRequest
        case .invalidToken:
            return .invalidToken
        case .forbidden:
            return .forbidden
        case .invalidPost:
            return .invalidPost
        case .expiredToken:
            return .expiredToken
        case .error(let error):
            return .error(error)
        }
    }
}

extension FetchHashtagsResult {
    func toCommonResult() -> CommonResult {
        switch self {
        case .success(let response):
            return .success(response)
        case .badRequest:
            return .badRequest
        case .invalidToken:
            return .invalidToken
        case .forbidden:
            return .forbidden
        case .expiredToken:
            return .expiredToken
        case .error(let error):
            return .error(error)
        }
    }
}
