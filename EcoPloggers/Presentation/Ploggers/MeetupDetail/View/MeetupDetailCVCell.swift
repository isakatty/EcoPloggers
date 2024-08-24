//
//  MeetupDetailCVCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/24/24.
//

import UIKit

import RxSwift
import SnapKit

final class MeetupDetailCVCell: BaseCollectionViewCell {
    private let contentLabel = PlainLabel(fontSize: Constant.Font.medium15, txtColor: Constant.Color.black.withAlphaComponent(0.7))
    
    override func configureHierarchy() {
        [contentLabel]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        contentLabel.numberOfLines = .zero
        contentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configureUI(content: String) {
        contentLabel.text = content.exceptHashtag
    }
}
