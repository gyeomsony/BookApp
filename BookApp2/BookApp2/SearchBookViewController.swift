//
//  SearchBookViewController.swift
//  BookApp2
//
//  Created by 손겸 on 1/6/25.
//

import UIKit
import SnapKit

class SearchBookViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.tabBarItem = UITabBarItem(title: "Search",
                                       image: UIImage(systemName: "magnifyingglass"),
                                       tag: 0)
        self.view.backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.makeConstraints()
    }

    private func configureUI() {
        self.view.addSubview(searchBar)
    }
    
    private func makeConstraints() {
        
    }
}
