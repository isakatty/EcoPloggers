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
                return UserNetworkService.createLogin(query: loginQuery)
            }
            .debug("VM")
            .subscribe { result in
                switch result {
                case .success(let response):
                    UserDefaultsManager.shared.accessToken = response.accessToken
                    UserDefaultsManager.shared.refreshToken = response.refreshToken
                case .badRequest:
                    print("bad Request") // MARK: validation 때문에 badRequest가 필요한지에 대한 의문
                case .unauthorized:
                    logInFailText.accept("로그인 실패! 계정을 확인해주세요.")
                case .error(let error):
                    print("에러 발생: \(error.localizedDescription)")
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
