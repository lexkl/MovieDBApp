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
    func movieSelected(image: UIImage)
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
    func movieSelected(image: UIImage) {
        let viewModel = MovieDetailsViewModelImpl(posterImage: image)
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        navigation.pushViewController(viewController, animated: true)
        navigation.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - UINavigationControllerDelegate

extension DashboardCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return CustomTransition()
        }
        
        return nil
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension DashboardCoordinator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        print(transitionContext.viewController(forKey: .from)?.children)
//        guard
//            let fromViewController = transitionContext.viewController(forKey: .from)?.children.first as? DashboardContentViewController,
//            let toViewController = transitionContext.viewController(forKey: .to) as? MovieDetailsViewController,
//            let currentCell = fromViewController.carousel.currentCell
//        else { return }
//        
//        let containerView = transitionContext.containerView
//        let snapshot = UIImageView()
//        snapshot.contentMode = .scaleAspectFit
//        snapshot.frame = containerView.convert(currentCell.shadowImageView.frame, from: currentCell)
//        
//        containerView.addSubview(toViewController.view)
//        containerView.addSubview(snapshot)
//        
//        toViewController.view.isHidden = true
//        
//        
//        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
//            snapshot.frame = containerView.convert(toViewController.view.frame, from: toViewController.view)
//        }
//
//        animator.addCompletion { position in
//            toViewController.view.isHidden = false
//            snapshot.removeFromSuperview()
//            transitionContext.completeTransition(position == .end)
//        }
//
//        animator.startAnimation()
    }
}
