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
}
