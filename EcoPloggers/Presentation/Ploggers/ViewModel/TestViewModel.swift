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
        
        /*
         함수로 나눠야함 ~!
         - post 조회
            -> 성공
            -> 실패
                -> status code 확인
                    - 토큰 갱신
                        - 성공
                            - 다시 post 조회
                        - 실패
                            - status Code
                                - 419? 로그인 화면으로 변경

         */
        /*
        NetworkManager.shared.callUserRequest(endpoint: postRequest, type: ViewPostResponseDTO.self)
            .asObservable()
            .subscribe { result in
                switch result {
                case .success(let response):
                    print(response.toDomain)
                case .failure(let error):
                    switch error {
                    case .tempStatusCodeError(let statusCode):
                        // 여기서 statusCode에 따라 accessToken 갱신 요청 -> 1. 갱신 -> 이후 통신 or 2. 로그인 페이지
                        if statusCode == 419 || statusCode == 401 {
                            let refreshToken = UserRequest.refreshToken(refreshToken: UserDefaultsManager.shared.refreshToken)
                            NetworkManager.shared.callUserRequest(endpoint: refreshToken, type: RefreshResponse.self)
                                .asObservable()
                                .subscribe { result in
                                    switch result {
                                    case .success(let response):
                                        UserDefaultsManager.shared.accessToken = response.accessToken
                                    case .failure(let error):
                                        switch error {
                                        case .tempStatusCodeError(let statusCode):
                                            print(statusCode)
                                        default:
                                            print("네?")
                                        }
                                    }
                                } onError: { error in
                                    print("error")
                                }
                                .disposed(by: self.disposeBag)

                        }
                    default:
                        print(error.errorDescription, "??")
                    }
                }
            } onError: { error in
                print("error")
            }
            .disposed(by: disposeBag)
         */
        
        let loginQuery = LogInQuery(email: "eco@eco1.com", password: "qwerty")
        let endpoint = UserRouter.login(login: loginQuery)
        NetworkManager.shared.callRequest(endpoint: endpoint, type: LoginResponse.self)
            .asObservable()
            .subscribe { result in
                switch result {
                case .success(let loginResponse):
                    print(loginResponse)
                case .failure(let error):
                    switch error {
                    case .tempStatusCodeError(let statusCode):
                        print(statusCode, error.errorDescription)
                    default:
                        print(error.localizedDescription)
                    }
                }
            } onError: { err in
                print(err, "아예 Failure")
            }
            .disposed(by: disposeBag)


    }
    
    struct Input {
        
    }
    struct Output {
        let sectionData: BehaviorRelay<[MainDataSection]>
    }
    
    func transform(input: Input) -> Output {
        let sectionData: BehaviorRelay<[MainDataSection]> = .init(value: [])
        
        /* 목데이터임 */
        NetworkManager.shared.callMockData()
            .asObservable()
            .subscribe { result in
                switch result {
                case .success(let response):
                    
                    let first = MainDataSection(header: "Banner", items: response.toDomain.data)
                    let second = MainDataSection(header: "지금 뜨는 플로깅 모임", items: response.toDomain.data)
                    let third = MainDataSection(header: "플로깅 모임", items: response.toDomain.data)
                    let sections = [first, second, third]
                    sectionData.accept(sections)
                    
                case .failure(let error):
                    print(error.localizedDescription, "?")
                }
            } onError: { error in
                print(error, "?")
            }
            .disposed(by: disposeBag)
        
        return Output(
            sectionData: sectionData
        )
    }
}
