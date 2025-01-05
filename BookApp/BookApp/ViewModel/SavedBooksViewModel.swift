//
//  SavedBooksViewModel.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import RxSwift
import RxRelay

class SavedBooksViewModel {
    let coreDataManager: CoreDataManager
    let savedBooks = BehaviorRelay<[BookEntity]>(value: [])

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func loadBooks() {
        let books = coreDataManager.fetchBooks()
        print("Fetched \(books.count) books from Core Data") // 디버깅 로그
        savedBooks.accept(books)
    }

    func deleteAllBooks() {
        coreDataManager.deleteAllBooks()
        loadBooks() // 삭제 후 다시 로드
        print("All books deleted and reloaded") // 디버깅 로그
    }
}


