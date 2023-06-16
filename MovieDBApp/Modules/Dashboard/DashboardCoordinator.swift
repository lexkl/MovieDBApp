//
//  DashboardCoordinator.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation
import Combine
import UIKit
import Swinject

protocol DashboardNavigation: AnyObject {
    func segmentChanged(with index: Int)
}

protocol DashboardContentNavigation: AnyObject {
    func movieSelected(image: UIImage, movieId: Int)
}

final class DashboardCoordinator: NSObject, Coordinator {
    let onFinish: () -> Void
    var coordinators = [Coordinator]()
    
    private let currentViewControllerSubject = CurrentValueSubject<UIViewController?, Never>(nil)
    private let navigation: UINavigationController
    private let segments: [DashboardSegment]
    private var viewControllerFactory: DashboardViewControllerFactory
    
    private var cancellables = Set<AnyCancellable>()
    
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
        navigation.delegate = self
        viewControllerFactory.navigation = self
        
        let viewModel = DashboardViewModelImpl(segments: segments,
                                               segmentChanged: currentViewControllerSubject.eraseToAnyPublisher(),
                                               navigation: self)
        let viewController = DashboardViewController(viewModel: viewModel)
        navigation.setNavigationBarHidden(true, animated: false)
        navigation.pushViewController(viewController, animated: true)
    }
}

// MARK: - DashboardNavigation

extension DashboardCoordinator: DashboardNavigation {
    func segmentChanged(with index: Int) {
        let segment = segments[index]
        currentViewControllerSubject.value = viewControllerFactory.viewController(for: segment)
    }
}

// MARK: - DashboardContentNavigation

extension DashboardCoordinator: DashboardContentNavigation {
    func movieSelected(image: UIImage, movieId: Int) {
        let service = Container.shared.resolve(MovieDetailsService.self)!
        let provider = MovieDetailsProviderImpl(service: service)
        let viewModel = MovieDetailsViewModelImpl(posterImage: image, movieId: movieId, provider: provider)
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        viewController.navigationItem.hidesBackButton = true
        viewController.navigationItem.rightBarButtonItem = createBackButton()
        navigation.pushViewController(viewController, animated: true)
        navigation.setNavigationBarHidden(false, animated: false)
    }
    
    @objc
    private func onBack() {
        navigation.popViewController(animated: true)
    }
    
    private func createBackButton() -> UIBarButtonItem {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(onBack))
        backButton.tintColor = UIColor.black
        return backButton
    }
}

// MARK: - UINavigationControllerDelegate

extension DashboardCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .none:
            return nil
        case .push:
            return MovieDetailsTransitionPush()
        case .pop:
            return MovieDetailsTransitionPop()
        @unknown default:
            return nil
        }
    }
}
