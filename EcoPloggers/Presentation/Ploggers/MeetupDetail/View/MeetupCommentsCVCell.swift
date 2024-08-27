//
//  MeetupCommentsCVCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import UIKit

import SnapKit

final class MeetupCommentsCVCell: BaseCollectionViewCell {
    private let profileImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = Constant.Color.white
        img.clipsToBounds = true
        return img
    }()
    private let nickname = PlainLabel(fontSize: Constant.Font.regular12, txtColor: Constant.Color.lightGray.withAlphaComponent(0.7))
    private let comments = PlainLabel(fontSize: Constant.Font.regular14, txtColor: Constant.Color.black.withAlphaComponent(0.6))
    
    private let emptyComments: PlainLabel = {
        let lb = PlainLabel(fontSize: Constant.Font.medium17, txtColor: Constant.Color.black)
        lb.text = "아직 댓글이 없습니다."
        return lb
    }()
    
    override func configureHierarchy() {
        [profileImg, nickname, comments, emptyComments]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        profileImg.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(12)
            make.width.equalTo(profileImg.snp.height)
        }
        nickname.snp.makeConstraints { make in
            make.top.equalTo(profileImg)
            make.leading.equalTo(profileImg.snp.trailing).inset(-12)
            make.trailing.equalToSuperview()
        }
        comments.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(nickname)
            make.bottom.equalTo(profileImg)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.profileImg.layer.cornerRadius = self.profileImg.bounds.height / 2
        }
        emptyComments.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emptyComments.isHidden = true
    }
    
    func configureUI(filePath: String?, nick: String, comment: String) {
        emptyComments.isHidden = true
        if let filePath {
            profileImg.setImgWithHeaders(path: filePath)
        } else {
            profileImg.image = UIImage(systemName: "person.fill")
        }
        nickname.text = nick
        comments.text = comment
    }
    func configureEmptyComments(noComments: Bool) {
        if noComments {
            emptyComments.isHidden = false
        }
    }
}
