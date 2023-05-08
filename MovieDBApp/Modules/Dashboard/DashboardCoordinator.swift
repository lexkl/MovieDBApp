//
//  DashboardCoordinator.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation
import Combine
import UIKit

protocol DashboardNavigation: AnyObject {
    func segmentChanged(with index: Int)
}

final class DashboardCoordinator: Coordinator {
    let onFinish: () -> Void
    var coordinators = [Coordinator]()
    
    private let currentViewControllerSubject = CurrentValueSubject<UIViewController?, Never>(nil)
    private let navigation: UINavigationController
    private let segments: [DashboardSegment]
    private let viewControllerFactory: DashboardViewControllerFactory
    
    init(navigation: UINavigationController,
         segments: [DashboardSegment],
         viewControllerFactory: DashboardViewControllerFactory,
         onFinish: @escaping () -> Void) {
        self.navigation = navigation
        self.segments = segments
        self.viewControllerFactory = viewControllerFactory
        self.onFinish = onFinish
    }
    
    func start() {
        let viewModel = DashboardViewModelImpl(segments: segments,
                                               segmentChanged: currentViewControllerSubject.eraseToAnyPublisher(),
                                               navigation: self)
        let viewController = DashboardViewController(viewModel: viewModel)
        navigation.setNavigationBarHidden(true, animated: false)
        navigation.pushViewController(viewController, animated: true)
    }
}

// MARK: - EMSPatientsNavigation

extension DashboardCoordinator: DashboardNavigation {
    func segmentChanged(with index: Int) {
        let segment = segments[index]
        currentViewControllerSubject.value = viewControllerFactory.viewController(for: segment)
    }
}
