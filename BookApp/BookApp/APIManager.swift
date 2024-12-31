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
        return provider.rx.request(.searchBooks(query: query))
            .filterSuccessfulStatusCodes()
            .map(KakaoBookResponse.self)
            .map { $0.documents }
    }
}
