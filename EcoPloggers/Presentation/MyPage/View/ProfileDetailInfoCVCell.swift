//
//  ProfileDetailInfoCVCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import UIKit

import RxSwift
import SnapKit

final class ProfileDetailInfoCVCell: BaseCollectionViewCell {
    let postButton = ProfileInfoButton(category: "게시글")
    let commentsBtn = ProfileInfoButton(category: "댓글")
    let historyBtn = ProfileInfoButton(category: "참여이력")
    
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
        [postButton, seperateBar, commentsBtn, secondBar, historyBtn]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        postButton.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.33)
        }
        seperateBar.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.leading.equalTo(postButton.snp.trailing)
            make.verticalEdges.equalToSuperview().inset(4)
        }
        commentsBtn.snp.makeConstraints { make in
            make.leading.equalTo(seperateBar.snp.trailing)
            make.center.verticalEdges.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.33)
        }
        secondBar.snp.makeConstraints { make in
            make.leading.equalTo(commentsBtn.snp.trailing)
            make.width.equalTo(1)
            make.verticalEdges.equalToSuperview().inset(4)
        }
        historyBtn.snp.makeConstraints { make in
            make.leading.equalTo(secondBar.snp.trailing)
            make.verticalEdges.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.33)
        }
    }
    
    func configureUI(post: String, comments: String, history: String) {
        postButton.configureUI(count: post)
        commentsBtn.configureUI(count: comments)
        historyBtn.configureUI(count: history)
    }
}
