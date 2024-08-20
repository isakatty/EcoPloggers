//
//  RealViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/19/24.
//

import Foundation

import RxSwift
import RxCocoa

final class RealViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let btnTapEvent: ControlEvent<Void>
    }
    struct Output {
        let idTxt: PublishRelay<String>
        let pwTxt: PublishRelay<String>
    }
    func transform(input: Input) -> Output {
        let idTxt: PublishRelay<String> = .init()
        let pwTxt: PublishRelay<String> = .init()
        
//        input.btnTapEvent
//            .map { _ in
//                let loginQuery = LogInQuery(email: "eco@eco.com", password: "qwerty")
//                return loginQuery
//            }
//            .flatMap { query in
//                let endpoint = UserRouter.login(login: query)
//                return NetworkManager.shared.callRequest(endpoint: endpoint, type: LoginResponse.self)
//            }
//            .subscribe { result in
//                switch result {
//                case .success(let response):
//                    print(response)
//                    
//                    UserDefaultsManager.shared.accessToken = response.accessToken
//                    UserDefaultsManager.shared.refreshToken = response.refreshToken
//                    
//                    idTxt.accept(response.email)
//                    pwTxt.accept(response.user_id)
//                case .failure(let error):
//                    switch error {
//                    case .tempStatusCodeError(let statusCode):
//                        print(statusCode, error)
//                        print(UserStatusCode.login(errorCode: statusCode).errorDescription, "4")
//                        
//                    default:
//                        print(error)
//                    }
//                }
//            } onError: { error in
//                print(error)
//            }
//            .disposed(by: disposeBag)
        input.btnTapEvent
            .map { _ in
                let viewPost = ViewPostQuery(next: "", limit: "5", product_id: "ecoPloggers_rising")
                return viewPost
            }
            .flatMap { query in
                let endpoint = PostRouter.viewPost(query: query)
                return NetworkManager.shared.callRequest(endpoint: endpoint, type: ViewPostResponseDTO.self)
            }
            .subscribe { result in
                switch result {
                case .success(let response):
                    print(response.toDomain)
                case .failure(let error):
                    switch error {
                    case .tempStatusCodeError(let status):
                        print(status)
                    default:
                        print(error)
                    }
                }
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)

            
        
        return Output(idTxt: idTxt, pwTxt: pwTxt)
    }
}
