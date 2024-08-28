//
//  UploadPostQuery.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/20/24.
//

import Foundation

struct UploadPostQuery: Encodable {
    let title: String
    let price: Int?
    let content: String
    let required_time: String?
    let path: String?
    let recruits: String?
    let priceString: String?
    let due_date: String?
    let product_id: String
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case title, price, content
        case required_time = "content1"
        case path = "content2"
        case recruits = "content3"
        case priceString = "content4"
        case due_date = "content5"
        case product_id, files
    }
}
