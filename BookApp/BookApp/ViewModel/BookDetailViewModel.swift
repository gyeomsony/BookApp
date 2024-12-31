//
//  BookDetailViewModel.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import RxSwift

class BookDetailViewModel {
    private let coreDataManager: CoreDataManager
    private let disposeBag = DisposeBag()
    
    var bookTitle: String
    var bookAuthor: String
    var bookDescription: String?
    var bookImage: UIImage?
    var bookPrice: Int
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared, bookTitle: String, bookAuthor: String, bookDescription: String? = nil, bookImage: UIImage? = nil, bookPrice: Int) {
        self.coreDataManager = coreDataManager
        self.bookTitle = bookTitle
        self.bookAuthor = bookAuthor
        self.bookDescription = bookDescription
        self.bookImage = bookImage
        self.bookPrice = bookPrice
    }
    
    func saveBook() {
        coreDataManager.addBook(title: bookTitle, author: bookAuthor, image: bookImage, price: bookPrice)
    }
}

