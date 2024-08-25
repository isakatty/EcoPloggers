//
//  ProfileInfoButton.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import UIKit

import SnapKit

final class ProfileInfoButton: UIButton {
    private let countLabel = PlainLabel(fontSize: Constant.Font.medium17, txtColor: Constant.Color.black.withAlphaComponent(0.7))
    private let categoryLabel = PlainLabel(fontSize: Constant.Font.medium17, txtColor: Constant.Color.black.withAlphaComponent(0.7))
    
    init(category: String) {
        super.init(frame: .zero)
        
        categoryLabel.text = category
        backgroundColor = Constant.Color.clear
        
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [countLabel, categoryLabel]
            .forEach { addSubview($0) }
    }
    private func configureLayout() {
        countLabel.textAlignment = .center
        categoryLabel.textAlignment = .center
        
        countLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(22)
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureUI(count: String) {
        countLabel.text = count
    }
}
