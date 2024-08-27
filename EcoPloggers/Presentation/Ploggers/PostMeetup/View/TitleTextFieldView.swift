//
//  TitleTextFieldView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/27/24.
//

import UIKit

import SnapKit

final class TitleTextFieldView: BaseView {
    
    private let titlePlainLabel = PlainLabel(fontSize: Constant.Font.medium13, txtColor: Constant.Color.black)
    let textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = Constant.Color.clear
        return tf
    }()
    private let tfCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.white
        view.layer.borderColor = Constant.Color.lightGray.withAlphaComponent(0.6).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
        return view
    }()
    
    init(title: String, placeholder: String) {
        titlePlainLabel.text = title
        textField.placeholder = placeholder
        
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        [titlePlainLabel, tfCoverView]
            .forEach { addSubview($0) }
        
        tfCoverView.addSubview(textField)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titlePlainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
            make.height.equalTo(15)
        }
        tfCoverView.snp.makeConstraints { make in
            make.leading.equalTo(titlePlainLabel)
            make.top.equalTo(titlePlainLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(16)
        }
        textField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
}
