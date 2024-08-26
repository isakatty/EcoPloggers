//
//  MeetupProfileInfoView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import UIKit

import SnapKit

final class MeetupProfileInfoView: BaseView {
    
    private let contentTitleLabel = PlainLabel(fontSize: Constant.Font.regular12, txtColor: Constant.Color.lightGray.withAlphaComponent(0.6))
    private let countLabel = PlainLabel(fontSize: Constant.Font.medium15, txtColor: Constant.Color.black.withAlphaComponent(0.7))
    
    init(content: String) {
        contentTitleLabel.text = content
        
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        [contentTitleLabel, countLabel]
            .forEach { addSubview($0) }
    }
    override func configureLayout() {
        contentTitleLabel.textAlignment = .center
        countLabel.textAlignment = .center
        contentTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4)
            make.horizontalEdges.equalToSuperview()
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTitleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureUI(count: Int) {
        countLabel.text = String(count)
    }
}
