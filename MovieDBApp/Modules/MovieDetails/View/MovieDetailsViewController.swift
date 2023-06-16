//
//  MovieDetailsViewController.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 28.05.2023.
//

import Foundation
import UIKit
import Combine

final class MovieDetailsViewController: MVVMViewController<MovieDetailsViewModel> {
    private static let cornerRadius = 20.0
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.isScrollEnabled = true
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var scrollViewTopConstraint
        = scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor)
    
    private lazy var scrollViewBottomConstraint
        = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
    private var cancellables = Set<AnyCancellable>()
    
    override func bindUI() {
        view.backgroundColor = .mainGray
        
        setupImageView()
        setupScrollView()
        
        viewModel.movieDetailsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movieDetails in
                guard let self else { return }
                titleLabel.text = movieDetails.title
                genresLabel.text = movieDetails.genres
                overviewLabel.text = movieDetails.overview
                
                animateDetails()
            }
            .store(in: &cancellables)
        
        viewModel.load()
    }
}

private extension MovieDetailsViewController {
    var aspectRatio: CGFloat {
        let imageSize = viewModel.posterImage.size
        return imageSize.height / imageSize.width
    }
    
    var detailsMargin: CGFloat {
        return UIScreen.main.bounds.height - imageView.bounds.height
    }
    
    func setupImageView() {
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
    
    func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollViewTopConstraint,
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewBottomConstraint
        ])
        
        let verticalStack = UIStackView(arrangedSubviews: [titleLabel, genresLabel, overviewLabel])
        verticalStack.axis = .vertical
        verticalStack.alignment = .leading
        verticalStack.spacing = 15.0

        scrollView.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20.0),
            verticalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0)
        ])
        
        let frame = scrollView.frame
        scrollView.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: frame.height)
    }
    
    func animateDetails() {
        UIViewPropertyAnimator(duration: 1.0, curve: .linear) { [weak self] in
            guard let self else { return }
            let frame = scrollView.frame
            scrollView.frame = CGRect(x: frame.minX, y: 0, width: frame.width, height: frame.height)
        }.startAnimation()
    }
}
