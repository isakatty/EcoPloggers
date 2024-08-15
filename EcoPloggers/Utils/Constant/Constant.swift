//
//  Constant.swift
//  EcoPloggers
//
//  Created by Jisoo HAM on 8/15/24.
//

import UIKit

enum Constant {
    /// Font
    enum Font {
        static let regular13 = UIFont(name: FontWeight.regular.rawValue, size: 13)
        static let regular14 = UIFont(name: FontWeight.regular.rawValue, size: 14)
        static let regular15 = UIFont(name: FontWeight.regular.rawValue, size: 15)
        static let regular16 = UIFont(name: FontWeight.regular.rawValue, size: 16)
        static let regular17 = UIFont(name: FontWeight.regular.rawValue, size: 17)
        static let regular18 = UIFont(name: FontWeight.regular.rawValue, size: 18)
        
        static let medium15 = UIFont(name: FontWeight.medium.rawValue, size: 15)
        static let medium16 = UIFont(name: FontWeight.medium.rawValue, size: 16)
        static let medium17 = UIFont(name: FontWeight.medium.rawValue, size: 17)
        static let medium18 = UIFont(name: FontWeight.medium.rawValue, size: 18)
    }
    /// 앱 내 사용 컬러
    enum Color {
        static let mainBG = UIColor(named: "MainBG")
        static let secondaryBG = UIColor(named: "SecondaryBG")
        static let secondary = UIColor(named: "Secondary")
        static let primary = UIColor(named: "Primary")
    }
}

extension Constant {
    private enum FontWeight: String {
        case thin = "Pretendard-Thin"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
        case semiBold = "Pretendard-SemiBold"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case black = "Pretendard-Black"
    }
}
