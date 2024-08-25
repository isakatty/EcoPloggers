//
//  FollowingButton.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import UIKit

import SnapKit

final class FollowingButton: UIButton {
    
    private let fixedLabel = PlainLabel(fontSize: Constant.Font.medium15, txtColor: Constant.Color.black.withAlphaComponent(0.7))
    private let countLabel = PlainLabel(fontSize: Constant.Font.medium15, txtColor: Constant.Color.black)
    
    init(title: String) {
        super.init(frame: .zero)
        
        fixedLabel.text = title
        layer.cornerRadius = 10
        
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [fixedLabel, countLabel]
            .forEach { addSubview($0) }
    }
    private func configureLayout() {
        fixedLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(12)
        }
        countLabel.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.leading.equalTo(fixedLabel.snp.trailing)
        }
    }
    
    func configureUI(count: String) {
        countLabel.text = count
    }
}
