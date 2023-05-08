//
//  DashboardViewFactory.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation
import UIKit

protocol DashboardViewControllerFactory {
    func viewController(for segment: DashboardSegment) -> UIViewController
}

struct DashboardViewControllerFactoryImpl: DashboardViewControllerFactory {
    func viewController(for segment: DashboardSegment) -> UIViewController {
        switch segment {
        case .popular:
            return popular()
        case .new:
            return new()
        }
    }
}

private extension DashboardViewControllerFactoryImpl {
    func popular() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .mainGray
        return viewController
    }
    
    func new() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .mainGray
        return viewController
    }
}
