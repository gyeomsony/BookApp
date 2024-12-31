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
    private let coreDataManager: CoreDataManager
    private let apiManager: APIManager
    private let disposeBag = DisposeBag()
    
    let savedBooks = BehaviorRelay<[KakaoBook]>(value: [])
    
    init(coreDataManager: CoreDataManager, apiManager: APIManager) {
        self.coreDataManager = coreDataManager
        self.apiManager = apiManager
        loadBooks()
    }
    
    private func loadBooks() {
        let bookEntities = CoreDataManager.shared.fetchBooks()
        let books = bookEntities.map { entity in
            KakaoBook(
                title: entity.title ?? "",
                authors: [entity.author ?? ""],
                price: Int(entity.price),
                contents: entity.contents ?? "",
                thumbnail: entity.thumbnail ?? ""
            )
        }
        savedBooks.accept(books)
    }
    
    func searchBooks(query: String) {
        apiManager.fetchBooks(query: query)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] books in
                self?.savedBooks.accept(books)
            }, onFailure:  { error in
                print("\(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    
    func deleteAllBooks() {
        CoreDataManager.shared.deleteAllBooks()
        loadBooks()
    }
}

