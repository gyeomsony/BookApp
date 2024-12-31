//
//  DataModel.swift
//  BookApp
//
//  Created by 손겸 on 12/27/24.
//

import Foundation

struct KakaoBookResponse: Codable {
    let documents: [KakaoBook]
}

struct KakaoBook: Codable {
    let title: String
    let authors: [String]
    let price: Int?
    let contents: String?
    let thumbnail: String?
    
    init(title: String, authors: [String], price: Int?, contents: String?, thumbnail: String?) {
        self.title = title
        self.authors = authors
        self.price = price
        self.contents = contents
        self.thumbnail = thumbnail
    }
}




