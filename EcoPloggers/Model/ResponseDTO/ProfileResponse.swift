//
//  ProfileResponse.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import Foundation

struct ProfileResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthday: String?
    let profileImage: String?
    let followers: [Creator]
    let following: [Creator]
    let posts: [String]
}
