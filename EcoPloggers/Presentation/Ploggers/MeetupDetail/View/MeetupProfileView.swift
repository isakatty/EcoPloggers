//
//  MeetupProfileView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/24/24.
//

import UIKit

import SnapKit

final class MeetupProfileView: BaseView {
    private let profileImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.image = UIImage(systemName: "person.fill")
        return img
    }()
    private let nicknameLabel = PlainLabel(fontSize: Constant.Font.medium15, txtColor: Constant.Color.black)
    let followBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Constant.Color.secondaryBG?.withAlphaComponent(0.4)
        var titleAttribute = AttributedString("팔로우")
        titleAttribute.font = Constant.Font.regular12
        titleAttribute.foregroundColor = Constant.Color.lightGray.withAlphaComponent(0.7)
        config.attributedTitle = titleAttribute
        let btn = UIButton(configuration: config)
        return btn
    }()
    private let postView = MeetupProfileInfoView(content: "게시글")
    private let followersView = MeetupProfileInfoView(content: "팔로워")
    private let viewStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 10
        return stack
    }()
    
    let engageBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "참여하기"
        config.baseBackgroundColor = Constant.Color.core?.withAlphaComponent(0.7)
        let btn = UIButton(configuration: config)
        return btn
    }()
    let questionBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Constant.Color.lightGray.withAlphaComponent(0.5)
        config.title = "문의하기"
        let btn = UIButton(configuration: config)
        return btn
    }()
    private let btnStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 30
        return view
    }()
    
    override func configureHierarchy() {
        [profileImg, nicknameLabel, followBtn, viewStack, btnStackView]
            .forEach { addSubview($0) }
        [engageBtn, questionBtn]
            .forEach { btnStackView.addArrangedSubview($0) }
        [postView, followersView]
            .forEach { viewStack.addArrangedSubview($0) }
    }
    override func configureLayout() {
        profileImg.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(65)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImg)
            make.leading.equalTo(profileImg.snp.trailing).inset(-16)
            make.height.greaterThanOrEqualTo(17)
        }
        followBtn.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).inset(-8)
            make.centerY.equalTo(nicknameLabel)
            make.verticalEdges.equalTo(nicknameLabel).inset(2)
            make.width.equalTo(followBtn.snp.height).multipliedBy(2.5)
        }
        viewStack.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nicknameLabel)
            make.width.equalTo(130)
            make.bottom.equalTo(profileImg.snp.bottom).offset(4)
        }
        btnStackView.snp.makeConstraints { make in
            make.top.equalTo(viewStack.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(4)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.profileImg.layer.cornerRadius = self.profileImg.bounds.height / 2
        }
    }
    
    func configureUI(filePath: String?, nickname: String?, postCount: Int, followerCount: Int) {
        profileImg.setImgWithHeaders(path: filePath)
        nicknameLabel.text = nickname
        postView.configureUI(count: postCount)
        followersView.configureUI(count: followerCount)
    }
}
