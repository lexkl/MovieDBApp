//
//  TabBarItem.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation
import UIKit

enum TabBarItem: Int {
    case home
    case search
    case profile
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .profile:
            return "Profile"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")
        case .search:
            return UIImage(systemName: "magnifyingglass")
        case .profile:
            return UIImage(systemName: "person.circle")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill")
        case .search:
            return UIImage(systemName: "magnifyingglass.fill")
        case .profile:
            return UIImage(systemName: "person.circle.fill")
        }
    }
    
    var tabBarItem: UITabBarItem {
        let item = UITabBarItem(title: title,
                                image: image,
                                tag: rawValue)
        
        item.selectedImage = selectedImage
        
        return item
    }
    
    static var tabs: [TabBarItem] {
        [.home, .search, .profile]
    }
}
