//
//  LoginResponse.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/16/24.
//

import Foundation

struct LoginResponse: Decodable {
    let user_id: String
    let email: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
