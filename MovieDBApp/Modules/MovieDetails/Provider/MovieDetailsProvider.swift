//
//  MovieDetailsProvider.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 14.06.2023.
//

import Foundation
import Combine

struct MovieDetailsPresentable {
    let title: String
    let genres: String
    let overview: String
    let score: Float
}

protocol MovieDetailsProvider {
    func load(movieId: Int) -> AnyPublisher<MovieDetailsPresentable, Error>
}

struct MovieDetailsProviderImpl: MovieDetailsProvider {
    private let service: MovieDetailsService
    
    init(service: MovieDetailsService) {
        self.service = service
    }
    
    func load(movieId: Int) -> AnyPublisher<MovieDetailsPresentable, Error> {
        service.load(movieId: movieId)
            .compactMap { apiMovieDetails -> MovieDetailsPresentable? in
                print(apiMovieDetails)
                guard let title = apiMovieDetails.title,
                      let apiGenres = apiMovieDetails.genres,
                      let overview = apiMovieDetails.overview,
                      let score = apiMovieDetails.vote_average else {
                    return nil
                }
                
                let genres = apiGenres.compactMap({ $0.name }).joined(separator: ", ")
                
                return MovieDetailsPresentable(title: title, genres: genres, overview: overview, score: score)
            }
            .eraseToAnyPublisher()
    }
}
