//
//  MeetupInfoCVCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/24/24.
//

import UIKit

import RxSwift
import SnapKit

final class MeetupInfoCVCell: BaseCollectionViewCell {
    private let bgImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    private let capsuleCategory = CapsuleLbView()
    private let capsuleGathering = CapsuleLbView()
    private let contentTitleLabel = PlainLabel(fontSize: Constant.Font.medium20, txtColor: Constant.Color.black)
    private let priceLabel = PlainLabel(fontSize: Constant.Font.regular15, txtColor: Constant.Color.black)
    private let seperateBar: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.lightGray.withAlphaComponent(0.6)
        return view
    }()
    private let compoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    private let timeView = InfoComponent(infoTitle: "소요시간")
    private let participantsView = InfoComponent(infoTitle: "참여인원")
    private let gatherDateView = InfoComponent(infoTitle: "마감날짜")
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.white
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = Constant.Color.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
    override func configureHierarchy() {
        [bgImg, titleContainerView, seperateBar, compoStackView]
            .forEach { contentView.addSubview($0) }
        
       [capsuleCategory, contentTitleLabel, capsuleGathering, priceLabel]
            .forEach { titleContainerView.addSubview($0) }
        
        [timeView, participantsView, gatherDateView]
            .forEach { compoStackView.addArrangedSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        contentTitleLabel.numberOfLines = .zero
        contentTitleLabel.textAlignment = .center
        priceLabel.textAlignment = .center
        
        bgImg.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        titleContainerView.snp.makeConstraints { make in
            make.top.equalTo(bgImg.snp.centerY).offset(70)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(bgImg.snp.bottom).offset(50)
        }
        contentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleContainerView.snp.top).offset(12)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        capsuleCategory.snp.makeConstraints { make in
            make.top.equalTo(contentTitleLabel.snp.bottom).offset(8)
            make.trailing.equalTo(bgImg.snp.centerX).offset(-12)
            make.height.equalTo(30)
        }
        capsuleGathering.snp.makeConstraints { make in
            make.top.equalTo(contentTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(bgImg.snp.centerX).offset(12)
            make.height.equalTo(30)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(capsuleGathering.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        compoStackView.snp.makeConstraints { make in
            make.top.equalTo(titleContainerView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func configureUI(bgImgFilePath: String?, category: String?, titleTxt: String?, price: String?) {
        bgImg.setImgWithHeaders(path: bgImgFilePath)
        capsuleCategory.configureUI(lbText: category)
        capsuleGathering.gatheringBG()
        contentTitleLabel.text = titleTxt
        if let price {
            priceLabel.text = "참가비 \(price)원"
        }
    }
    func configureCompoUI(time: String?, people: String?, date: String?) {
        if let date {
            let dateString = EcoDateFormatter.shared.changeToDateFormat(from: date)
            gatherDateView.configureUI(detailInfo: dateString)
        }
        
        timeView.configureUI(detailInfo: time)
        participantsView.configureUI(detailInfo: people)
    }
}
