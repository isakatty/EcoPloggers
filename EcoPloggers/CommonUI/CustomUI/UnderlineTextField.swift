//
//  UnderlineTextField.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import UIKit

import SnapKit

final class UnderlineTextField: UITextField {
    private let underline: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func configureHierarchy() {
        addSubview(underline)
    }
    private func configureLayout() {
        underline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(16)
        }
    }
}
