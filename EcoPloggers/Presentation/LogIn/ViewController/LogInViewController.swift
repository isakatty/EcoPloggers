//
//  LogInViewController.swift
//  EcoPloggers
//
//  Created by Jisoo HAM on 8/14/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class LogInViewController: BaseViewController {
    private let viewModel = LogInViewModel()
    
    private let loginBtn: RoundedButton = {
        let btn = RoundedButton(title: "로그인")
        return btn
    }()
    private let idLabel: PlainLabel = {
        let lb = PlainLabel(labelText: "이메일 주소")
        lb.configureUI(txtColor: Constant.Color.black, bgColor: Constant.Color.clear)
        lb.font = Constant.Font.regular14
        return lb
    }()
    private let idTextField: UnderlineTextField = {
        let tf = UnderlineTextField()
        tf.placeholder = "예) id@id.com"
        tf.keyboardType = .emailAddress
        return tf
    }()
    private let pwLabel: PlainLabel = {
        let lb = PlainLabel(labelText: "비밀번호")
        lb.configureUI(txtColor: Constant.Color.black, bgColor: Constant.Color.clear)
        lb.font = Constant.Font.regular14
        return lb
    }()
    private let pwTextField: UnderlineTextField = {
        let tf = UnderlineTextField()
        tf.isSecureTextEntry = true
        tf.placeholder = "5자 이상"
        return tf
    }()
    private let signUpBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("이메일 가입", for: .normal)
        btn.setTitleColor(Constant.Color.black, for: .normal)
        btn.backgroundColor = Constant.Color.clear
        return btn
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        let input = LogInViewModel.Input(
            emailString: idTextField.rx.text.orEmpty,
            pwString: pwTextField.rx.text.orEmpty,
            logInEvent: loginBtn.rx.tap,
            signUpEvent: signUpBtn.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.logInEvent
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, success in
                // 로그인된 정보를 들고 화면 전환
                if success {
                    let vc = PloggersViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.signUpEvent
            .bind(with: self) { owner, _ in
                let vc = SignUpViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self) { owner, validation in
                if validation {
                    owner.loginBtn.availableBtn()
                } else {
                    owner.loginBtn.unavailableBtn()
                }
            }
            .disposed(by: disposeBag)
        
        output.logInFailText
            .bind(with: self) { owner, text in
                print(text, "VC")
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [idLabel, idTextField, pwLabel, pwTextField, loginBtn, signUpBtn]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        idLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeArea).inset(30)
            make.top.equalTo(safeArea).offset(50)
        }
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        pwLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeArea).inset(30)
            make.top.equalTo(idTextField.snp.bottom).offset(50)
        }
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea)
            make.top.equalTo(pwTextField.snp.bottom).offset(50)
            make.height.equalTo(55)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        signUpBtn.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea)
            make.top.equalTo(loginBtn.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        
    }
}

