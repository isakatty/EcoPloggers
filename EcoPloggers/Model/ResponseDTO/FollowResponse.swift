//
//  FollowResponse.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import Foundation

struct FollowResponse: Decodable {
    let nick: String
    let opponent_nick: String
    let following_status: Bool
}
