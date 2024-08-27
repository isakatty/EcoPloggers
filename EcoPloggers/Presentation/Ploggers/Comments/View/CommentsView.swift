//
//  CommentsView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/27/24.
//

import UIKit

import SnapKit

final class CommentsView: BaseView {
    let commentsTextfield: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.placeholder = "댓글을 작성해주세요."
        return tf
    }()
    let commentBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = "댓글"
        config.baseBackgroundColor = Constant.Color.core?.withAlphaComponent(0.7)
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    override func configureHierarchy() {
        [commentsTextfield, commentBtn]
            .forEach { addSubview($0) }
    }
    override func configureLayout() {
        commentsTextfield.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.leading.equalToSuperview().inset(6)
        }
        commentBtn.snp.makeConstraints { make in
            make.verticalEdges.equalTo(commentsTextfield)
            make.trailing.equalToSuperview().inset(8)
            make.width.equalTo(commentBtn.snp.height)
            make.leading.equalTo(commentsTextfield.snp.trailing).inset(-4)
        }
    }
}
