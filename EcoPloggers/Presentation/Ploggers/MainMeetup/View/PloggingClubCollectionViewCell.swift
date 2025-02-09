//
//  PloggingClubCollectionViewCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/18/24.
//

import UIKit

import RxSwift
import SnapKit

final class PloggingClubCollectionViewCell: BaseCollectionViewCell {
    var disposeBag = DisposeBag()
    
    private let img: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.borderColor = Constant.Color.lightGray.cgColor.copy(alpha: 0.5)
        view.contentMode = .scaleAspectFill
        view.image = UIImage(systemName: "star.fill")
        return view
    }()
    private let creatorLabel = PlainLabel(fontSize: Constant.Font.light12)
    private let contentTitleLabel = PlainLabel(fontSize: Constant.Font.regular15)
    private let locationLabel = PlainLabel(fontSize: Constant.Font.regular13)
    private let openLabel = PlainLabel(fontSize: Constant.Font.bold13)
    
    override func configureHierarchy() {
        [img, creatorLabel, contentTitleLabel, locationLabel, openLabel]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
//        super.configureLayout()
        openLabel.text = "모집중"
        openLabel.textColor = Constant.Color.carrotOrange
        contentTitleLabel.numberOfLines = .zero
        
        img.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(img.snp.width)
        }
        creatorLabel.snp.makeConstraints { make in
            make.top.equalTo(img.snp.bottom).offset(4)
            make.leading.equalTo(img)
            make.height.equalTo(15)
        }
        contentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(creatorLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(img)
        }
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(img.snp.leading)
            make.bottom.equalToSuperview()
        }
        openLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTitleLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureData(imageFilePath: String?, creator: String, title: String, location: String?) {
        img.setImgWithHeaders(path: imageFilePath)
        creatorLabel.text = creator
        contentTitleLabel.text = title
        locationLabel.text = RegionBorough(rawValue: location ?? "eco_111261")?.toTitle
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        
//        [creatorLabel, contentTitleLabel, locationLabel, openLabel]
//            .forEach { $0.text = nil }
    }
}
