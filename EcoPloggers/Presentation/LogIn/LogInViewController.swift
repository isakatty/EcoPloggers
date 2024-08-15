//
//  LogInViewController.swift
//  EcoPloggers
//
//  Created by Jisoo HAM on 8/14/24.
//

import UIKit

import SnapKit

final class LogInViewController: BaseViewController {
    private let loginBtn = RoundedButton(title: "로그인")
    private let idLabel: PlainLabel = {
        let lb = PlainLabel(labelText: "이메일 주소")
        lb.configureUI(txtColor: Constant.Color.black, bgColor: Constant.Color.clear)
        lb.font = Constant.Font.regular14
        return lb
    }()
    private let idTextField: UnderlineTextField = {
        let tf = UnderlineTextField()
        tf.placeholder = "예) ecoPloggers@Ecoploggers.com"
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
        return tf
    }()
    private let signUpBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("이메일 가입", for: .normal)
        btn.setTitleColor(Constant.Color.black, for: .normal)
        btn.backgroundColor = Constant.Color.clear
        return btn
    }()
    
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

