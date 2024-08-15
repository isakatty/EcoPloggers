//
//  TextFieldWithLabelView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import UIKit

import SnapKit

final class TextFieldWithLabelView: BaseView {
    var topLabelText: String
    
    private lazy var topLabel: PlainLabel = {
        let label = PlainLabel(labelText: topLabelText)
        label.configureUI(txtColor: Constant.Color.black, bgColor: Constant.Color.clear)
        label.font = Constant.Font.regular14
        return label
    }()
    let textField = UnderlineTextField()
    private let requiredLabel: PlainLabel = {
        let label = PlainLabel(labelText: "*")
        label.configureUI(txtColor: Constant.Color.black, bgColor: Constant.Color.clear)
        label.font = Constant.Font.regular13
        return label
    }()
    
    init(topLabelText: String) {
        self.topLabelText = topLabelText
        
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        [topLabel, requiredLabel, textField]
            .forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        super.configureLayout()
        backgroundColor = Constant.Color.clear
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(30)
        }
        requiredLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(topLabel.snp.trailing)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
    }
    func configureUI() {
        
    }
}
