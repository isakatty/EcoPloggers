//
//  ContentsView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/18/24.
//

import UIKit

import SnapKit

final class ContentsView: BaseView {
    private let headerTitle = PlainLabel(fontSize: Constant.Font.medium20)
    private let firstContent = ImgWithTitleView()
    private let clearView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.clear
        view.clipsToBounds = true
        return view
    }()
    private let secondContent = ImgWithTitleView()
    private let addLabel = PlainLabel(fontSize: Constant.Font.regular13)
    
    override func configureHierarchy() {
        [headerTitle, addLabel, firstContent, clearView, secondContent]
            .forEach { addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        headerTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(10)
        }
        addLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerTitle)
            make.trailing.equalToSuperview().inset(20)
        }
        firstContent.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
        clearView.snp.makeConstraints { make in
            make.leading.equalTo(firstContent.snp.trailing)
            make.trailing.equalTo(secondContent.snp.leading)
            make.top.equalTo(headerTitle.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(35)
        }
        secondContent.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
        headerTitle.text = "주간 인기글"
        addLabel.text = "더보기"
        addLabel.textColor = Constant.Color.black.withAlphaComponent(0.5)
    }
}
