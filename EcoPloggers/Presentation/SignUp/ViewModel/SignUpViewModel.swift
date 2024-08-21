//
//  SignUpViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import Foundation

import RxSwift
import RxCocoa

/*
 1. email 형식 맞는지 확인
 2. 그 validation에 의해 이메일 중복확인 버튼 활성화
 3. 버튼 탭 -> Network 통신
 4. 결과에 의해 output Text 내보내기 + bool 값
 */

final class SignUpViewModel: ViewModelType {
    let symbols = ["@","!","#","%","&","^","*"]
    private let nicknamePattern = "^[가-힣]{3,10}$"
    private let pwPattern = "[A-Za-z0-9!_@$%^&+=]{5,20}"
    
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String>
        let pwText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
        let emailValidateTap: ControlEvent<Void>
        let signUpBtnTap: ControlEvent<Void>
    }
    struct Output {
        let validatedEmailText: PublishRelay<String>
        let isValidatedEmail: PublishRelay<Bool>
        
        let validatedPWText: PublishRelay<String>
        let isvalidatedPW: PublishRelay<Bool>
        
        let validatedNickText: PublishRelay<String>
        let isValidatedNickname: PublishRelay<Bool>
        
        let emailValidationBtn: BehaviorRelay<Bool>
        let validationBtn: BehaviorRelay<Bool>
        let successSignUp: BehaviorRelay<Bool>
    }
    func transform(input: Input) -> Output {
        let isvalidatedPW: PublishRelay<Bool> = .init()
        let validatedPWText: PublishRelay<String> = .init()
        
        let isValidatedEmail = PublishRelay<Bool>()
        let validatedEmailText: PublishRelay<String> = .init()
        
        let isValidatedNickname = PublishRelay<Bool>()
        let validatedNicknameText: PublishRelay<String> = .init()
        
        let emailValidationBtn = BehaviorRelay<Bool>(value: false)
        let signUpValidation = BehaviorRelay<Bool>(value: false)
        let successSignup = BehaviorRelay<Bool>(value: false)
        
        let emailValidation = input.emailText
            .map { $0.isValidEmail }
        
        input.emailValidateTap
            .withLatestFrom(input.emailText.asObservable())
            .flatMap { emailText in
                print(emailText, "❓")
                let emailQuery = ValidateEmailQuery(email: emailText)
                return UserNetworkService.validateEmail(query: emailQuery)
                    .debug("이메일")
            }
            .subscribe { result in
                switch result {
                case .success(let resopnse):
                    isValidatedEmail.accept(true)
                    validatedEmailText.accept("사용 가능한 이메일!")
                case .badRequest:
                    print("요청 실패 - SignUpVM")
                case .invalidEmail:
                    isValidatedEmail.accept(false)
                    validatedEmailText.accept("사용 불가능한 이메일!")
                case .error(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)

        emailValidation
            .bind { isValidated in
                emailValidationBtn.accept(isValidated)
            }
            .disposed(by: disposeBag)
        
        input.pwText
            .withUnretained(self)
            .map { owner, password in
                let regex = try? NSRegularExpression(pattern: owner.pwPattern, options: [])
                let range = NSRange(location: 0, length: password.utf16.count)
                let match = regex?.firstMatch(in: password, options: [], range: range) != nil
                return match
            }
            .bind { isValidated in
                if isValidated {
                    validatedPWText.accept("가능한 비밀번호")
                } else {
                    validatedPWText.accept("5자 이상 20자 미만, 영어, 숫자, 특수문자 가능")
                }
                isvalidatedPW.accept(isValidated)
            }
            .disposed(by: disposeBag)
        
        input.nicknameText
            .withUnretained(self)
            .map { owner, nickname in
                let regex = try? NSRegularExpression(pattern: owner.nicknamePattern, options: [])
                let range = NSRange(location: 0, length: nickname.utf16.count)
                let match = regex?.firstMatch(in: nickname, options: [], range: range) != nil
                return match
            }
            .bind { isValidated in
                if isValidated {
                    validatedNicknameText.accept("가능한 닉네임")
                } else {
                    validatedNicknameText.accept("영어, 특수문자 불가능, 3~8자로 설정해주세요.")
                }
                isValidatedNickname.accept(isValidated)
            }
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(isValidatedEmail, isValidatedNickname, isValidatedNickname) { email, nickname, pw in
                return email && nickname && pw
            }
            .bind { allSatisfied in
                signUpValidation.accept(allSatisfied)
            }
            .disposed(by: disposeBag)
        
        input.signUpBtnTap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(input.emailText.asObservable(), input.pwText.asObservable(), input.nicknameText.asObservable()))
            .flatMap { email, password, nicknmae in
                let signUpQuery = SignUpQuery(email: email, password: password, nick: nicknmae)
                return UserNetworkService.signUpUser(query: signUpQuery)
            }
            .debug("회원가입")
            .subscribe { result in
                switch result {
                case .success(let respone):
                    successSignup.accept(true)
                case .badRequest:
                    print("bad Reuqest - Signup")
                case .whiteSpacesNickname:
                    print("빈문자열 에러")
                    validatedNicknameText.accept("닉네임엔 빈문자열을 포함할 수 없습니다.")
                case .alreadyOwned:
                    validatedNicknameText.accept("이미 사용중인 닉네임 입니다.")
                case .error(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)

        
        return Output(
            validatedEmailText: validatedEmailText,
            isValidatedEmail: isValidatedEmail,
            validatedPWText: validatedPWText,
            isvalidatedPW: isvalidatedPW,
            validatedNickText: validatedNicknameText,
            isValidatedNickname: isValidatedNickname,
            emailValidationBtn: emailValidationBtn,
            validationBtn: signUpValidation,
            successSignUp: successSignup
        )
    }
}
