//
//  FollowState.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/31/24.
//

import Foundation

enum FollowState: String {
    case success
    case cancel
    case failure
    
    var toastMsg: String {
        switch self {
        case .success:
            return "팔로잉 성공 !"
        case .cancel:
            return "이미 팔로잉한 사람입니다 !"
        case .failure:
            return "팔로잉 실패. 잠시 후 다시 시도해주세요."
        }
    }
}
