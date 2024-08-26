//
//  BannerCollectionViewCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/18/24.
//

import UIKit

import RxSwift
import SnapKit

final class BannerCollectionViewCell: BaseCollectionViewCell {
    private let bannerImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 25
        return img
    }()
    
    private lazy var countCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.lightGray.withAlphaComponent(0.5)
        view.clipsToBounds = true
        return view
    }()
    private let imgCountLabel = PlainLabel(fontSize: Constant.Font.light13)
    private let totalCountLabel: PlainLabel = {
        let label = PlainLabel(fontSize: Constant.Font.light13)
        label.text = "/ 5 +"
        return label
    }()
    
    override func configureHierarchy() {
        [bannerImg, countCoverView]
            .forEach { contentView.addSubview($0) }
        [imgCountLabel, totalCountLabel]
            .forEach { countCoverView.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        contentView.layer.cornerRadius = 25
        contentView.backgroundColor = Constant.Color.core
        
        bannerImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        countCoverView.snp.makeConstraints { make in
            make.bottom.equalTo(bannerImg).inset(8)
            make.trailing.equalTo(bannerImg).inset(16)
            make.height.equalTo(24)
            make.width.equalTo(60)
        }
        
        imgCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(totalCountLabel.snp.leading).inset(-8)
        }
        
        totalCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.countCoverView.layer.cornerRadius = self.countCoverView.frame.height / 2
        }
    }
    
    func configureUI(count: String, img: UIImage?) {
        bannerImg.image = img
        imgCountLabel.text = count
    }
    
    func configureData(count: String, imgPath: String?) {
        bannerImg.setImgWithHeaders(path: imgPath)
        imgCountLabel.text = count
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.countCoverView.layer.cornerRadius = self.countCoverView.frame.height / 2
        }
    }
}
