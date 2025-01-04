//
//  BookSearchViewModel.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import RxSwift
import RxCocoa

class BookSearchViewModel {
    // Core Data 관리 객체
    private let coreDataManager: CoreDataManager
    private let disposeBag = DisposeBag()
    
    // 검색 쿼리 입력을 위한 BehaviorRelay
    let searchQuery = BehaviorRelay<String>(value: "")
    
    // 검색 결과 Observable (뷰에 바인딩될 데이터)
    let searchResults = BehaviorRelay<[KakaoBook]>(value: [])
    
    // 최근 본 책 Observable (뷰에 바인딩될 데이터)
    let recentBooks = BehaviorRelay<[KakaoBook]>(value: [])
    
    // 초기화
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        bindSearchQuery()
        loadRecentBooks()
    }
    
    // 검색어와 API 호출을 바인딩
    private func bindSearchQuery() {
        searchQuery
            .distinctUntilChanged() // 같은 검색어는 무시
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance) // 디바운스 적용
            .filter { !$0.isEmpty && $0.count >= 2 } // 최소 2글자 입력
            .flatMapLatest { query in
                APIManager.shared.fetchBooks(query: query)
                    .asObservable()
                    .catchAndReturn([]) // 에러 발생 시 빈 배열 반환
            }
            .bind(to: searchResults)
            .disposed(by: disposeBag)
    }
    
    // Core Data에서 최근 본 책 로드
    private func loadRecentBooks() {
        let books = coreDataManager.fetchRecentBooks() // CoreDataManager의 메서드
        recentBooks.accept(books)
    }
    
    // 최근 본 책 저장
    func addBookToRecent(_ book: KakaoBook) {
        coreDataManager.saveBook(book) // CoreDataManager의 메서드
        loadRecentBooks() // 저장 후 최신 상태 로드
    }
}

