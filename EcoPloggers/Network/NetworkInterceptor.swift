//
//  NetworkInterceptor.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/19/24.
//

import Foundation

import RxSwift
import Alamofire

final class NetworkInterceptor: RequestInterceptor {
    var disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        let token = UserDefaultsManager.shared.accessToken
        urlRequest.setValue(token, forHTTPHeaderField: Constant.NetworkHeader.authorization.rawValue)
               
       completion(.success(urlRequest))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let statusCode = request.response?.statusCode,
              statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }
        print(statusCode)
        
        let refreshEndpoint = UserRouter.refreshToken(refreshToken: UserDefaultsManager.shared.refreshToken)
        NetworkManager.shared.callRequest(endpoint: refreshEndpoint, type: RefreshResponse.self)
            .subscribe { result in
                UserDefaultsManager.shared.accessToken = result.accessToken
                completion(.retry)
            } onFailure: { error in
                print("Token Refresh Failed: \(error)")
                completion(.doNotRetryWithError(error))
            }
            .disposed(by: disposeBag)
    }
}
