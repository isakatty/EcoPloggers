//
//  MeetupPostCreatorView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/30/24.
//

import UIKit

import SnapKit

final class MeetupPostCreatorView: BaseView {
    private let profileImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let creatorNameLb = PlainLabel(fontSize: Constant.Font.medium15, txtColor: Constant.Color.black.withAlphaComponent(0.6))
    private let followBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Constant.Color.blueGreen
        config.titleAlignment = .center
        var titleAttribute = AttributedString("팔로우")
        titleAttribute.font = Constant.Font.regular12
        titleAttribute.foregroundColor = Constant.Color.white
        config.attributedTitle = titleAttribute
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    override func configureHierarchy() {
        [profileImg, creatorNameLb, followBtn]
            .forEach { addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        profileImg.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(12)
            make.width.equalTo(profileImg.snp.height)
        }
        creatorNameLb.snp.makeConstraints { make in
            make.centerY.equalTo(profileImg)
            make.leading.equalTo(profileImg.snp.trailing).inset(-16)
            make.trailing.equalTo(followBtn.snp.leading)
        }
        followBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(profileImg)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.profileImg.layer.cornerRadius = self.profileImg.bounds.height / 2
        }
    }
    
    func configureUI(profileFilePath: String?, nickname: String) {
        profileImg.setImgWithHeaders(path: profileFilePath)
        creatorNameLb.text = nickname
    }
}
