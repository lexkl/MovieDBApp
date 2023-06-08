//
//  MovieDetailsViewModel.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 28.05.2023.
//

import Foundation
import UIKit

protocol MovieDetailsViewModel {
    var posterImage: UIImage { get }
}

final class MovieDetailsViewModelImpl: MovieDetailsViewModel {
    
    let posterImage: UIImage
    
    init(posterImage: UIImage) {
        self.posterImage = posterImage
    }
}
