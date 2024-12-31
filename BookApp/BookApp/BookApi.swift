//
//  BookApi.swift
//  BookApp
//
//  Created by 손겸 on 12/31/24.
//

import Moya
import Foundation

enum BookApi {
    case searchBooks(query: String)
}

extension BookApi: TargetType {
    var path: String {
        switch self {
        case .searchBooks:
            return "/v3/search/book"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case.searchBooks:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchBooks(let query):
            return .requestParameters(parameters: ["query" : query], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization": "KakaoAK 3a4facecbe99c3bf5eab0a5480368bd5"]
    }
    
    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com")!
    }
}

