//
//  PaddingButton.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import UIKit

final class PaddingButton: UIButton {
    var padding: UIEdgeInsets

    var left: CGFloat {
        get {
            return self.padding.left
        }
        set {
            self.padding.left = newValue
        }
    }
    var right: CGFloat {
        get {
            return self.padding.right
        }
        set {
            self.padding.right = newValue
        }
    }
    var top: CGFloat {
        get {
            return self.padding.top
        }
        set {
            self.padding.top = newValue
        }
    }
    var bottom: CGFloat {
        get {
            return self.padding.bottom
        }
        set {
            self.padding.bottom = newValue
        }
    }

    override init(frame: CGRect) {
        self.padding = .zero
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        self.padding = .zero
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Adjust titleLabel frame to respect padding
        if let titleLabel = self.titleLabel {
            let insetFrame = titleLabel.frame.inset(by: padding)
            titleLabel.frame = insetFrame
        }
        
        // Adjust imageView frame to respect padding if the button has an image
        if let imageView = self.imageView {
            let insetFrame = imageView.frame.inset(by: padding)
            imageView.frame = insetFrame
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += padding.left + padding.right
        size.height += padding.top + padding.bottom
        return size
    }
    
    convenience init(inset: UIEdgeInsets) {
        self.init(frame: .zero)
        self.padding = inset
    }
}


