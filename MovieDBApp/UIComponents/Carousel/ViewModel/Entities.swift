//
//  Entities.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import UIKit

struct CarouselMoviePresentable: Identifiable {
    let id = UUID()
    
    let title: String
    let image: UIImage?
    let genres: String
    let score: String
}
