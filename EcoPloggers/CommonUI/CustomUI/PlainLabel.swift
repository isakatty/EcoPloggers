//
//  PlainLabel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import UIKit

final class PlainLabel: UILabel {
    
    init(labelText: String) {
        super.init(frame: .zero)
        
        text = labelText
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(txtColor: UIColor?, bgColor: UIColor?) {
        textColor = txtColor
        backgroundColor = bgColor
    }
}
