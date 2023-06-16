//
//  CustomTransition.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 01.06.2023.
//

import Foundation
import UIKit

final class MovieDetailsTransitionPush: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from)?.children.first
                as? DashboardContentViewController,
            let toViewController = transitionContext.viewController(forKey: .to)
                as? MovieDetailsViewController,
            let imageView = fromViewController.carousel.currentCell?.shadowImageView.imageView
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let startFrame = imageView.convert(imageView.bounds, to: UIApplication.keyWindow)
        toViewController.view.alpha = 0.0
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        guard let snapshot = imageView.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        
        snapshot.frame = startFrame
        snapshot.layer.cornerRadius = 10.0
        snapshot.layer.masksToBounds = true
        containerView.addSubview(snapshot)
        
        UIView.animate(withDuration: duration) {
            let width = imageView.window?.windowScene?.screen.bounds.width ?? 0
            let height = width * imageView.bounds.height / imageView.bounds.width
            
            snapshot.frame = CGRect(x: 0, y: 0, width: width, height: height)
        } completion: { _ in
            toViewController.view.alpha = 1.0
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
