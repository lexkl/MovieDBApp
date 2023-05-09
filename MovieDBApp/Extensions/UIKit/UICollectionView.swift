//
//  UICollectionView.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import UIKit

protocol UIIdentifiable {
    static var identifier: String { get }
}

extension UIIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: UIIdentifiable {
}
