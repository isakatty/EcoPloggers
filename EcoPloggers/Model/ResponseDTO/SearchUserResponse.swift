//
//  SearchUserResponse.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import Foundation

struct SearchUserResponse: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
    let followers: [String]
    let following: [String]
    let posts: [String]
}
