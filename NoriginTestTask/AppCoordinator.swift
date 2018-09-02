//
//  AppCoordinator.swift
//  NoriginTestTask
//
//  Created by user on 9/2/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeViewController(),
                                            tvViewController(),
                                            epgViewController(),
                                            playViewController(),
                                            bookViewController()]
        // show list view controller on startup
        tabBarController.selectedIndex = 2
        window.rootViewController = tabBarController
    }
    
    
    private func homeViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "homeTab"), selectedImage: nil)
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return viewController
    }

    private func tvViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "homeTab"), selectedImage: nil)
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return viewController
    }

    private func epgViewController() -> UIViewController {
        let viewController = UIStoryboard.instantiate(EPGViewController.self)
        let viewModel = EPGViewModel1()
        viewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "listTab"), selectedImage: nil)
        navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return navigationController
    }

    private func playViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "playTab"), selectedImage: nil)
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return viewController
    }
    
    private func bookViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "bookTab"), selectedImage: nil)
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return viewController
    }


}
