//
//  RegionCollectionViewCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import UIKit

import RxSwift
import SnapKit

// TODO: 선택시, color 변하게 하기
final class RegionCollectionViewCell: BaseCollectionViewCell {
    var disposeBag = DisposeBag()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.medium15
        label.textAlignment = .center
        label.textColor = Constant.Color.black
        return label
    }()
    
    override func configureHierarchy() {
        [regionLabel]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        regionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureLabel(regionName: String) {
        regionLabel.text = regionName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
