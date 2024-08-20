//
//  NetworkManager.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/16/24.
//

import Foundation

import Alamofire
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
//            print("Request URL: \(urlRequest.url?.absoluteString ?? "No URL")")
//            print("Request Method: \(urlRequest.httpMethod ?? "No Method")")
//            print("Request Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
//            print("Request Body: \(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "No Body")")
//            if #available(iOS 16.0, *) {
//                print("Request query: \(urlRequest.url?.query(percentEncoded: true))")
//            } else {
//                // Fallback on earlier versions
//            }
            
            session.dataTask(with: urlRequest) { data, response, error in
                if let _ = error {
                    observer(.success(.failure(NetworkError.invalidError)))
                }
                guard let response = response as? HTTPURLResponse else {
                    observer(.success(.failure(NetworkError.invalidResponse)))
                    return
                }
                
                if !(200...299).contains(response.statusCode) {
                    observer(.success(.failure(NetworkError.tempStatusCodeError(response.statusCode))))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let data = data,
                   let appData = try? decoder.decode(T.self, from: data) {
                    observer(.success(.success(appData)))
                } else {
                    observer(.success(.failure(.invalidData)))
                }
            }.resume()
            
            return Disposables.create()
        }
    }
    func callMockData() -> Single<Result<ViewPostResponseDTO, NetworkError>> {
        return Single.create { observer in
            guard let path = Bundle.main.path(forResource: "mockPlogging", ofType: "json"),
                  let jsonString = try? String(contentsOfFile: path) else {
                observer(.success(.failure(NetworkError.invalidURL)))
                return Disposables.create()
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let data = jsonString.data(using: .utf8)
            
            if let data = data,
               let converted = try? decoder.decode(ViewPostResponseDTO.self, from: data) {
                observer(.success(.success(converted)))
            } else {
                observer(.success(.failure(NetworkError.invalidData)))
            }
            
            return Disposables.create()
        }
    }
    func callRequest<T: Decodable>(
        endpoint: TargetType,
        type: T.Type
    ) -> Single<T> {
        return Single.create { observer in
            do {
                let urlRequest = try endpoint.asURLRequest()
                AF.request(urlRequest, interceptor: NetworkInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let value):
                            observer(.success(value))
                        case .failure(let error):
                            observer(.failure(error))
                        }
                    }
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    func callRequestss<T: Decodable>(
        endpoint: TargetType,
        type: T.Type
    ) -> Single<T> {
        return Single.create { observer in
            do {
                let urlRequest = try endpoint.asURLRequest()
                AF.request(urlRequest, interceptor: NetworkInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let value):
                            observer(.success(value))
                        case .failure(let error):
                            observer(.failure(error))
                        }
                    }
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
}
