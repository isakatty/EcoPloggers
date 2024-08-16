//
//  NetworkManager.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/16/24.
//

import Foundation

import RxSwift
import RxCocoa

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callUserRequest<T: Decodable>(
        endpoint: EndpointType,
        type: T.Type
    ) -> Single<Result<T, NetworkError>> {
        
        let session = URLSession.shared
        return Single.create { observer -> Disposable in
            
            guard let urlRequest = endpoint.toURLRequest else {
                observer(.success(.failure(NetworkError.invalidURL)))
                return Disposables.create()
            }
            session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    observer(.success(.failure(NetworkError.invalidError)))
                }
                guard let response = response as? HTTPURLResponse else {
                    observer(.success(.failure(NetworkError.invalidResponse)))
                    return
                }
                if let userRequest = endpoint as? UserRequest {
                    let statusCodeError: StatusCode?
                    switch userRequest {
                    case .login:
                        statusCodeError = self.handleLoginStatusCode(response.statusCode)
                    case .signup:
                        statusCodeError = self.handleSignupStatusCode(response.statusCode)
                    case .refreshToken:
                        statusCodeError = self.handleRefreshTokenStatusCode(response.statusCode)
                    case .validateEmail:
                        statusCodeError = self.handleValidateEmailStatusCode(response.statusCode)
                    case .withdraw:
                        statusCodeError = self.handleWithdrawStatusCode(response.statusCode)
                    }
                    
                    if let error = statusCodeError {
                        observer(.success(.failure(.statusCodeError(error))))
                        return
                    }
                }
                
                if let data = data,
                   let appData = try? JSONDecoder().decode(T.self, from: data) {
                    observer(.success(.success(appData)))
                } else {
                    observer(.success(.failure(.invalidData)))
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}
extension NetworkManager {
    private func handleLoginStatusCode(_ statusCode: Int) -> StatusCode? {
        switch statusCode {
        case 400, 401:
            return .login(errorCode: statusCode)
        default:
            return nil
        }
    }

    private func handleSignupStatusCode(_ statusCode: Int) -> StatusCode? {
        switch statusCode {
        case 400, 409:
            return .signup(errorCode: statusCode)
        default:
            return nil
        }
    }

    private func handleRefreshTokenStatusCode(_ statusCode: Int) -> StatusCode? {
        switch statusCode {
        case 418, 401, 403:
            return .refreshToken(errorCode: statusCode)
        default:
            return nil
        }
    }

    private func handleWithdrawStatusCode(_ statusCode: Int) -> StatusCode? {
        switch statusCode {
        case 419, 401, 403:
            return .withdraw(errorCode: statusCode)
        default:
            return nil
        }
    }
    private func handleValidateEmailStatusCode(_ statusCode: Int) -> StatusCode? {
        switch statusCode {
        case 400, 409:
            return .validateEmail(errorCode: statusCode)
        default:
            return nil
        }
    }
}
