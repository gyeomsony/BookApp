//
//  StoreBookViewController.swift
//  BookApp2
//
//  Created by 손겸 on 1/6/25.
//

import UIKit

class StoreBookViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.tabBarItem = UITabBarItem(title: "Store",
                                       image: UIImage(systemName: "books.vertical"),
                                       tag: 0)
        self.view.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
