//
//  DataModel.swift
//  BookApp
//
//  Created by 손겸 on 12/27/24.
//

import Foundation

struct KakaoBookResponse: Codable {
    let documents: [KakaoBook]
    let meta: Meta
}

struct KakaoBook: Codable {
    let title: String
    let authors: [String]
    let publisher: String?
    let thumbnail: String?
    let contents: String?
    let price: Int?
    
    init(title: String, authors: [String], publisher: String? = nil, thumbnail: String? = nil, contents: String? = nil, price: Int? = nil) {
        self.title = title
        self.authors = authors
        self.publisher = publisher
        self.thumbnail = thumbnail
        self.contents = contents
        self.price = price
    }
}

struct Meta: Codable {
    let total_count: Int
    let pageable_count: Int
    let is_end: Bool
}



