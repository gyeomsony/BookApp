//
//  ViewController.swift
//  BookApp
//
//  Created by 손겸 on 12/23/24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MainTabBarController를 루트로 설정
        let tabBarController = MainTabBarController()
        
        // 탭바 컨트롤러를 루트 뷰 컨트롤러로 설정
        if let window = view.window {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
}
