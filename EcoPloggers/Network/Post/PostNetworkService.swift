//
//  PostNetworkService.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/21/24.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

struct PostNetworkService {
    static func fetchPost(postQuery: ViewPostQuery) -> Single<FetchPostResult> {
        return Single.create { single in
            do {
                let urlRequest = try PostRouter.viewPost(query: postQuery).asURLRequest()
                AF.request(urlRequest, interceptor: NetworkInterceptor())
                    .responseDecodable(of: ViewPostResponseDTO.self) { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(.success(data)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.badRequest))
                            case 401:
                                single(.success(.invalidToken))
                            case 403:
                                single(.success(.forbidden))
                            case 419:
                                single(.success(.expiredToken))
                            default:
                                single(.success(.error(.unknown)))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    static func fetchFavPost(query: FavoriteQuery) -> Single<FetchFavResult> {
        return Single.create { single in
            do {
                let urlRequest = try PostRouter.fetchFavoritePost(query: query).asURLRequest()
                
                AF.request(urlRequest, interceptor: NetworkInterceptor())
                    .responseDecodable(of: ViewPostResponseDTO.self) { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(.success(data)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.badRequest))
                            case 401:
                                single(.success(.invalidToken))
                            case 403:
                                single(.success(.forbidden))
                            case 410:
                                single(.success(.invalidPost))
                            case 419:
                                single(.success(.expiredToken))
                            default:
                                single(.success(.error(.unknown)))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    static func fetchHashtagPost(query: HashtagsQuery) -> Single<FetchHashtagsResult> {
        return Single.create { single in
            do {
                let urlRequest = try PostRouter.hashtags(query: query).asURLRequest()
                AF.request(urlRequest, interceptor: NetworkInterceptor())
                    .responseDecodable(of: ViewPostResponseDTO.self) { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(.success(data)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.badRequest))
                            case 401:
                                single(.success(.invalidToken))
                            case 403:
                                single(.success(.forbidden))
                            case 419:
                                single(.success(.expiredToken))
                            default:
                                single(.success(.error(.unknown)))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    static func removeMyPost(postID: String) -> Single<RemovePostResult> {
        return Single.create { single in
            let urlRequest: URLRequest
            do {
                urlRequest = try PostRouter.deletePost(postID: postID).asURLRequest()
            } catch {
                single(.success(.error(.invalidURL)))
                return Disposables.create()
            }
            
            AF.request(urlRequest, interceptor: NetworkInterceptor())
                .responseData { response in
                    let statusCode = response.response?.statusCode ?? 999
                    
                    switch statusCode {
                    case 200..<300:  // 성공 범위 (2xx)
                        single(.success(.success))
                    case 401:
                        single(.success(.invalidToken))
                    case 403:
                        single(.success(.forbidden))
                    case 410:
                        single(.success(.invalidPost))
                    case 419:
                        single(.success(.expiredToken))
                    case 445:
                        single(.success(.noPermission))
                    default:
                        single(.success(.error(CommonError(rawValue: statusCode) ?? .unknown)))
                    }
                }
            
            return Disposables.create()
        }
    }
    static func fetchSpecificPost(postId: String) -> Single<FetchPostResult> {
        return Single.create { single in
            let urlRequest: URLRequest
            do {
                urlRequest = try PostRouter.specificPost(postID: postId).asURLRequest()
            } catch {
                single(.success(.error(.invalidURL)))
                return Disposables.create()
            }
            
            AF.request(urlRequest, interceptor: NetworkInterceptor())
                .responseDecodable(of: ViewPostResponseDTO.self) { response in
                    switch response.result {
                    case .success(let response):
                        single(.success(.success(response)))
                    case .failure(_):
                        switch response.response?.statusCode {
                        case 400:
                            single(.success(.badRequest))
                        case 401:
                            single(.success(.invalidToken))
                        case 403:
                            single(.success(.forbidden))
                        case 419:
                            single(.success(.expiredToken))
                        default:
                            single(.success(.error(.unknown)))
                        }
                    }
                }
            return Disposables.create()
        }
    }
    static func fetchMyPosts(query: ViewPostQuery) -> Single<FetchPostResult> {
        return Single.create { single in
            
            let urlRequest: URLRequest
            do {
                urlRequest = try PostRouter.userPost(userID: UserDefaultsManager.shared.myUserID, query: query).asURLRequest()
            } catch {
                single(.success(.error(.invalidURL)))
                return Disposables.create()
            }
            
            AF.request(urlRequest, interceptor: NetworkInterceptor())
                .responseDecodable(of: ViewPostResponseDTO.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                    case .failure(_):
                        switch response.response?.statusCode {
                        case 400:
                            single(.success(.badRequest))
                        case 401:
                            single(.success(.invalidToken))
                        case 403:
                            single(.success(.forbidden))
                        case 419:
                            single(.success(.expiredToken))
                        default:
                            single(.success(.error(.unknown)))
                        }
                    }
                }
            
            return Disposables.create()
        }
    }
    static func editPost(postID: String, query: UploadPostQuery) -> Single<EditPostResultType> {
        return Single.create { single in
            let urlRequest: URLRequest
            do {
                urlRequest = try PostRouter.editPost(postID: postID, query: query).asURLRequest()
            } catch {
                single(.success(.error(.invalidURL)))
                return Disposables.create()
            }
            
            AF.request(urlRequest, interceptor: NetworkInterceptor())
                .responseDecodable(of: ViewPostDetailResponseDTO.self) { response in
                    switch response.result {
                    case .success(let response):
                        single(.success(.success(response)))
                    case .failure(_):
                        switch response.response?.statusCode {
                        case 400:
                            single(.success(.badRequest))
                        case 401:
                            single(.success(.invalidToken))
                        case 403:
                            single(.success(.forbidden))
                        case 410:
                            single(.success(.emptyPost))
                        case 419:
                            single(.success(.expiredToken))
                        case 445:
                            single(.success(.noPermission))
                        default:
                            single(.success(.error(CommonError(rawValue: response.response?.statusCode ?? 999) ?? .unknown)))
                        }
                    }
                }
            
            return Disposables.create()
        }
    }
    
    static func fetchFiles(filePath: String) -> Single<Data> {
        return Single.create { single in
            
            do {
                let urlRequest = try PostRouter.fetchImage(query: filePath).asURLRequest()
                AF.request(urlRequest, interceptor: NetworkInterceptor())
                    .responseData { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    static func uploadImg(uploadQuery: Data) -> Single<UploadImageResponse> {
        return Single.create { single in
            let urlRequest: URLRequest
            do {
                // URLRequest 생성
                urlRequest = try PostRouter.uploadImg(query: uploadQuery).asURLRequest()
            } catch {
                single(.failure(error))
                return Disposables.create()
            }
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(uploadQuery, withName: "files", fileName: "image.png", mimeType: "image/png")
            }, with: urlRequest)
            .responseDecodable(of: UploadImageResponse.self) { response in
                switch response.result {
                case .success(let uploadModel):
                    dump(uploadModel)
                    single(.success(uploadModel))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    static func uploadPost(postQuery: UploadPostQuery) -> Single<UploadPostResultType> {
        return Single.create { single in
            let urlRequest: URLRequest
            do {
                urlRequest = try PostRouter.uploadPost(query: postQuery).asURLRequest()
            } catch {
                single(.failure(error))
                return Disposables.create()
            }
            AF.request(urlRequest, interceptor: NetworkInterceptor())
                .responseDecodable(of: ViewPostDetailResponseDTO.self) { response in
                    switch response.result {
                    case .success(let response):
                        single(.success(.success(response)))
                    case .failure(let error):
                        print(error)
                        switch response.response?.statusCode {
                        case 400:
                            single(.success(.badRequest))
                        case 401:
                            single(.success(.invalidToken))
                        case 403:
                            single(.success(.forbidden))
                        case 410:
                            single(.success(.emptyPost))
                        case 419:
                            single(.success(.expiredToken))
                        default:
                            single(.success(.error(CommonError(rawValue: response.response?.statusCode ?? 999) ?? .unknown)))
                        }
                    }
                }
            
            return Disposables.create()
        }
    }
    
    static func likePost(postId: String, likeQuery: LikePostQuery) -> Single<LikePostResultType> {
        return Single.create { single in
            let likeRouter = PostRouter.likePost(postID: postId, query: likeQuery)
            
            let urlRequset: URLRequest
            do {
                urlRequset = try likeRouter.asURLRequest()
            } catch {
                single(.failure(error))
                return Disposables.create()
            }
            
            AF.request(urlRequset, interceptor: NetworkInterceptor())
                .responseDecodable(of: LikePostQuery.self) { response in
                    switch response.result {
                    case .success(let result):
                        single(.success(.success(result)))
                    case .failure(_):
                        switch response.response?.statusCode {
                        case 400:
                            single(.success(.badRequest))
                        case 401:
                            single(.success(.invalidToken))
                        case 403:
                            single(.success(.forbidden))
                        case 410:
                            single(.success(.disappearPost))
                        case 419:
                            single(.success(.expiredToken))
                        default:
                            single(.success(.error(CommonError(rawValue: response.response?.statusCode ?? 999) ?? .unknown)))
                        }
                    }
                }
            
            return Disposables.create()
        }
    }
}
