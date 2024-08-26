//
//  KingfisherManager.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import Foundation

import Kingfisher

extension KingfisherManager {
    var modifier: AnyModifier {
        return AnyModifier { request in
            let apiKey = Constant.NetworkComponents.apiKey
            var r = request
            r.headers = [Constant.NetworkHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                         Constant.NetworkHeader.contentType.rawValue: Constant.NetworkHeader.json.rawValue,
                         Constant.NetworkHeader.sesacKey.rawValue: apiKey ?? ""]
            return r
        }
    }
    func getImageURL(path: String?, completionHandler: (URL?) -> Void) {
        if let path,
           let baseURL = Constant.NetworkComponents.baseURL,
           let url = URL(string: "\(baseURL)v1/" + path) {
            completionHandler(url)
        } else {
            completionHandler(nil)
        }
    }
}
