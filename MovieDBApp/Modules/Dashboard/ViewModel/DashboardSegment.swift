//
//  DashboardSegment.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation

enum DashboardSegment: Int, CaseIterable {
    case popular
    case new
    
    var title: String {
        switch self {
        case .popular:
            return "Popular"
        case .new:
            return "New"
        }
    }
}
