//
//  MeetupProfileCVCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import UIKit

import RxSwift
import SnapKit

final class MeetupProfileCVCell: BaseCollectionViewCell {
    private let profileView = MeetupProfileView()
    
    override func configureHierarchy() {
        contentView.addSubview(profileView)
    }
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureProfile(profile: ProfileResponse) {
        profileView.configureUI(
            nickname: profile.nick,
            postCount: profile.posts.count,
            followerCount: profile.followers.count
        )
    }
}
