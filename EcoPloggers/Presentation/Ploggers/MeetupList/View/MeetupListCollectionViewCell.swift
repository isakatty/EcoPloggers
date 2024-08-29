//
//  MeetupListCollectionViewCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/29/24.
//

import UIKit

import SnapKit

final class MeetupListCollectionViewCell: BaseCollectionViewCell {
    private let imgView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.borderColor = Constant.Color.lightGray.withAlphaComponent(0.5).cgColor
        return view
    }()
    private let titleLB = PlainLabel(fontSize: Constant.Font.medium16, txtColor: Constant.Color.black)
    private let creatorLB: PlainLabel = {
        let lb = PlainLabel(fontSize: Constant.Font.regular15, txtColor: Constant.Color.lightGray)
        lb.text = "작성자"
        return lb
    }()
    private let nickLB = PlainLabel(fontSize: Constant.Font.regular15, txtColor: Constant.Color.lightGray)
    private let priceLB = PlainLabel(fontSize: Constant.Font.bold13, txtColor: Constant.Color.black)
    
    private let gatheringLB: PaddingLabel = {
        let lb = PaddingLabel(inset: .init(top: 2, left: 8, bottom: 2, right: 8))
        lb.text = "모집중"
        lb.textColor = Constant.Color.carrotOrange
        lb.backgroundColor = Constant.Color.white
        lb.textAlignment = .center
        lb.clipsToBounds = true
        return lb
    }()
    
    override func configureHierarchy() {
        [imgView, titleLB, creatorLB, nickLB, priceLB, gatheringLB]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        imgView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(imgView.snp.width).multipliedBy(0.6)
        }
        gatheringLB.snp.makeConstraints { make in
            make.top.leading.equalTo(imgView).inset(12)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        titleLB.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(imgView)
            make.height.equalTo(30)
        }
        creatorLB.snp.makeConstraints { make in
            make.top.equalTo(titleLB.snp.bottom).offset(6)
            make.leading.equalTo(imgView)
            make.width.equalTo(50)
        }

        nickLB.snp.makeConstraints { make in
            make.top.equalTo(creatorLB)
            make.leading.equalTo(creatorLB.snp.trailing).offset(2)
        }

        priceLB.snp.makeConstraints { make in
            make.top.equalTo(nickLB.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(imgView)
            make.height.equalTo(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.gatheringLB.layer.cornerRadius = self.gatheringLB.bounds.height / 2
        }
    }
    
    func configureUI(data: ViewPostDetailResponse) {
        imgView.setImgWithHeaders(path: data.files.first)
        nickLB.text = data.creator.nick
        titleLB.text = data.title
        if let priceText = data.prices?.formatted() {
            priceLB.text = priceText + " 원"
        } else {
            priceLB.text = "무료"
        }
        
        if let due_date = data.due_date,
           let date = EcoDateFormatter.shared.changeToDate(from: due_date) {
            let currentDate = Date()
            
            let calendar = Calendar.current
            let currentDateOnly = calendar.startOfDay(for: currentDate)
            let dueDateOnly = calendar.startOfDay(for: date)
            
            if dueDateOnly > currentDateOnly {
                gatheringLB.text = "모집중"
            } else {
                gatheringLB.text = "모집완료"
            }
        }
    }
}
