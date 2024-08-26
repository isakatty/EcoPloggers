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
    private let categoryLabel = PlainLabel(fontSize: Constant.Font.medium13, txtColor: Constant.Color.lightGray)
    private let contentTitleLabel = PlainLabel(fontSize: Constant.Font.regular18, txtColor: Constant.Color.black)
    private let priceLabel = PlainLabel(fontSize: Constant.Font.bold16, txtColor: Constant.Color.black)
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
    
    override func configureHierarchy() {
        [bgImg, categoryLabel, contentTitleLabel, priceLabel, seperateBar, compoStackView]
            .forEach { contentView.addSubview($0) }
        [timeView, participantsView, gatherDateView]
            .forEach { compoStackView.addArrangedSubview($0) }
    }
    override func configureLayout() {
//        super.configureLayout()
        
        bgImg.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(bgImg.snp.width).multipliedBy(0.5)
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(bgImg.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        contentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(contentTitleLabel)
        }
        seperateBar.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        compoStackView.snp.makeConstraints { make in
            make.top.equalTo(seperateBar.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureUI(bgImgFilePath: String?, category: String?, titleTxt: String?, price: String?) {
        bgImg.setImgWithHeaders(path: bgImgFilePath)
        categoryLabel.text = category
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
