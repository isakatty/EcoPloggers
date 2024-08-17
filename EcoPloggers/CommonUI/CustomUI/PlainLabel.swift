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
    
    init() {
        super.init(frame: .zero)
    }
    init(fontSize: UIFont?) {
        super.init(frame: .zero)
        
        font = fontSize
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(txtColor: UIColor?, bgColor: UIColor?) {
        textColor = txtColor
        backgroundColor = bgColor
    }
    func configureText(labelText: String, validate: Bool) {
        text = labelText
        
        textColor = validate ? Constant.Color.black : Constant.Color.carrotOrange
    }
}
