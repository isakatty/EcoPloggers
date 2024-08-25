//
//  OtherProfileResponse.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import Foundation

struct OtherProfileResponse: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
    let followers: [Creator]
    let following: [Creator]
    let posts: [String]
}
