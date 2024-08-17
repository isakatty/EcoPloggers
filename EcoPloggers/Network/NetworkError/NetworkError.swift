//
//  NetworkError.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/16/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidError
    case invalidData
    case tempStatusCodeError(Int)
}

enum StatusCode: LocalizedError {
    case common(errorCode: Int)
    case login(errorCode: Int)
    case signup(errorCode: Int)
    case validateEmail(errorCode: Int)
    case refreshToken(errorCode: Int)
    case withdraw(errorCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .common(let errorCode):
            var errorDes: String = ""
            switch errorCode {
            case 420:
                errorDes = "SesacKey 오류"
            case 429:
                errorDes = "서버 과호출"
            case 444:
                errorDes = "비정상 URL"
            case 500:
                errorDes = "서버 오류"
            default:
                errorDes = "unknown Error"
            }
            return errorDes
        case .login(let errorCode):
            var errorDes: String = ""
            switch errorCode {
            case 200:
                errorDes = "통신 성공"
            case 400:
                errorDes = "필수값 누락"
            case 401:
                errorDes = "계정 확인 필요"
            default:
                errorDes = "unknown Error"
            }
            return errorDes
        case .signup(let errorCode):
            var errorDes: String = ""
            switch errorCode {
            case 200:
                errorDes = "통신 성공"
            case 400:
                errorDes = "필수값 누락"
            case 409:
                errorDes = "이미 가입한 유저"
            default:
                errorDes = "unknown Error"
            }
            return errorDes
        case .validateEmail(let errorCode):
            var errorDes: String = ""
            switch errorCode {
            case 200:
                errorDes = "통신 성공"
            case 400:
                errorDes = "필수값 누락"
            case 409:
                errorDes = "사용 불가능한 이메일"
            default:
                errorDes = "unknown Error"
            }
            return errorDes
        case .refreshToken(let errorCode):
            var errorDes: String = ""
            switch errorCode {
            case 200:
                errorDes = "통신 성공"
            case 401:
                errorDes = "token 오류"
            case 403:
                errorDes = "Forbidden"
            case 418:
                errorDes = "Refresh Token 만료"
            default:
                errorDes = "unknown Error"
            }
            return errorDes
        case .withdraw(let errorCode):
            var errorDes: String = ""
            switch errorCode {
            case 200:
                errorDes = "통신 성공"
            case 401:
                errorDes = "인증 할 수 없는 token"
            case 403:
                errorDes = "Forbidden"
            case 419:
                errorDes = "AccessToken 만료"
            default:
                errorDes = "unknown Error"
            }
            return errorDes
        }
    }
}
