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
        static let light12 = UIFont(name: FontWeight.light.rawValue, size: 12)
        static let light13 = UIFont(name: FontWeight.light.rawValue, size: 13)
        
        static let regular13 = UIFont(name: FontWeight.regular.rawValue, size: 13)
        static let regular14 = UIFont(name: FontWeight.regular.rawValue, size: 14)
        static let regular15 = UIFont(name: FontWeight.regular.rawValue, size: 15)
        static let regular16 = UIFont(name: FontWeight.regular.rawValue, size: 16)
        static let regular17 = UIFont(name: FontWeight.regular.rawValue, size: 17)
        static let regular18 = UIFont(name: FontWeight.regular.rawValue, size: 18)
        
        static let medium13 = UIFont(name: FontWeight.medium.rawValue, size: 13)
        static let medium15 = UIFont(name: FontWeight.medium.rawValue, size: 15)
        static let medium16 = UIFont(name: FontWeight.medium.rawValue, size: 16)
        static let medium17 = UIFont(name: FontWeight.medium.rawValue, size: 17)
        static let medium18 = UIFont(name: FontWeight.medium.rawValue, size: 18)
        static let medium20 = UIFont(name: FontWeight.medium.rawValue, size: 20)
        
        static let bold13 = UIFont(name: FontWeight.bold.rawValue, size: 13)
        static let bold16 = UIFont(name: FontWeight.bold.rawValue, size: 16)
        static let bold20 = UIFont(name: FontWeight.bold.rawValue, size: 20)
    }
    /// 앱 내 사용 컬러
    enum Color {
        static let mainBG = UIColor(named: "MainBG")
        static let secondaryBG = UIColor(named: "SecondaryBG")
        static let support = UIColor(named: "Support")
        static let core = UIColor(named: "Core")
        static let limeYellow = UIColor(named: "LimeYellow")
        static let carrotOrange = UIColor(named: "CarrotOrange")
        static let deepGreen = UIColor(named: "DeepGreen")
        static let blueGreen = UIColor(named: "BlueGreen")
        static let black = UIColor.black
        static let white = UIColor.white
        static let lightGray = UIColor.lightGray
        static let clear = UIColor.clear
    }
    
    enum NetworkComponents {
        static let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String
        static let portString = Bundle.main.object(forInfoDictionaryKey: "PORT_STRING") as? String
        static let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    }
    enum NetworkHeader: String {
        case authorization = "Authorization"
        case sesacKey = "SesacKey"
        case refresh = "Refresh"
        case contentType = "Content-Type"
        case json = "application/json"
        case multipart = "multipart/form-data"
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
