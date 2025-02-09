//
//  HashtagLabel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/22/24.
//

import UIKit

final class HashtagLabel: UILabel {
    private var padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
