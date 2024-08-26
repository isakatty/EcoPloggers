//
//  UIImageView+.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImgWithHeaders(path: String?) {
        if let path,
           let baseURL = Constant.NetworkComponents.baseURL,
           let url = URL(string: "\(baseURL)/v1/" + path) {
            self.kf.setImage(with: url, options: [.requestModifier(KingfisherManager.shared.modifier)])
        }
    }
}
