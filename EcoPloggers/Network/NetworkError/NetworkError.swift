//
//  NetworkError.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/16/24.
//

import Foundation

enum HTTPError: Int, Error {
    case requiredValueMissing = 400
    case authenticatedToken = 401
    case whitespacesNickname = 402
    case forbidden = 403
    case cantUseEmail = 409
    case postNotFound = 410
    case expiredRefreshToken = 418
    case expiredAccessToken = 419
    case invalidSesacKey = 420
    case rateLimitExceeded = 429
    case invalidURL = 444
    case authorizationError = 445
    case serverError = 500
}

extension HTTPError {
    var localizedDescription: String {
        switch self {
        case .requiredValueMissing: "필수값을 채워주세요"
        case .authenticatedToken: "계정을 확인해주세요"
        case .forbidden: "접근 권한이 없습니다"
        case .cantUseEmail: "사용할 수 없는 이메일입니다"
        case .expiredRefreshToken: "리프레쉬 토큰이 만료되어 로그인해야 합니다"
        case .expiredAccessToken: "엑세스 토큰이 만료되어 재 로그인 시도합니다"
        case .invalidSesacKey: "잘못된 시크릿 키입니다"
        case .rateLimitExceeded: "과호출입니다"
        case .invalidURL: "비정상 URL입니다"
        case .serverError: "서버 오류입니다. 잠시 후 다시 시도해주세요"
        case .whitespacesNickname: "공백이 포함되어 있는 닉네임은 사용할 수 없습니다"
        case .postNotFound: "수정할 데이터를 찾을 수 없습니다."
        case .authorizationError: "수정 권한이 없습니다."
        }
    }
}
