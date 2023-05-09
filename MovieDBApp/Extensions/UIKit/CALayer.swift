//
//  CALayer.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import QuartzCore
import UIKit

extension CALayer {
    func setDefaultShadow() {
        let shadowRadius: CGFloat = 5
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: shadowRadius * 2,
                                    y: self.bounds.height - shadowRadius * 2))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width - shadowRadius * 2,
                                       y: self.bounds.height - 5))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width - shadowRadius * 2,
                                       y: self.bounds.height + shadowRadius * 2))
        shadowPath.addLine(to: CGPoint(x: shadowRadius * 2,
                                       y: self.bounds.height + shadowRadius * 2))
        self.shadowPath = shadowPath.cgPath
        self.shadowRadius = 5
        self.shadowOffset = .zero
        self.shadowOpacity = 0.3
    }
}
