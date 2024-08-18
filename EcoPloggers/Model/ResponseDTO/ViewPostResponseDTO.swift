//
//  ViewPostResponseDTO.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/18/24.
//

import Foundation

struct ViewPostResponseDTO: Decodable {
    let data: [ViewPostDetailResponseDTO]
    let next_cursor: String
}

extension ViewPostResponseDTO {
    var toDomain: ViewPostResponse {
        return .init(
            data: data.map {
                .init(
                    post_id: $0.post_id,
                    product_id: $0.product_id,
                    title: $0.title,
                    content: $0.content,
                    required_time: $0.content1,
                    path: $0.content2,
                    recruits: $0.content3,
                    price: $0.content4,
                    due_date: $0.content5,
                    posted_date: $0.created_At,
                    creator: $0.creator,
                    files: $0.files,
                    joins: $0.likes,
                    likes2: $0.likes2,
                    comments: $0.comments
                )
            },
            next_cursor: next_cursor
        )
    }
}
struct ViewPostDetailResponseDTO: Decodable {
    let post_id: String
    let product_id: String?
    let title: String
    let content: String
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let content5: String
    let created_At: Date
    let creator: Creator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let comments: [Comment]
}
struct Creator: Decodable {
    let user_id: String
    let nickname: String
    let profileImage: String
}
struct Comment: Decodable {
    let comment_id: String
    let content: String
    let createdAt: Date
    let creator: Creator
}
