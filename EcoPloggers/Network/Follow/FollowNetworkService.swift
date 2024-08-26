//
//  FollowNetworkService.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import Foundation

import Alamofire
import RxSwift

struct FollowNetworkService {
    static func follow(userID: String) -> Single<FollowResultType> {
        return Single.create { single in
            do {
                let urlRequet = try FollowRouter.follow(userID: userID).asURLRequest()
                AF.request(urlRequet, interceptor: NetworkInterceptor())
                    .responseDecodable(of: FollowResponse.self) { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(.success(data)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.invalidRequest))
                            case 401:
                                single(.success(.invalidToken))
                            case 403:
                                single(.success(.forbidden))
                            case 409:
                                single(.success(.alreadyFollowed))
                            case 410:
                                single(.success(.invalidUser))
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
    static func unFollow(userID: String) -> Single<UnfollowResultType> {
        return Single.create { single in
            do {
                let urlRequet = try FollowRouter.follow(userID: userID).asURLRequest()
                AF.request(urlRequet, interceptor: NetworkInterceptor())
                    .responseDecodable(of: FollowResponse.self) { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(.success(data)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.invalidRequest))
                            case 401:
                                single(.success(.invalidToken))
                            case 403:
                                single(.success(.forbidden))
                            case 410:
                                single(.success(.invalidUser))
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
}
