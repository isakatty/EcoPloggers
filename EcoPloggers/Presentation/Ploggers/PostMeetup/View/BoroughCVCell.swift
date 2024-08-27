//
//  BoroughCVCell.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/27/24.
//

import UIKit

import RxSwift

import SnapKit

final class BoroughCVCell: BaseCollectionViewCell {
    private let categoryLabel = PlainLabel(fontSize: Constant.Font.regular12, txtColor: Constant.Color.lightGray.withAlphaComponent(0.7))
    
    private let containersView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.white
        view.layer.borderWidth = 1
        view.layer.borderColor = Constant.Color.lightGray.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(containersView)
        containersView.addSubview(categoryLabel)
    }
    override func configureLayout() {
        containersView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(4)
        }
        categoryLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.containersView.layer.cornerRadius = self.containersView.bounds.height / 2
        }
    }
    
    func configureUI(categoryTxt: String) {
        categoryLabel.text = categoryTxt
    }
}
