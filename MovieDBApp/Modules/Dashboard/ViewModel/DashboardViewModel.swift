//
//  DashboardViewModel.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation
import UIKit
import Combine

protocol DashboardViewModel {
    var segments: [DashboardSegment] { get }
    var segmentChangedPublisher: AnyPublisher<UIViewController?, Never> { get }
    
    func changeSegment(_ segment: Int)
}

final class DashboardViewModelImpl: DashboardViewModel {
    let segments: [DashboardSegment]
    let segmentChangedPublisher: AnyPublisher<UIViewController?, Never>
    
    private weak var navigation: DashboardNavigation?
    
    init(segments: [DashboardSegment],
         segmentChanged: AnyPublisher<UIViewController?, Never>,
         navigation: DashboardNavigation) {
        self.segments = segments
        self.segmentChangedPublisher = segmentChanged
        self.navigation = navigation
    }
    
    func changeSegment(_ segment: Int) {
        navigation?.segmentChanged(with: segment)
    }
}
