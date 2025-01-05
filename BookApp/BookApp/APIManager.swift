//
//  APIManager.swift
//  BookApp
//
//  Created by 손겸 on 12/27/24.
//

import Moya
import RxSwift
import RxMoya

class APIManager {
    static let shared = APIManager()
    private let provider = MoyaProvider<BookApi>()
    
    private init() {}
    
    func fetchBooks(query: String) -> Single<[KakaoBook]> {
        print("Fetching books for query: \(query)") // 디버깅 로그 추가
        return provider.rx.request(.searchBooks(query: query))
            .filterSuccessfulStatusCodes()
            .map(KakaoBookResponse.self)
            .map { $0.documents }
            .do(
                onSuccess: { books in
                print("Fetched \(books.count) books") // 결과 개수 출력
            },
                onError: { error in
                print("API Error: \(error.localizedDescription)") // 에러 로그 출력
            })
    }
}
