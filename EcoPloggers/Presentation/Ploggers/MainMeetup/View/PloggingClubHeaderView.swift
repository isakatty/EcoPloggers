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
    
    let clearBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = Constant.Color.clear
        return btn
    }()
    
    override func configureHierarchy() {
        [headerTitle, addLabel, clearBtn]
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
        
        clearBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addLabel.text = "더보기"
        addLabel.textColor = Constant.Color.black.withAlphaComponent(0.5)
    }
    
    func configureUI(headerText: String, sectionNum: Int) {
        headerTitle.text = headerText
        if sectionNum == 1 {
            addLabel.isHidden = true
        } else {
            addLabel.isHidden = false
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        addLabel.textColor = Constant.Color.black.withAlphaComponent(0.5)
    }
}
