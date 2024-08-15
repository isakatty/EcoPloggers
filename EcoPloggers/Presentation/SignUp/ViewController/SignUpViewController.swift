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
        btn.unavailableBtn()
        return btn
    }()
    private let joinBtn: RoundedButton = {
        let btn = RoundedButton(title: "회원가입")
        btn.availableBtn()
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationLeftBar(action: nil)
        bind()
    }
    private func bind() {
        let input = SignUpViewModel.Input()
        let output = viewModel.transform(input: input)
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
            make.height.equalTo(60)
        }
        validationBtn.snp.makeConstraints { make in
            make.leading.equalTo(emailView.snp.trailing)
            make.width.equalTo(100)
            make.trailing.equalTo(safeArea).inset(10)
            make.height.equalTo(50)
            make.centerY.equalTo(emailView.snp.centerY)
        }
        pwView.snp.makeConstraints { make in
            make.top.equalTo(emailView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeArea)
            make.centerX.equalTo(safeArea)
            make.height.equalTo(60)
        }
        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(pwView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeArea)
            make.centerX.equalTo(safeArea)
            make.height.equalTo(60)
        }
        joinBtn.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).inset(30)
            make.centerX.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(30)
            make.height.equalTo(50)
        }
    }
}
