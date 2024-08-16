//
//  UserDefaultsManager.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import Foundation

final class UserDefaultsManager {
    
    private enum UserDefaultsKey: String {
        case access
        case refresh
    }
    static let shared = UserDefaultsManager()
    private init() { }
    
    var accessToken: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.access.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.access.rawValue)
        }
    }
    var refreshToken: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.refresh.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.refresh.rawValue)
        }
    }
    
}
