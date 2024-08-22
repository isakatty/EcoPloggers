//
//  PostResultType.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/21/24.
//

import Foundation

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
