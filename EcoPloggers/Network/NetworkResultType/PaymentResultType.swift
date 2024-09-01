//
//  PaymentResultType.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 9/1/24.
//

import Foundation

enum PaymentResultType {
    case success(PaymentValidationResponse)
    case invalidPayment
    case invalidToken
    case forbidden
    case alreadyValidated
    case disappearPost
    case expiredToken
    case error(CommonError)
}

enum PaymentListResultType {
    case success(PaymentListResponse)
    case invalidToken
    case forbidden
    case expiredToken
    case error(CommonError)
}
