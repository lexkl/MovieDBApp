//
//  CustomTransitionPop.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 11.06.2023.
//

import Foundation
import UIKit

final class MovieDetailsTransitionPop: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from)
                as? MovieDetailsViewController,
            let toParentViewController = transitionContext.viewController(forKey: .to)
                as? DashboardViewController,
            let toViewController = transitionContext.viewController(forKey: .to)?.children.first
                as? DashboardContentViewController
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let fromImageView = fromViewController.imageView
        
        guard let snapshot = fromImageView.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let startFrame = fromImageView.convert(fromImageView.bounds, to: fromViewController.view)
        snapshot.frame = startFrame
        
        fromViewController.view.alpha = 0.0
        toViewController.view.alpha = 1.0
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toParentViewController.view, belowSubview: fromViewController.view)
        containerView.addSubview(snapshot)
        
        UIView.animate(withDuration: duration) {
            guard let toImageView = toViewController.carousel.currentCell?.shadowImageView.imageView else {
                return
            }
            
            let finalFrame = toImageView.convert(toImageView.bounds, to: toParentViewController.view)
            snapshot.frame = finalFrame
            snapshot.layer.cornerRadius = 10.0
            snapshot.layer.masksToBounds = true
        } completion: { _ in
            fromViewController.view.removeFromSuperview()
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
