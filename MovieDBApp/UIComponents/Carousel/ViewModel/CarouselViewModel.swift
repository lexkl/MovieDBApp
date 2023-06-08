//
//  CarouselViewModel.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 01.06.2023.
//

import Foundation
import UIKit

protocol CarouselViewModel {
    func selectMovie(image: UIImage)
}

struct CarouselViewModelImpl: CarouselViewModel {
    private let onMovieSelected: (UIImage) -> Void
    
    init(onMovieSelected: @escaping (UIImage) -> Void) {
        self.onMovieSelected = onMovieSelected
    }
    
    func selectMovie(image: UIImage) {
        onMovieSelected(image)
    }
}
