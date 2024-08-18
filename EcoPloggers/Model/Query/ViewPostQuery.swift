//
//  ViewPostQuery.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/18/24.
//

import Foundation

struct ViewPostQuery: Encodable {
    let next: String?
    let limit: String?
    let product_id: String?
}
