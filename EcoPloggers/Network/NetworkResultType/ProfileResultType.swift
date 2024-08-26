//
//  ProfileResultType.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import Foundation

enum ProfileResultType {
    case success(ProfileResponse)
    case invalidToken
    case forbidden
    case expiredToken
    case error(CommonError)
}
enum SearchOtherProfileResultType {
    case success(SearchUserResponse)
    case invalidToken
    case forbidden
    case expiredToken
    case error(CommonError)
}
