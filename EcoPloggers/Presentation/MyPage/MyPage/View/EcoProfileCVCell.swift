//
//  EcoProfileCVCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/30/24.
//

import UIKit

import SnapKit

final class EcoProfileCVCell: BaseCollectionViewCell {
    private let ecoPostImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        return img
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(ecoPostImg)
    }
    override func configureLayout() {
        ecoPostImg.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    func configureUI(filePath: String?) {
        ecoPostImg.setImgWithHeaders(path: filePath)
    }
}
