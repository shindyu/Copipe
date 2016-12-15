//
//  AppDelegate.swift
//  Copipe
//
//  Created by shindyu on 2016/11/16.
//  Copyright © 2016年 shindyu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let navigationController = UINavigationController(rootViewController: TabBarController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        self.backgroundTaskID = application.beginBackgroundTaskWithExpirationHandler() {
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskInvalid
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        application.endBackgroundTask(self.backgroundTaskID)
    }

}

