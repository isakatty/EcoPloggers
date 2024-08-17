//
//  SignUpViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class SignUpViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    
    private let viewModel = SignUpViewModel()
    
    private let emailView: TextFieldWithLabelView = {
        let view = TextFieldWithLabelView(topLabelText: "이메일주소")
        view.textField.placeholder = "예) id@id.com"
        return view
    }()
    private let pwView: TextFieldWithLabelView = {
        let view = TextFieldWithLabelView(topLabelText: "비밀번호")
        return view
    }()
    private let nicknameView: TextFieldWithLabelView = {
        let view = TextFieldWithLabelView(topLabelText: "닉네임")
        return view
    }()
    private let validationBtn: RoundedButton = {
        let btn = RoundedButton(title: "이메일 확인")
        return btn
    }()
    private let joinBtn: RoundedButton = {
        let btn = RoundedButton(title: "회원가입")
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationLeftBar(action: nil)
        bind()
    }
    private func bind() {
        let input = SignUpViewModel.Input(
            emailText: emailView.textField.rx.text.orEmpty,
            pwText: pwView.textField.rx.text.orEmpty,
            nicknameText: nicknameView.textField.rx.text.orEmpty,
            emailValidateTap: validationBtn.rx.tap,
            signUpBtnTap: joinBtn.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.emailValidationBtn
            .bind(with: self) { owner, isValidated in
                if isValidated {
                    owner.validationBtn.availableBtn()
                } else {
                    owner.validationBtn.unavailableBtn()
                }
            }
            .disposed(by: disposeBag)
        
        output.validationBtn
            .bind(with: self) { owner, isValidated in
                if isValidated {
                    owner.joinBtn.availableBtn()
                } else {
                    owner.joinBtn.unavailableBtn()
                }
            }
            .disposed(by: disposeBag)
        
        output.isvalidatedPW
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isValidatedPW in
                let textColor = isValidatedPW ? Constant.Color.core : Constant.Color.carrotOrange
                owner.pwView.configureTextColor(color: textColor)
            }
            .disposed(by: disposeBag)
        
        output.validatedPWText
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, text in
                owner.pwView.validationLabel.text = text
            }
            .disposed(by: disposeBag)
        
        output.validatedEmailText
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, text in
                if text != "사용 가능한 이메일입니다." {
                    owner.emailView.validationLabel.text = text
                    owner.emailView.configureTextColor(color: Constant.Color.carrotOrange)
                } else {
                    owner.emailView.validationLabel.text = text
                    owner.emailView.configureTextColor(color: Constant.Color.core)
                }
            }
            .disposed(by: disposeBag)
        
        output.validatedNickText
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, text in
                owner.nicknameView.validationLabel.text = text
            }
            .disposed(by: disposeBag)
        output.isValidatedNickname
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isValidatedNickname in
                let textColor = isValidatedNickname ? Constant.Color.core : Constant.Color.carrotOrange
                owner.nicknameView.configureTextColor(color: textColor)
            }
            .disposed(by: disposeBag)
        output.successSignUp
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isSignedUp in
                if isSignedUp {
                    print("로그인 페이지로 이동")
                    let loginVC = LogInViewController()
                    owner.setRootViewController(UINavigationController(rootViewController: loginVC))
                }
            }
            .disposed(by: disposeBag)
    }
    override func configureHierarchy() {
        [emailView, validationBtn, pwView, nicknameView, joinBtn]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        emailView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(50)
            make.leading.equalTo(safeArea)
        }
        validationBtn.snp.makeConstraints { make in
            make.leading.equalTo(emailView.snp.trailing)
            make.width.equalTo(100)
            make.trailing.equalTo(safeArea).inset(10)
            make.height.equalTo(50)
            make.centerY.equalTo(emailView.snp.centerY)
        }
        pwView.snp.makeConstraints { make in
            make.top.equalTo(emailView.snp.bottom).offset(18)
            make.horizontalEdges.equalTo(safeArea)
            make.centerX.equalTo(safeArea)
        }
        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(pwView.snp.bottom).offset(18)
            make.horizontalEdges.equalTo(safeArea)
            make.centerX.equalTo(safeArea)
        }
        joinBtn.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).inset(30)
            make.centerX.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(30)
            make.height.equalTo(50)
        }
    }
}
