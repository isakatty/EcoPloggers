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
                                print("interceptor로 잡아줄 수 있나?")
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
                let urlRequest = try PostRouter.favoritePost(query: query).asURLRequest()
                
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
}
