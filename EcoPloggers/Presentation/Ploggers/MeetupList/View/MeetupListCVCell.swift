//
//  MeetupListCVCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/23/24.
//

import UIKit

import RxSwift
import SnapKit

final class MeetupListCVCell: BaseCollectionViewCell {
    private let totalContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    private let contentImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    private let labelContainer = UIView()
    private let regionLabel = PlainLabel(fontSize: Constant.Font.medium13, txtColor: Constant.Color.lightGray)
    private let contentTitleLabel = PlainLabel(fontSize: Constant.Font.medium18, txtColor: Constant.Color.black)
    private let hashtagLabel = PlainLabel(fontSize: Constant.Font.bold13, txtColor: Constant.Color.blueGreen)
    private let priceLabel = PlainLabel(fontSize: Constant.Font.medium13, txtColor: Constant.Color.black)
    let favBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
        let btn = UIButton(configuration: config)
        btn.backgroundColor = Constant.Color.clear
        btn.imageView?.tintColor = Constant.Color.core
        return btn
    }()
    
    override func configureHierarchy() {
        [totalContainerView]
            .forEach { contentView.addSubview($0) }
        [contentImg, labelContainer]
            .forEach { totalContainerView.addSubview($0) }
        [regionLabel, contentTitleLabel, hashtagLabel, priceLabel, favBtn]
            .forEach { labelContainer.addSubview($0) }
    }
    override func configureLayout() {
//        super.configureLayout()
        
        contentTitleLabel.numberOfLines = .zero
        labelContainer.backgroundColor = Constant.Color.white
        
        totalContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(4)
        }
        contentImg.snp.makeConstraints { make in
            make.edges.equalTo(totalContainerView)
        }
        labelContainer.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        contentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(labelContainer).offset(12)
            make.horizontalEdges.equalTo(labelContainer).inset(16)
        }
        regionLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentTitleLabel)
            make.bottom.equalToSuperview().inset(12)
        }
        hashtagLabel.snp.makeConstraints { make in
            make.leading.equalTo(regionLabel.snp.trailing).inset(-8)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(hashtagLabel.snp.trailing).inset(-8)
            make.bottom.equalToSuperview().inset(12)
        }
        favBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(12)
            make.width.height.equalTo(30)
        }
    }
    
    func configureUI(data: ViewPostDetailResponse) {
        regionLabel.text = RegionBorough(rawValue: data.product_id ?? "eco_111231")?.toTitle
        contentTitleLabel.text = data.title
        hashtagLabel.text = data.hashtags.filter({ $0 != "eco_랜덤" }).map { "#\($0)"}.joined(separator: " ")
        if let priceTxt = data.price {
            priceLabel.text = "참가비 " + "\(priceTxt)원"
        } else {
            priceLabel.text = "무료"
        }
        
        guard let imgData = data.fileData.first else { return }
        contentImg.image = UIImage(data: imgData)
    }
}
