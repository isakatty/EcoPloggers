//
//  HTTPMethod.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/16/24.
//

import Foundation

enum HTTPMethod {
    case get, put, post, delete
    
    var toString: String {
        switch self {
        case .get:
            return "GET"
        case .put:
            return "PUT"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}
