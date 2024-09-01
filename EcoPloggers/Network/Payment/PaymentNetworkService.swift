//
//  PaymentNetworkService.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 9/1/24.
//

import Foundation

import Alamofire
import RxSwift

struct PaymentNetworkService {
    static func validatePayment(query: PaymentQuery) -> Single<PaymentResultType> {
        return Single.create { single in
            var urlRequest: URLRequest
            do {
                urlRequest = try PaymentRouter.payment(query: query).asURLRequest()
            } catch {
                single(.success(.error(.invalidURL)))
                return Disposables.create()
            }
            AF.request(urlRequest, interceptor: NetworkInterceptor())
                .responseDecodable(of: PaymentValidationResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        single(.success(.success(result)))
                    case .failure(_):
                        switch response.response?.statusCode {
                        case 400:
                            single(.success(.invalidPayment))
                        case 401:
                            single(.success(.invalidToken))
                        case 403:
                            single(.success(.forbidden))
                        case 409:
                            single(.success(.alreadyValidated))
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
    
    static func paymentList() -> Single<PaymentListResultType> {
        return Single.create { single in
            
            let urlRequest: URLRequest
            do {
                urlRequest = try PaymentRouter.paymentList.asURLRequest()
            } catch {
                single(.success(.error(.invalidURL)))
                return Disposables.create()
            }
            
            AF.request(urlRequest, interceptor: NetworkInterceptor())
                .responseDecodable(of: PaymentListResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        single(.success(.success(result)))
                    case .failure(_):
                        switch response.response?.statusCode {
                        case 401:
                            single(.success(.invalidToken))
                        case 403:
                            single(.success(.forbidden))
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
