//
//  UINavigationController.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 01.06.2023.
//

import Foundation
import UIKit

extension UINavigationController {
    func setTabBarHidden(_ isHidden: Bool) {
        self.tabBarController?.tabBar.isHidden = isHidden
        self.view.setNeedsLayout()
    }
}
