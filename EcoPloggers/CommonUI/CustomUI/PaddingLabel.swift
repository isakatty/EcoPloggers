//
//  PaddingLabel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/29/24.
//

import UIKit

final class PaddingLabel: UILabel {
    var padding: UIEdgeInsets
    
    var left: CGFloat {
        get {
            self.padding.left
        }
        set {
            self.padding.left = newValue
        }
    }
    var right: CGFloat {
        get {
            self.padding.right
        }
        set {
            self.padding.right = newValue
        }
    }
    var top: CGFloat {
        get {
            self.padding.top
        }
        set {
            self.padding.top = newValue
        }
    }
    var bottom: CGFloat {
        get {
            self.padding.bottom
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
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    convenience init(inset: UIEdgeInsets) {
        self.init(frame: .zero)
        self.padding = inset
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += padding.left + padding.right
        size.height += padding.top + padding.bottom
        return size
    }
}
