//
//  SignUpResponse.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import Foundation

struct SignUpResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
}
