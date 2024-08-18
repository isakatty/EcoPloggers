//
//  ViewPostResponse.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/18/24.
//

import Foundation

struct ViewPostResponse: Decodable {
    let data: [ViewPostDetailResponse]
    let next_cursor: String
}
struct ViewPostDetailResponse: Decodable {
    let post_id: String
    let product_id: String?
    let title: String
    let content: String
    let required_time: String
    let path: String
    let recruits: String
    let price: String
    let due_date: String
    let posted_date: Date
    let creator: Creator
    let files: [String]
    let joins: [String]
    let likes2: [String]
    let comments: [Comment]
}
