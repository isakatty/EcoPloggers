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
    
    func configureProfile(profile: ProfileSectionModel) {
        profileView.configureUI(
            filePath: profile.post.creator.profileImage,
            nickname: profile.post.creator.nick,
            postCount: profile.creator.posts.count,
            followerCount: profile.creator.followers.count
        )
    }
}
