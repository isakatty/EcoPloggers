//
//  InfoComponent.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/24/24.
//

import UIKit

import SnapKit

final class InfoComponent: BaseView {
    var infoTitle: String
    
    private let infoTitleLabel: PlainLabel = PlainLabel(fontSize: Constant.Font.regular16, txtColor: Constant.Color.black)
    private let detailInfoLabel = PlainLabel(fontSize: Constant.Font.medium13, txtColor: Constant.Color.black)
    
    init(infoTitle: String) {
        self.infoTitle = infoTitle
        infoTitleLabel.text = infoTitle
        
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        [infoTitleLabel, detailInfoLabel]
            .forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.horizontalEdges.equalToSuperview().inset(4)
        }
        detailInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(infoTitleLabel.snp.centerX)
            make.horizontalEdges.equalTo(infoTitleLabel)
            make.bottom.equalToSuperview().inset(4)
        }
        
        infoTitleLabel.textAlignment = .center
        detailInfoLabel.textAlignment = .center
    }
    
    func configureUI(detailInfo: String?) {
        detailInfoLabel.text = detailInfo
    }
}
