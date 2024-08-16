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
        
        input.emailString
            .bind { email in
                print(email, "VM")
            }
            .disposed(by: disposeBag)
        input.pwString
            .bind { pw in
                print(pw, "VM")
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.emailString, input.pwString)
            .map { email, pw in
                return email.isValidEmail && pw.count >= 5
            }
            .bind(to: validation)
            .disposed(by: disposeBag)
        
        let emailObservable = input.emailString.asObservable()
        let passwordObservable = input.pwString.asObservable()
        
        input.logInEvent
            .withLatestFrom(Observable.combineLatest(emailObservable, passwordObservable))
            .flatMap { email, password in
                let loginQuery = LogInQuery(email: email, password: password)
                let loginRequest = UserRequest.login(login: loginQuery)
                return NetworkManager.shared.callUserRequest(endpoint: loginRequest, type: LoginResponse.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    /*
                     - UD 저장 / accessToken 들고 다녀야하나 ?
                     - UD에 뭐 저장해야하지 ? accessToken, refreshToken
                     */
                    loginSuccess.accept(true)
                    print(response)
//                    UserDefaultsManager.shared.accessToken = response.accessToken
//                    UserDefaultsManager.shared.refreshToken = response.refreshToken
                case .failure(let error):
                    // 로그인 실패 sign 보내줘야함
                    loginSuccess.accept(false)
                    print(error.localizedDescription)
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
