//
//  AppDelegate.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 1/21/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit
import CoreData
import AlamofireNetworkActivityLogger
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        setupNetworkLogging()
        setupFirebase()
        return false
    }
    
    func setupNetworkLogging() {
        #if DEBUG
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif
    }
    
    func setupFirebase() {
        
        FirebaseApp.configure()
        
        #if DEBUG
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(false)
        #endif
        
    }
}

