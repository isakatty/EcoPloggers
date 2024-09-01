//
//  PaymentValidationResponse.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 9/1/24.
//

import Foundation

struct PaymentValidationResponse: Decodable {
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}
