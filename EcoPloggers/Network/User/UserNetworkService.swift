//
//  UserNetworkService.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/21/24.
//

import Foundation

import Alamofire
import RxSwift

struct UserNetworkService {
    static func createLogin(query: LogInQuery) -> Single<LoginResult> {
        return Single.create { single in
            do {
                let urlRequest = try UserRouter.login(login: query).asURLRequest()
                
                AF.request(urlRequest)
                    .responseDecodable(of: LoginResponse.self) { response in
                        switch response.result {
                        case .success(let login):
                            single(.success(LoginResult.success(login)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.badRequest))
                            case 401:
                                single(.success(.unauthorized))
                            default:
                                single(.success(.error(.unknown)))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    static func validateEmail(query: ValidateEmailQuery) -> Single<ValidateEmailResult> {
        return Single.create { single in
            do {
                let urlRequest = try UserRouter.validateEmail(email: query).asURLRequest()
                
                AF.request(urlRequest)
                    .responseDecodable(of: ValidateEmailResponse.self) { response in
                        switch response.result {
                        case .success(let email):
                            if email.message == "사용이 불가한 이메일입니다." {
                                single(.success(.invalidEmail(email)))
                            } else {
                                single(.success(ValidateEmailResult.success(email)))
                            }
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.badRequest))
                            case 409:
                                single(.success(.invalidEmail(response.value ?? ValidateEmailResponse(message: ""))))
                            default:
                                single(.success(.error(.unknown)))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    static func signUpUser(query: SignUpQuery) -> Single<SignUpResult> {
        return Single.create { single in
            do {
                let urlRequest = try UserRouter.signup(signup: query).asURLRequest()
                
                AF.request(urlRequest)
                    .responseDecodable(of: SignUpResponse.self) { response in
                        switch response.result {
                        case .success(let signUp):
                            single(.success(SignUpResult.success(signUp)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 400:
                                single(.success(.badRequest))
                            case 402:
                                single(.success(.whiteSpacesNickname))
                            case 409:
                                single(.success(.alreadyOwned))
                            default:
                                single(.success(.error(.unknown)))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    static func refreshToken() -> Single<RefreshTokenResult> {
        return Single.create { single in
            do {
                let refreshToken = UserDefaultsManager.shared.refreshToken
                let urlRequest = try UserRouter.refreshToken(refreshToken: refreshToken).asURLRequest()
                
                AF.request(urlRequest, interceptor: NetworkInterceptor())
                    .responseDecodable(of: RefreshResponse.self) { response in
                        switch response.result {
                        case .success(let refresh):
                            single(.success(.success(refresh)))
                        case .failure(_):
                            switch response.response?.statusCode {
                            case 401:
                                single(.success(.unauthorized))
                            case 403:
                                single(.success(.forbidden))
                            case 418:
                                single(.success(.reLogin))
                            default:
                                single(.success(.error(.unknown)))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
