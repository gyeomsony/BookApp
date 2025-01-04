//
//  MainTabBarController.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CoreDataManager 인스턴스를 생성
        let coreDataManager = CoreDataManager.shared  // CoreDataManager 싱글톤
        let viewModel = BookSearchViewModel() // ViewModel 초기화
        
        // 책 검색 화면
        let bookSearchVC = BookSearchViewController(viewModel: viewModel, coreDataManager: coreDataManager)
        let searchNavigationController = UINavigationController(rootViewController: bookSearchVC)
        searchNavigationController.tabBarItem = UITabBarItem(title: "검색",
                                                             image: UIImage(systemName: "magnifyingglass"),
                                                             tag: 0)
        
        // 담은 책 리스트 화면
        let savedBooksVC = SavedBooksViewController()
        let savedNavigationController = UINavigationController(rootViewController: savedBooksVC)
        savedNavigationController.tabBarItem = UITabBarItem(title: "담은 책 리스트",
                                                            image: UIImage(systemName: "bookmark"),
                                                            tag: 1)
        
        // 탭바에 뷰 컨트롤러 추가
        viewControllers = [searchNavigationController, savedNavigationController]
    }
}




