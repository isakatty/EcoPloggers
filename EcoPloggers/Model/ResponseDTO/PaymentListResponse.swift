//
//  PaymentListResponse.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 9/1/24.
//

import Foundation

struct PaymentListResponse: Decodable {
    let data: [PaymentValidationResponse]
}
