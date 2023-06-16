//
//  CarouselViewModel.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 01.06.2023.
//

import Foundation
import UIKit

protocol CarouselViewModel {
    func selectMovie(image: UIImage, movieId: Int)
}

struct CarouselViewModelImpl: CarouselViewModel {
    private let onMovieSelected: (UIImage, Int) -> Void
    
    init(onMovieSelected: @escaping (UIImage, Int) -> Void) {
        self.onMovieSelected = onMovieSelected
    }
    
    func selectMovie(image: UIImage, movieId: Int) {
        onMovieSelected(image, movieId)
    }
}
