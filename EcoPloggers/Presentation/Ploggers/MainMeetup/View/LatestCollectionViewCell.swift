//
//  LatestCollectionViewCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/22/24.
//

import UIKit

import RxSwift
import SnapKit

final class LatestCollectionViewCell: BaseCollectionViewCell {
    var disposeBag = DisposeBag()
    
    private let postImgView = CornerRadiusImage(cornerRadius: 20)
    private let categoryLabel = PlainLabel(fontSize: Constant.Font.light13)
    private let postTitleLabel = PlainLabel(fontSize: Constant.Font.medium17)
    private let creatorNameLabel = PlainLabel(fontSize: Constant.Font.regular14)
    
    private let priceLabel = PlainLabel(fontSize: Constant.Font.bold16)
    private let hashtagLabel: HashtagLabel = {
        let label = HashtagLabel()
        label.textAlignment = .center
        label.font = Constant.Font.light12
        label.textColor = Constant.Color.blueGreen
        label.backgroundColor = Constant.Color.core?.withAlphaComponent(0.2)
        return label
    }()
    
    override func configureHierarchy() {
        [postImgView, categoryLabel, postTitleLabel, creatorNameLabel, priceLabel, hashtagLabel]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        postImgView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(postImgView.snp.width)
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(postImgView.snp.trailing).inset(8)
            make.trailing.lessThanOrEqualToSuperview()
        }
        postTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).inset(8)
            make.leading.equalTo(postImgView.snp.trailing).inset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        creatorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(postTitleLabel.snp.bottom).inset(8)
            make.leading.equalTo(postImgView.snp.trailing).inset(8)
            make.bottom.equalTo(postImgView.snp.bottom)
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(creatorNameLabel.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.centerX)
        }
        hashtagLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureUI(data: ViewPostDetailResponse) {
//        postImgView.image = data.files.first
        categoryLabel.text = RegionBorough(rawValue: data.product_id ?? "eco_111231")?.toTitle
        postTitleLabel.text = data.title
        creatorNameLabel.text = data.creator.nick
        priceLabel.text = data.price
        hashtagLabel.text = data.hashtags.joined(separator: " ")
    }
}
