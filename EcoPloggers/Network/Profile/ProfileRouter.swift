//
//  ProfileRouter.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/25/24.
//

import Foundation

import Alamofire

enum ProfileRouter {
    case myProfile
    case editMyProfile
    case otherProfile(otherID: String)
    case searchProfile(otherNickname: SearchOtherQuery)
}

extension ProfileRouter: TargetType {
    var baseURL: String {
        guard let base = Constant.NetworkComponents.baseURL else { return "" }
        return base
    }
    var method: HTTPMethod {
        switch self {
        case .myProfile, .otherProfile, .searchProfile: return .get
        case .editMyProfile: return .put
        }
    }
    var path: String {
        switch self {
        case .myProfile, .editMyProfile: return "/v1/users/me/profile"
        case .otherProfile(let id): return "/v1/users/\(id)/profile"
        case .searchProfile: return "/v1/users/search"
        }
    }
    
    var header: [String : String] {
        guard let apiKey = Constant.NetworkComponents.apiKey else {
            print("🔑 API Key error")
            return ["": ""]
        }
        let baseHeaders = [
            Constant.NetworkHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
            Constant.NetworkHeader.sesacKey.rawValue: apiKey
        ]
        switch self {
        case .editMyProfile:
            return ["": ""]
        default:
            return baseHeaders
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .myProfile, .editMyProfile, .otherProfile: return nil
        case .searchProfile(let nickname):
            return [URLQueryItem(name: "nick", value: nickname.nick)]
        }
    }
    
    // MARK: Multipart/form-data : editMyProfile !!
    var body: Data? {
        return nil
    }
}
