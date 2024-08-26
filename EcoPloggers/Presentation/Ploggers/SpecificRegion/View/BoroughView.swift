//
//  BoroughView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import UIKit

import SnapKit

final class BoroughView: BaseView {
    private let regionLabel = PlainLabel(fontSize: Constant.Font.medium20, txtColor: Constant.Color.black)
    private let chevronImg: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Constant.Color.clear
        view.clipsToBounds = true
        view.image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = Constant.Color.black
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func configureHierarchy() {
        [regionLabel, chevronImg]
            .forEach { addSubview($0) }
    }
    override func configureLayout() {
        regionLabel.text = "영등포구"
        regionLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(12)
        }
        chevronImg.snp.makeConstraints { make in
            make.top.bottom.equalTo(regionLabel).inset(4)
            make.trailing.equalToSuperview()
            make.width.equalTo(chevronImg.snp.height)
            make.leading.equalTo(regionLabel.snp.trailing)
        }
    }
    
    func configureUI(regionName: String) {
        regionLabel.text = regionName
    }
}
