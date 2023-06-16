//
//  MovieDetailsService.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 14.06.2023.
//

import Foundation
import Combine

protocol MovieDetailsService {
    func load(movieId: Int) -> AnyPublisher<APIMovieDetails, Error>
}

struct MovieDetailsServiceImpl: MovieDetailsService {
    private let networker: NetworkAgent
    private let configuration: RequestNetworkConfiguration
    
    init(networker: NetworkAgent, configuration: RequestNetworkConfiguration) {
        self.networker = networker
        self.configuration = configuration
    }
    
    func load(movieId: Int) -> AnyPublisher<APIMovieDetails, Error> {
        let request = GetMovieDetailsRequest(movieId: movieId, configuration: configuration)
        let publisher: AnyPublisher<APIMovieDetails, Error> = networker.send(request: request, mapError: {$0})
        return publisher.eraseToAnyPublisher()
    }
}
