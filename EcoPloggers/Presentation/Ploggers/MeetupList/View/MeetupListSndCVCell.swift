//
//  MeetupListSndCVCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/29/24.
//

import UIKit

import RxSwift
import SnapKit

final class MeetupListSndCVCell: BaseCollectionViewCell {
    var disposeBag = DisposeBag()
    let creatorView = MeetupPostCreatorView()
    
    private let postImgView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = Constant.Color.black.withAlphaComponent(0.4).cgColor
        return view
    }()
    private let postTitleLb = PlainLabel(fontSize: Constant.Font.bold16, txtColor: Constant.Color.black.withAlphaComponent(0.7))
    private let categoryLb : HashtagLabel = {
        let label = HashtagLabel()
        label.textAlignment = .center
        label.font = Constant.Font.light12
        label.textColor = Constant.Color.blueGreen
        label.backgroundColor = Constant.Color.core?.withAlphaComponent(0.2)
        return label
    }()
    private let seoulLb: HashtagLabel = {
        let label = HashtagLabel()
        label.textAlignment = .center
        label.font = Constant.Font.light12
        label.textColor = Constant.Color.black.withAlphaComponent(0.6)
        label.backgroundColor = Constant.Color.blueGreen?.withAlphaComponent(0.2)
        label.text = "서울"
        return label
    }()
    
    override func configureHierarchy() {
        [creatorView, postImgView, postTitleLb]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        postTitleLb.textAlignment = .center
        
        creatorView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }
        postImgView.snp.makeConstraints { make in
            make.top.equalTo(creatorView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.lessThanOrEqualTo(200)
        }
        postTitleLb.snp.makeConstraints { make in
            make.top.equalTo(postImgView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(postImgView)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(12)
        }
//        categoryLb.snp.makeConstraints { make in
//            make.top.equalTo(postTitleLb.snp.bottom).offset(8)
//            make.trailing.equalTo(postImgView.snp.centerX).offset(-12)
//            make.bottom.equalToSuperview().inset(12)
//        }
//        seoulLb.snp.makeConstraints { make in
//            make.top.equalTo(categoryLb)
//            make.leading.equalTo(postImgView.snp.centerX).offset(12)
//            make.bottom.equalToSuperview().inset(12)
//        }
    }
    
    func configureUI(data: ViewPostDetailResponse) {
        creatorView.configureUI(profileFilePath: data.creator.profileImage, nickname: data.creator.nick)
        postImgView.setImgWithHeaders(path: data.files.first)
        postTitleLb.text = data.title
        categoryLb.text = RegionBorough(rawValue: data.product_id ?? "eco_111261")?.toTitle
    }
}
