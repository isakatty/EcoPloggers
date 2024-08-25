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
    private let profileImgView = ProfileImgView()
    private let followBtn = FollowingButton(title: "팔로우")
    private let followerBtn = FollowingButton(title: "팔로잉")
    
    override func configureHierarchy() {
        [profileImgView, followBtn, followBtn]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        profileImgView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(120)
        }
        followBtn.snp.makeConstraints { make in
            make.top.equalTo(profileImgView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(4)
        }
        followerBtn.snp.makeConstraints { make in
            make.top.equalTo(profileImgView.snp.bottom).offset(8)
            make.leading.equalTo(followBtn.snp.trailing).inset(-12)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    func configureUI() {
        
    }
}
