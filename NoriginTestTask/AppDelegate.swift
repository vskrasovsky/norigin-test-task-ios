//
//  AppDelegate.swift
//  NoriginTestTask
//
//  Created by user on 8/28/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    fileprivate var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setUpAppearance()
        
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
        window?.makeKeyAndVisible()
        
        return true
    }

    func setUpAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent

        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .navigationBarBackground
        UINavigationBar.appearance().tintColor = .barTint

        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .tabBarBackground
        UITabBar.appearance().tintColor = .accent
        UITabBar.appearance().unselectedItemTintColor = .white

    }
}
