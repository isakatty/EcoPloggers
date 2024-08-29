//
//  ViewPostResponseDTO.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/18/24.
//

import Foundation

import RxSwift

struct ViewPostResponseDTO: Codable {
    let data: [ViewPostDetailResponseDTO]
    let next_cursor: String
}

extension ViewPostResponseDTO {
    var toDomainProperty: ViewPostResponse {
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
                    posted_date: $0.createdAt,
                    creator: $0.creator,
                    files: $0.files,
                    joins: $0.likes,
                    likes2: $0.likes2,
                    comments: $0.comments,
                    hashtags: $0.hashTags,
                    fileData: [],
                    prices: $0.price
                )
            },
            next_cursor: next_cursor
        )
    }
    func toDomain() -> Single<ViewPostResponse> {
        let fileData = data.map { dto in
            let files = dto.files.map { filePath in
                PostNetworkService.fetchFiles(filePath: filePath)
            }
            
            return Single.zip(files).map { files in
                return ViewPostDetailResponse.init(
                    post_id: dto.post_id,
                    product_id: dto.product_id,
                    title: dto.title,
                    content: dto.content,
                    required_time: dto.content1,
                    path: dto.content2,
                    recruits: dto.content3,
                    price: dto.content4,
                    due_date: dto.content5,
                    posted_date: dto.createdAt,
                    creator: dto.creator,
                    files: dto.files,
                    joins: dto.likes,
                    likes2: dto.likes2,
                    comments: dto.comments,
                    hashtags: dto.hashTags,
                    fileData: files,
                    prices: dto.price
                )
            }
        }
        
        return Single.zip(fileData).map { response in
            return ViewPostResponse(data: response, next_cursor: next_cursor)
        }
    }
}
struct ViewPostDetailResponseDTO: Codable {
    let post_id: String
    let product_id: String?
    let title: String
    let price: Int?
    let content: String
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let buyers: [String]
    let hashTags: [String]
    let comments: [Comment]
}
struct Creator: Codable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
struct Comment: Codable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: Creator
}
