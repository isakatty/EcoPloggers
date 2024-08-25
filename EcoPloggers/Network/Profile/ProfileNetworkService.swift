//
//  ProfileNetworkService.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

struct ProfileNetworkService {
    static func fetchMyProfile() -> Single<ProfileResultType> {
        return Single.create { single in
            do {
                let urlRequest = try ProfileRouter.myProfile.asURLRequest()
                AF.request(urlRequest, interceptor: NetworkInterceptor())
                    .responseDecodable(of: ProfileResponse.self) { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(.success(data)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 401:
                                single(.success(.invalidToken))
                            case 403:
                                single(.success(.forbidden))
                            case 419:
                                single(.success(.invalidToken))
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
