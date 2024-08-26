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
    
    let followBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Constant.Color.lightGray.withAlphaComponent(0.5)
        config.title = "팔로우"
        config.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate).withTintColor(Constant.Color.black)
        config.imagePlacement = .leading
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
        [profileImg, nicknameLabel, viewStack, btnStackView]
            .forEach { addSubview($0) }
        [followBtn, questionBtn]
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
            make.trailing.equalToSuperview().inset(8)
            make.height.greaterThanOrEqualTo(17)
        }
        viewStack.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nicknameLabel)
            make.width.equalTo(130)
            make.bottom.equalTo(profileImg)
        }
        btnStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImg.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(4)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.profileImg.layer.cornerRadius = self.profileImg.bounds.height / 2
        }
    }
    
    func configureUI(nickname: String?, postCount: Int, followerCount: Int) {
        nicknameLabel.text = nickname
        postView.configureUI(count: postCount)
        followersView.configureUI(count: followerCount)
    }
}
