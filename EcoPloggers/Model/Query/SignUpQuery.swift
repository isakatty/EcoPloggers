//
//  SignUpQuery.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/16/24.
//

import Foundation

struct SignUpQuery: Encodable {
    let email: String
    let password: String
    let nick: String
}
