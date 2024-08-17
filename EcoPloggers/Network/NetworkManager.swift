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
//            print("Request URL: \(urlRequest.url?.absoluteString ?? "No URL")")
//            print("Request Method: \(urlRequest.httpMethod ?? "No Method")")
//            print("Request Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
//            print("Request Body: \(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "No Body")")
            
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
