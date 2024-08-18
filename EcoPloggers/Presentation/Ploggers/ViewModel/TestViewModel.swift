//
//  TestViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/18/24.
//

import Foundation

import RxSwift
import RxCocoa

final class TestViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    private var accessToken: String
    private let dataCount: String = "2"
    
    init() {
        accessToken = UserDefaultsManager.shared.accessToken
        
        let viewPostQuery = ViewPostQuery(next: nil, limit: "3", product_id: "ecoPloggers_rising")
        let postRequest = PostRequest.viewPost(viewPostQuery)

//        guard let urlRequest = postRequest.toURLRequest else { return }
//        
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            
//            if let data = data,
//               let textData = String(data: data, encoding: .utf8) {
//                print(textData)
//            } else {
//                print("네?")
//            }
//        }.resume()
        
        
//        NetworkManager.shared.callUserRequest(endpoint: postRequest, type: ViewPostResponseDTO.self)
//            .asObservable()
//            .subscribe { result in
//                switch result {
//                case .success(let response):
//                    print(response.toDomain)
//                case .failure(let error):
//                    switch error {
//                    case .tempStatusCodeError(let statusCode):
//                        // 여기서 statusCode에 따라 accessToken 갱신 요청 -> 1. 갱신 -> 이후 통신 or 2. 로그인 페이지
//                        if statusCode == 419 || statusCode == 401 {
//                            let refreshToken = UserRequest.refreshToken(refreshToken: UserDefaultsManager.shared.refreshToken)
//                            NetworkManager.shared.callUserRequest(endpoint: refreshToken, type: RefreshResponse.self)
//                                .asObservable()
//                                .subscribe { result in
//                                    switch result {
//                                    case .success(let response):
//                                        UserDefaultsManager.shared.accessToken = response.accessToken
//                                    case .failure(let error):
//                                        switch error {
//                                        case .tempStatusCodeError(let statusCode):
//                                            print(statusCode)
//                                        default:
//                                            print("네?")
//                                        }
//                                    }
//                                } onError: { error in
//                                    print("error")
//                                }
//                                .disposed(by: self.disposeBag)
//
//                        }
//                    default:
//                        print(error.errorDescription, "??")
//                    }
//                }
//            } onError: { error in
//                print("error")
//            }
//            .disposed(by: disposeBag)

    }
    
    struct Input {
        
    }
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
