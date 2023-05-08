//
//  AppCoordinator.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation
import UIKit
import SwiftUI
import Combine

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let tabBar = UITabBarController()
    
    let onFinish: () -> Void
    var coordinators = [Coordinator]()
    
    init(window: UIWindow, onFinish: @escaping () -> Void) {
        self.window = window
        self.onFinish = onFinish
    }
    
    func start() {
        tabBar.viewControllers = tabBarViewControllers()
        tabBar.selectedIndex = TabBarItem.home.rawValue
        tabBar.tabBar.unselectedItemTintColor = UIColor.gray
        tabBar.tabBar.tintColor = UIColor.black
        tabBar.tabBar.barTintColor = UIColor.secondaryGray
        
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
}

private extension AppCoordinator {
    func tabBarViewControllers() -> [UIViewController] {
        TabBarItem.tabs.map { self.controller(for: $0) }
    }
    
    func controller(for tab: TabBarItem) -> UIViewController {
        switch tab {
        case .home:
            return home(tab: tab)
        case .search:
            return search(tab: tab)
        case .profile:
            return profile(tab: tab)
        }
    }
    
    func navigationController(tab: TabBarItem) -> UINavigationController {
        let navigation = UINavigationController()
        navigation.tabBarItem = tab.tabBarItem
        
        return navigation
    }
    
    func home(tab: TabBarItem) -> UIViewController {
        let navigationController = navigationController(tab: tab)
        let segments = DashboardSegment.allCases
        let viewControllerFactory = DashboardViewControllerFactoryImpl()
        let coordinator = DashboardCoordinator(navigation: navigationController,
                                               segments: segments,
                                               viewControllerFactory: viewControllerFactory) {
            print("DashboardCoordinator.OnFinish")
        }

        coordinator.start()
        store(coordinator: coordinator)
        return navigationController
    }
    
    func search(tab: TabBarItem) -> UIViewController {
        let navigationController = navigationController(tab: tab)
        return navigationController
    }
    
    func profile(tab: TabBarItem) -> UIViewController {
        let navigationController = navigationController(tab: tab)
        return navigationController
    }
}
