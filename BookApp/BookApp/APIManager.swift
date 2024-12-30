//
//  APIManager.swift
//  BookApp
//
//  Created by 손겸 on 12/27/24.
//

import Foundation
import RxSwift

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func fetchBooks(query: String) -> Single<[KakaoBook]> {
        let urlString = "https://dapi.kakao.com/v3/search/book?query=\(query)"
        guard let url = URL(string: urlString) else {
            return Single.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
        print("Request URL: \(urlString)") // 요청 URL 확인
        
        var request = URLRequest(url: url)
        request.setValue("KakaoAK 3a4facecbe99c3bf5eab0a5480368bd5", forHTTPHeaderField: "Authorization") // KakaoAK로 변경
        
        // 헤더와 요청 정보 확인
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        return Single.create { single in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network Error: \(error.localizedDescription)") // 네트워크 에러 로그
                    single(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(response.statusCode)") // HTTP 상태 코드 확인
                }
                
                guard let data = data else {
                    print("No data received") // 데이터가 없을 경우
                    single(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(KakaoBookResponse.self, from: data)
                    print("Decoded Response: \(response)") // 디코딩된 데이터 출력
                    single(.success(response.documents))
                } catch {
                    print("Decoding Error: \(error.localizedDescription)") // 디코딩 오류 로그
                    single(.failure(error))
                }
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
