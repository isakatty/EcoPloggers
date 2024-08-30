//
//  HashtagsQuery.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/22/24.
//

import Foundation

struct HashtagsQuery: Encodable {
    var next: String?
    let limit: String?
    let product_id: String?
    let hashTag: String
}
