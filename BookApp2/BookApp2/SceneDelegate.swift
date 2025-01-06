//
//  SceneDelegate.swift
//  BookApp2
//
//  Created by 손겸 on 1/6/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        
        tabBarController.tabBar.backgroundColor = .white
        
        tabBarController.viewControllers = [SearchBookViewController(), StoreBookViewController()]
        
        self.window?.rootViewController = tabBarController
        
        self.window?.makeKeyAndVisible()
    }
}

