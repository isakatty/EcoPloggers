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
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let statusCode = request.response?.statusCode, statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let refreshEndpoint = UserRouter.refreshToken(refreshToken: UserDefaultsManager.shared.refreshToken)
        NetworkManager.shared.callRequest(endpoint: refreshEndpoint, type: RefreshResponse.self)
            .subscribe { result in
                switch result {
                case .success(let refresh):
                    print("Token Refresh Success")
                    UserDefaultsManager.shared.accessToken = refresh.accessToken
                    completion(.retry)
                case .failure(let error):
                    print("Token Refresh Failed: \(error)")
                    completion(.doNotRetryWithError(error))
                }
            } onFailure: { error in
                print("Token Refresh Failed: \(error)")
                completion(.doNotRetryWithError(error))
            }
            .disposed(by: disposeBag)
            
    }
}
