//
//  PloggingClubHeaderView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/18/24.
//

import UIKit

import RxSwift
import SnapKit

final class PloggingClubHeaderView: BaseCollectionViewCell {
    var disposeBag = DisposeBag()
    
    private let headerTitle = PlainLabel(fontSize: Constant.Font.medium20)
    private let addLabel = PlainLabel(fontSize: Constant.Font.regular13)
    
    override func configureHierarchy() {
        [headerTitle, addLabel]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        headerTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
        addLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerTitle)
            make.trailing.equalToSuperview().inset(20)
        }
        headerTitle.text = "주간 인기글"
        addLabel.text = "더보기"
        addLabel.textColor = Constant.Color.black.withAlphaComponent(0.5)
    }
    
    func configureUI(headerText: String) {
        headerTitle.text = headerText
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        addLabel.textColor = Constant.Color.black.withAlphaComponent(0.5)
    }
}
