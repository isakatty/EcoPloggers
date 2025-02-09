//
//  RoundedButton.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import UIKit

final class RoundedButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(Constant.Color.white, for: .normal)
        layer.cornerRadius = 10
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func availableBtn() {
        isEnabled = true
        backgroundColor = Constant.Color.core
    }
    
    func unavailableBtn() {
        isEnabled = false
        backgroundColor = Constant.Color.lightGray
    }
    
}
