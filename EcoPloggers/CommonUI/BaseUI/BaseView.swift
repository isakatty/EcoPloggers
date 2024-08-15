//
//  BaseView.swift
//  EcoPloggers
//
//  Created by Jisoo HAM on 8/15/24.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        
    }
    func configureLayout() {
        backgroundColor = .systemBackground
        
    }
}
