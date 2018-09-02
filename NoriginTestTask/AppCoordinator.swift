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

    private let webLoader = TRONWebLoader()

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarController = UITabBarController()
        let epgViewController = self.epgViewController()
        tabBarController.viewControllers = [homeViewController(),
                                            tvViewController(),
                                            epgViewController,
                                            playViewController(),
                                            bookViewController()]
        // show list view controller on startup
        tabBarController.selectedViewController = epgViewController
        window.rootViewController = tabBarController
    }
    
    
    private func homeViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.tabBarItem = tabBarItemWithImage(named: "homeTab")
        return viewController
    }

    private func tvViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.tabBarItem = tabBarItemWithImage(named: "tvTab")
        return viewController
    }

    private func epgViewController() -> UIViewController {
        let viewController = UIStoryboard.instantiate(EPGViewController.self)
        let epgRESTService = EPGRESTService(loader: webLoader)
        let viewModel = EPGViewModel1(epgService: epgRESTService)
        viewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem = tabBarItemWithImage(named: "listTab")
        return navigationController
    }

    private func playViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.tabBarItem = tabBarItemWithImage(named: "playTab")
        return viewController
    }
    
    private func bookViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.tabBarItem = tabBarItemWithImage(named: "bookTab")
        return viewController
    }

    private func tabBarItemWithImage(named name: String) -> UITabBarItem {
        let tabBarItem = UITabBarItem(title: nil, image: UIImage(named: name), selectedImage: nil)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return tabBarItem
    }
    
}
