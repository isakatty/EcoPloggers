//
//  FollowResultType.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import Foundation

enum FollowResultType {
    case success(FollowResponse)
    case invalidRequest
    case invalidToken
    case forbidden
    case alreadyFollowed // 이미 팔로우함
    case invalidUser
    case expiredToken
    case error(CommonError)
}

enum UnfollowResultType {
    case success(FollowResponse)
    case invalidRequest
    case invalidToken
    case forbidden
    case invalidUser // 내 팔로잉 목록에 없는 유저
    case expiredToken
    case error(CommonError)
}
