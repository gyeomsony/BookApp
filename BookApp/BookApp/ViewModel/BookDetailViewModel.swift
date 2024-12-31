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
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared, bookTitle: String, bookAuthor: String, bookDescription: String? = nil, bookImage: UIImage? = nil) {
        self.coreDataManager = coreDataManager
        self.bookTitle = bookTitle
        self.bookAuthor = bookAuthor
        self.bookDescription = bookDescription
        self.bookImage = bookImage
    }
    
    func saveBook() {
        coreDataManager.addBook(title: bookTitle, author: bookAuthor, image: bookImage)
    }
}

