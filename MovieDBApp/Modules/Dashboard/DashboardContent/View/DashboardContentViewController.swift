//
//  DashboardContentViewController.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import UIKit
import Combine

final class DashboardContentViewController: MVVMViewController<DashboardContentViewModel> {
    private var carousel: CarouselViewController!
    private var activityIndicator: UIActivityIndicatorView!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func bindUI() {
        setupCarousel()
        setupActivityIndicatorView()
        
        viewModel.statePublisher
            .sink { [weak self] state in
                guard let self else { return }
                
                switch state {
                case .loading:
                    showActivityIndicator()
                case .loaded(let movies):
                    carousel.configure(with: movies)
                    hideActivityIndicator()
                case .error(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.load()
    }
}

private extension DashboardContentViewController {
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        carousel.view.isHidden = true
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        carousel.view.isHidden = false
    }
    
    func setupCarousel() {
        carousel = CarouselViewController()
        
        add(childController: carousel, on: view)
        carousel.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carousel.view.topAnchor.constraint(equalTo: view.topAnchor),
            carousel.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carousel.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carousel.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupActivityIndicatorView() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
