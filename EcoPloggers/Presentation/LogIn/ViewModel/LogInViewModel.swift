//
//  LogInViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import Foundation

import RxSwift
import RxCocoa

final class LogInViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let emailString: ControlProperty<String>
        let pwString: ControlProperty<String>
        let logInEvent: ControlEvent<Void>
        let signUpEvent: ControlEvent<Void>
    }
    struct Output {
        let validation: BehaviorRelay<Bool>
        let logInEvent: PublishRelay<Bool>
        let signUpEvent: ControlEvent<Void>
        let logInFailText: PublishRelay<String>
    }
    func transform(input: Input) -> Output {
        let validation = BehaviorRelay<Bool>(value: false)
        let logInFailText = PublishRelay<String>()
        let loginSuccess = PublishRelay<Bool>()
        
        Observable.combineLatest(input.emailString, input.pwString)
            .map { email, pw in
                return email.isValidEmail && pw.count >= 5
            }
            .bind(to: validation)
            .disposed(by: disposeBag)
        
        let emailObservable = input.emailString.asObservable()
        let passwordObservable = input.pwString.asObservable()
        
        input.logInEvent
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(emailObservable, passwordObservable))
            .flatMap { email, password in
                let loginQuery = LogInQuery(email: email, password: password)
                let loginRequest = UserRequest.login(login: loginQuery)
                return NetworkManager.shared.callUserRequest(endpoint: loginRequest, type: LoginResponse.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print(response)
                    UserDefaultsManager.shared.accessToken = response.accessToken
                    UserDefaultsManager.shared.refreshToken = response.refreshToken
                    loginSuccess.accept(true)
                case .failure(let error):
                    // 로그인 실패 sign 보내줘야함
                    switch error {
                    case .tempStatusCodeError(let statusCode):
                        print(UserStatusCode.login(errorCode: statusCode).errorDescription)
                    default:
                        print("Login StatusCode Default ")
                    }
                    loginSuccess.accept(false)
                    logInFailText.accept("로그인 실패! 다시 시도해주세요")
                }
            }
            .disposed(by: disposeBag)


        
        return Output(
            validation: validation,
            logInEvent: loginSuccess,
            signUpEvent: input.signUpEvent,
            logInFailText: logInFailText
        )
    }
}
