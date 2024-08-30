//
//  ProfileImgView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import UIKit

import SnapKit

final class ProfileImgView: BaseView {
    private let profileImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.image = UIImage(systemName: "star.fill")
        return img
    }()
    private let nameLabel = PlainLabel(fontSize: Constant.Font.medium20, txtColor: Constant.Color.black.withAlphaComponent(0.7))
    
    override func configureHierarchy() {
        nameLabel.textAlignment = .left
        
        [profileImg, nameLabel]
            .forEach { addSubview($0) }
    }
    override func configureLayout() {
        profileImg.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(profileImg.snp.height)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImg.snp.centerY)
            make.leading.equalTo(profileImg.snp.trailing).inset(-12)
            make.trailing.equalToSuperview()
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.profileImg.layer.cornerRadius = self.profileImg.bounds.height / 2
        }
    }
    
    func configureUI(filePath: String?, nickname: String) {
        profileImg.setImgWithHeaders(path: filePath)
        nameLabel.text = nickname
    }
}
