//
//  PostRouter.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/19/24.
//

import Foundation

import Alamofire

enum PostRouter {
    case uploadImg(query: Data)
    case uploadPost(query: UploadPostQuery)
    case viewPost(query: ViewPostQuery)
    case specificPost(postID: String)
    case editPost(postID: String, query: UploadPostQuery)
    case deletePost(postID: String)
    case userPost(userID: String, query: ViewPostQuery)
    case fetchFavoritePost(query: FavoriteQuery)
    case hashtags(query: HashtagsQuery)
    case fetchImage(query: String)
    case likePost(postID: String, query: LikePostQuery)
}
extension PostRouter: TargetType {
    var baseURL: String {
        guard let base = Constant.NetworkComponents.baseURL else { return "" }
        return base
    }
    
    var method: HTTPMethod {
        switch self {
        case .uploadImg, .uploadPost:
                .post
        case .viewPost, .specificPost, .userPost, .fetchFavoritePost, .hashtags, .fetchImage:
                .get
        case .editPost:
                .put
        case .deletePost:
                .delete
        case .likePost:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .uploadImg:
            return "/v1/posts/files"
        case .uploadPost:
            return "/v1/posts"
        case .viewPost:
            return "/v1/posts"
        case .specificPost(let postID):
            return "/v1/posts/\(postID)"
        case .editPost(let postID, _):
            return "/v1/posts/\(postID)"
        case .deletePost(let postID):
            return "/v1/posts/\(postID)"
        case .userPost(let userID, _):
            return "/v1/posts/users/\(userID)"
        case .fetchFavoritePost:
            return "/v1/posts/likes-2/me"
        case .hashtags:
            return "/v1/posts/hashtags"
        case .fetchImage(let query):
            return "/v1/\(query)"
        case .likePost(let postID, _):
            return "/v1/posts\(postID)/like"
        }
    }
    
    var header: HTTPHeaders {
        guard let apiKey = Constant.NetworkComponents.apiKey else {
            print("🔑 API Key error")
            return ["": ""]
        }
        let baseHeaders: HTTPHeaders = [
            Constant.NetworkHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
            Constant.NetworkHeader.sesacKey.rawValue: apiKey
        ]
        switch self {
        case .uploadImg:
            return [
                Constant.NetworkHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                Constant.NetworkHeader.sesacKey.rawValue: apiKey,
                Constant.NetworkHeader.contentType.rawValue: Constant.NetworkHeader.multipart.rawValue
            ]
        case .uploadPost, .editPost:
            return [
                Constant.NetworkHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                Constant.NetworkHeader.sesacKey.rawValue: apiKey,
                Constant.NetworkHeader.contentType.rawValue: Constant.NetworkHeader.json.rawValue
            ]
        case .viewPost, .specificPost, .deletePost, .userPost, .fetchFavoritePost, .hashtags, .fetchImage, .likePost:
            return baseHeaders
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .uploadImg, .uploadPost, .likePost:
            return nil
        case .viewPost(let viewPostQuery):
            return [
                URLQueryItem(name: "next", value: viewPostQuery.next),
                URLQueryItem(name: "limit", value: viewPostQuery.limit ?? "10"),
                URLQueryItem(name: "product_id", value: viewPostQuery.product_id)
            ]
        case .specificPost, .editPost, .deletePost, .fetchImage:
            return nil
        case .userPost( _, let viewPostQuery):
            return [
                URLQueryItem(name: "next", value: viewPostQuery.next),
                URLQueryItem(name: "limit", value: viewPostQuery.limit ?? "10"),
                URLQueryItem(name: "product_id", value: viewPostQuery.product_id)
            ]
        case .fetchFavoritePost(let favoriteQuery):
            return [
                URLQueryItem(name: "next", value: favoriteQuery.next),
                URLQueryItem(name: "limit", value: favoriteQuery.limit ?? "10")
            ]
        case .hashtags(let hashtagsQuery):
            return [
                URLQueryItem(name: "next", value: hashtagsQuery.next),
                URLQueryItem(name: "limit", value: hashtagsQuery.limit ?? "10"),
                URLQueryItem(name: "product_id", value: hashtagsQuery.product_id),
                URLQueryItem(name: "hashTag", value: hashtagsQuery.hashTag)
            ]
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        
        switch self {
        case .uploadImg:
            return nil
        case .uploadPost(let post):
            return try? encoder.encode(post)
        case .viewPost:
            return nil
        case .specificPost:
            return nil
        case .editPost(_, let post):
            return try? encoder.encode(post)
        case .deletePost:
            return nil
        case .userPost, .fetchFavoritePost, .hashtags, .fetchImage:
            return nil
        case .likePost(_, let query):
            return try? encoder.encode(query)
        }
    }
    
    var multipartBody: Data? {
        switch self {
        case .uploadImg(let query):
            return query
        default:
            return nil
        }
    }
}
