//
//  RealmModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 9/2/24.
//

import Foundation

import RealmSwift

enum RealmError: Error {
    case create
    case update
    case delete
}
extension RealmError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .create:
            "user 생성 오류"
        case .update:
            "user 업데이트 오류"
        case .delete:
            "user 삭제 오류"
        }
    }
}

final class SeenPosts: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var post_id: String
    @Persisted var product_id: String?
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var required_time: String?
    @Persisted var path: String?
    @Persisted var recruits: String?
    @Persisted var price: String?
    @Persisted var due_date: String?
    @Persisted var posted_date: String
    @Persisted var creator: CreatorRealm?
    @Persisted var files = List<String>()
    @Persisted var joins = List<String>()
    @Persisted var likes2 = List<String>()
    @Persisted var comments: List<CommentRealm>
    @Persisted var hashtags = List<String>()
    @Persisted var prices: Int?
    
    convenience init(
        post_id: String,
        product_id: String? = nil,
        title: String,
        content: String,
        required_time: String? = nil,
        path: String? = nil,
        recruits: String? = nil,
        price: String? = nil,
        due_date: String? = nil,
        posted_date: String,
        creator: CreatorRealm,
        files: List<String>,
        joins: List<String>,
        likes2: List<String>,
        comments: List<CommentRealm>,
        hashtags: List<String>,
        prices: Int? = nil
    ) {
        self.init()
        
        self.id = UUID().uuidString
        self.post_id = post_id
        self.product_id = product_id
        self.title = title
        self.content = content
        self.required_time = required_time
        self.path = path
        self.recruits = recruits
        self.price = price
        self.due_date = due_date
        self.posted_date = posted_date
        self.creator = creator
        self.files = files
        self.joins = joins
        self.likes2 = likes2
        self.comments = comments
        self.hashtags = hashtags
        self.prices = prices
    }
}

final class CreatorRealm: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var user_id: String
    @Persisted var nick: String
    @Persisted var profileImage: String?
    
    convenience init(
        user_id: String,
        nick: String,
        profileImage: String? = nil
    ) {
        self.init()
        
        self.id = UUID().uuidString
        self.user_id = user_id
        self.nick = nick
        self.profileImage = profileImage
    }
}
final class CommentRealm: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var comment_id: String
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var creator: CreatorRealm?
    
    convenience init(
        comment_id: String,
        content: String,
        createdAt: String,
        creator: CreatorRealm
    ) {
        self.init()
        
        self.id = UUID().uuidString
        self.comment_id = comment_id
        self.content = content
        self.createdAt = createdAt
        self.creator = creator
    }
}
