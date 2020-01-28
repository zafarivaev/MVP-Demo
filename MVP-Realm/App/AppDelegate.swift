//
//  AppDelegate.swift
//  MVP-Realm
//
//  Created by Zafar on 1/28/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let view = ItemsViewController()
        let presenter = ItemsPresenter(view: view)
        view.presenter = presenter
        
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: view)
        window?.makeKeyAndVisible()
        
        return true
    }

}

