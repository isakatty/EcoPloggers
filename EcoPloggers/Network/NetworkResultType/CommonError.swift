//
//  CommonError.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/21/24.
//

import Foundation

enum CommonError: Int, Error {
    case invaildHeader = 420
    case tooManyRequests = 429
    case invalidURL = 444
    case serverError = 500
    case unknown = 999
}
