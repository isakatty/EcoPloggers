//
//  MyPageProfileCVCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import UIKit

import RxSwift
import SnapKit

final class MyPageProfileCVCell: BaseCollectionViewCell {
    var disposeBag = DisposeBag()
    private let profileImgView = ProfileImgView()
    
    private let horizontalBar: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.lightGray.withAlphaComponent(0.6)
        return view
    }()
    let postButton = ProfileInfoButton(category: "게시글")
    let followersBtn = ProfileInfoButton(category: "팔로워")
    let followingsBtn = ProfileInfoButton(category: "팔로잉")
    
    private let seperateBar: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.lightGray.withAlphaComponent(0.6)
        return view
    }()
    private let secondBar: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.lightGray.withAlphaComponent(0.6)
        return view
    }()
    
    override func configureHierarchy() {
        [profileImgView, horizontalBar, postButton, seperateBar, followersBtn, secondBar, followingsBtn]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        profileImgView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
        }
        horizontalBar.snp.makeConstraints { make in
            make.top.equalTo(profileImgView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(4)
            make.height.equalTo(1)
        }
        postButton.snp.makeConstraints { make in
            make.top.equalTo(horizontalBar.snp.bottom).offset(4)
            make.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.33)
        }
        seperateBar.snp.makeConstraints { make in
            make.leading.equalTo(postButton.snp.trailing)
            make.top.bottom.equalTo(postButton).inset(12)
            make.width.equalTo(1)
        }
        followersBtn.snp.makeConstraints { make in
            make.leading.equalTo(seperateBar.snp.trailing)
            make.top.bottom.equalTo(postButton)
            make.width.equalTo(postButton.snp.width)
        }
        secondBar.snp.makeConstraints { make in
            make.leading.equalTo(followersBtn.snp.trailing)
            make.top.bottom.equalTo(followersBtn).inset(12)
            make.width.equalTo(1)
        }
        followingsBtn.snp.makeConstraints { make in
            make.leading.equalTo(secondBar.snp.trailing)
            make.trailing.equalToSuperview()
            make.top.bottom.equalTo(postButton)
        }
    }
    
    func configureUI(profile: ProfileResponse) {
        profileImgView.configureUI(imgData: nil, nickname: profile.nick)
        postButton.configureUI(count: String(profile.posts.count))
        followersBtn.configureUI(count: String(profile.followers.count))
        followingsBtn.configureUI(count: String(profile.following.count))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
