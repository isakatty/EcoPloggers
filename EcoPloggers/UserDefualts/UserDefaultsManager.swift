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
        case userId
        case alreadySeen
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
    var myUserID: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.userId.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.userId.rawValue)
        }
    }
    var postLists: [ViewPostDetailResponse] {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.alreadySeen.rawValue),
                  let posts = try? JSONDecoder().decode([ViewPostDetailResponse].self, from: data) else {
                return []
            }
            return posts
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: UserDefaultsKey.alreadySeen.rawValue)
            }
        }
    }
    
}
