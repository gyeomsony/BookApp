//
//  JSONDecoderManager.swift
//  BookApp
//
//  Created by 손겸 on 12/27/24.
//

import Foundation
import RxSwift

class JSONDecoderManager {
    static let shared = JSONDecoderManager()
    private let decoder = JSONDecoder()
    
    private init() {}
    
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> Single<T> {
        return Single.create { single in
            do {
                let decodedObject = try self.decoder.decode(T.self, from: data)
                single(.success(decodedObject))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}

class APIManager {
    static let shared = APIManager()
    private let decoderManager = JSONDecoderManager.shared
    
    private init() {}
    
    func fetchBooks(query: String) -> Single<[KakaoBook]> {
        let apiKey = "3a4facecbe99c3bf5eab0a5480368bd5"
        let urlString = "https://dapi.kakao.com/v3/search/book?query=\(query)"
        
        guard let url = URL(string: urlString) else {
            return Single.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization": "KakaoAK \(apiKey)"]
        
        return Single<Data>.create { single in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = data else {
                    single(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                    return
                }
                
                single(.success(data))
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        .flatMap { data in
            self.decoderManager.decode(KakaoBookResponse.self, from: data)
        }
        .map { response in
            response.documents
        }
    }
}

