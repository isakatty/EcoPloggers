//
//  RegionCollectionViewCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import UIKit

import RxSwift
import SnapKit

final class RegionCollectionViewCell: BaseCollectionViewCell {
    var disposeBag = DisposeBag()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.medium15
        label.textAlignment = .center
        return label
    }()
    private let selectedBar = UIView()
    
    override func configureHierarchy() {
        [regionLabel, selectedBar]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        regionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        selectedBar.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(regionLabel.snp.bottom).offset(4)
            make.centerX.equalTo(regionLabel)
            make.width.equalTo(regionLabel).inset(4)
            make.bottom.equalTo(contentView)
        }
        selectedBar.isHidden = true
    }
    
    func configureLabel(regionName: String) {
        regionLabel.text = regionName
        
        if regionName == "서울" {
            regionLabel.textColor = Constant.Color.deepGreen
            selectedBar.backgroundColor = Constant.Color.deepGreen
            selectedBar.isHidden = false
        }
    }
    func configureSelectedBar(isSelected: Bool) {
        let color = isSelected ? Constant.Color.deepGreen : Constant.Color.blueGreen
        regionLabel.textColor = color
        selectedBar.backgroundColor = color
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
