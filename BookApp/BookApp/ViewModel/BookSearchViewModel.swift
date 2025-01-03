//
//  BookSearchViewModel.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import RxSwift

class BookSearchViewModel {
    private let coreDataManager: CoreDataManager
    private let disposeBag = DisposeBag()
    
    let searchQuery = BehaviorRelay<String>(value: "")
}
