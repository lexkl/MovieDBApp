//
//  CustomTransition.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 01.06.2023.
//

import Foundation
import UIKit

final class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from)?.children.first as? DashboardContentViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? MovieDetailsViewController,
            let imageView = fromViewController.carousel.currentCell?.shadowImageView.imageView
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let startFrame = imageView.convert(imageView.bounds, to: UIApplication.shared.keyWindow)
        toViewController.view.alpha = 0.0
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        guard let snapshot = imageView.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        
        snapshot.frame = startFrame
        containerView.addSubview(snapshot)
        
        UIView.animate(withDuration: duration) {
            let height = imageView.window?.windowScene?.screen.bounds.height ?? 0
            let width = imageView.window?.windowScene?.screen.bounds.width ?? 0
            
            snapshot.frame = CGRect(x: 0,
                                    y: 0,
                                    width: width,
                                    height: width * imageView.bounds.height / imageView.bounds.width)
        } completion: { _ in
            toViewController.view.alpha = 1.0
            transitionContext.completeTransition(true)
            snapshot.removeFromSuperview()
        }
    }
}
