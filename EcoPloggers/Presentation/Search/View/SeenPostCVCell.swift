//
//  SeenPostCVCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/29/24.
//

import UIKit

import SnapKit

final class SeenPostCVCell: BaseCollectionViewCell {
    private let postImg: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = Constant.Color.lightGray.withAlphaComponent(0.7).cgColor
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let titleLB = PlainLabel(fontSize: Constant.Font.medium15, txtColor: Constant.Color.black.withAlphaComponent(0.7))
    private let categoryLb = PlainLabel(fontSize: Constant.Font.regular13, txtColor: Constant.Color.lightGray.withAlphaComponent(0.8))
    
    override func configureHierarchy() {
        [postImg, titleLB, categoryLb]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        titleLB.numberOfLines = .zero
        
        postImg.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(postImg.snp.height)
        }
        titleLB.snp.makeConstraints { make in
            make.top.equalTo(postImg)
            make.leading.equalTo(postImg.snp.trailing).inset(-12)
            make.trailing.equalToSuperview().inset(8)
        }
        categoryLb.snp.makeConstraints { make in
            make.bottom.equalTo(postImg.snp.bottom)
            make.leading.equalTo(titleLB)
            make.top.lessThanOrEqualTo(titleLB.snp.bottom)
        }
    }
    
    func configureUI(filePath: String?, title: String, category: String?) {
        postImg.setImgWithHeaders(path: filePath)
        titleLB.text = title
        if let category {
            categoryLb.text = RegionBorough2(rawValue: category)?.toTitle
        } else {
            categoryLb.text = ""
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        postImg.image = nil
    }
}
