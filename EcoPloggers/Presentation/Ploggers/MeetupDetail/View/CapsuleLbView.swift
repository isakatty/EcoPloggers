//
//  CapsuleLbView.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/30/24.
//

import UIKit

import SnapKit

final class CapsuleLbView: BaseView {
    private lazy var lb : PlainLabel = {
        let lb = PlainLabel(fontSize: Constant.Font.regular14, txtColor: Constant.Color.white)
        return lb
    }()
    
    override func configureHierarchy() {
        addSubview(lb)
    }
    override func configureLayout() {
        lb.textAlignment = .center
        regionBasicColor()
        
        lb.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(4)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.layer.cornerRadius = self.bounds.height / 2
        }
    }
    func configureUI(lbText: String?) {
        lb.text = lbText
    }
    
    private func regionBasicColor() {
        backgroundColor = Constant.Color.core
    }
    func gatheringBG() {
        lb.text = "모집중"
        backgroundColor = Constant.Color.carrotOrange
    }
    func freezeBG() {
        lb.text = "모집 완료"
        backgroundColor = Constant.Color.lightGray
    }
}
