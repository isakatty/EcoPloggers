//
//  CornerRadiusImage.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/22/24.
//

import UIKit

final class CornerRadiusImage: UIImageView {
    var cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
}
