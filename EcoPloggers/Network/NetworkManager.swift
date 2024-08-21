//
//  NetworkManager.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/16/24.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callRequest<T: Decodable>(
        endpoint: TargetType,
        type: T.Type
    ) -> Single<T> {
        return Single.create { observer in
            do {
                let urlRequest = try endpoint.asURLRequest()
                AF.request(urlRequest, interceptor: NetworkInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let value):
                            observer(.success(value))
                        case .failure(let error):
                            observer(.failure(error))
                        }
                    }
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
}
