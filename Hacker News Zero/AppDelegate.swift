//
//  AppDelegate.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 1/21/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        setupNavigator()
        
        return false
    }
    
    private func setupNavigator() {
    
        guard let splitViewController = window?.rootViewController as? UISplitViewController,
            let leftNavController = splitViewController.viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.topViewController as? ArticleViewController,
            let rightNavController = splitViewController.viewControllers.last as? UINavigationController,
            let detailViewController = rightNavController.topViewController as? ArticleContainerViewController
            else { fatalError() }
        
        let navigator = ArticleNavigator(with: splitViewController,
                                         articleList: masterViewController,
                                         articleDetail: detailViewController)
        
        masterViewController.navigator = navigator
        detailViewController.navigator = navigator
    
    
    }

}

