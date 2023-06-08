//
//  MovieDetailsViewController.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 28.05.2023.
//

import Foundation
import UIKit

final class MovieDetailsViewController: MVVMViewController<MovieDetailsViewModel> {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override func bindUI() {
        let imageSize = viewModel.posterImage.size
        let aspectRatio = imageSize.height / imageSize.width
        
        imageView.image = viewModel.posterImage
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * aspectRatio)
        ])
    }
}
