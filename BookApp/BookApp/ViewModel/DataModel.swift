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
    let publisher: String
    let thumbnail: String?
}

