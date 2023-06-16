//
//  MovieDetailsViewModel.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 28.05.2023.
//

import Foundation
import UIKit
import Combine

protocol MovieDetailsViewModel {
    var posterImage: UIImage { get }
    var movieDetailsPublisher: AnyPublisher<MovieDetailsPresentable, Never> { get }
    
    func load()
}

final class MovieDetailsViewModelImpl: MovieDetailsViewModel {
    
    let posterImage: UIImage
    
    private let provider: MovieDetailsProvider
    private let movieId: Int
    
    private let movieDetailsSubject = PassthroughSubject<MovieDetailsPresentable, Never>()
    var movieDetailsPublisher: AnyPublisher<MovieDetailsPresentable, Never> {
        movieDetailsSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(posterImage: UIImage, movieId: Int, provider: MovieDetailsProvider) {
        self.posterImage = posterImage
        self.provider = provider
        self.movieId = movieId
    }
    
    func load() {
        provider.load(movieId: movieId)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] movieDetails in
                self?.movieDetailsSubject.send(movieDetails)
            }
            .store(in: &cancellables)
    }
}
