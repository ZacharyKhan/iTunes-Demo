//
//  AppDelegate.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 10/31/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let navController1 : UINavigationController = {
        let nc = UINavigationController(rootViewController: Top40ViewController())
        nc.navigationBar.isTranslucent = false
        nc.navigationBar.barTintColor = .white
        nc.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red:0.23, green:0.22, blue:0.21, alpha:1.0)]
        nc.tabBarItem = UITabBarItem(title: "Top 40", image: #imageLiteral(resourceName: "top_40_icon"), tag: 0)
        return nc
    }()
    
    private let navController2 : UINavigationController = {
        let nc = UINavigationController(rootViewController: SearchViewController())
        nc.navigationBar.isTranslucent = false
        nc.navigationBar.barTintColor = .white
        nc.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red:0.23, green:0.22, blue:0.21, alpha:1.0)]
        nc.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "search_icon"), tag: 1)
        return nc
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabBarController = UITabBarController()
        let controllers = [navController1,navController2]
        tabBarController.setViewControllers(controllers, animated: true)

        window = UIWindow()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

