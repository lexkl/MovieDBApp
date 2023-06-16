//
//  UIApplication.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 13.06.2023.
//

import Foundation
import UIKit

extension UIApplication {
    static var keyWindow: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes
                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        return window
    }
}
