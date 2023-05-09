//
//  PopularMoviesService.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 09.05.2023.
//

import Foundation
import Combine

protocol PopularMoviesService: DashboardContentService {
}

struct PopularMoviesServiceImpl: PopularMoviesService {
    private let networker: NetworkAgent
    private let configuration: RequestNetworkConfiguration
    
    init(networker: NetworkAgent, configuration: RequestNetworkConfiguration) {
        self.networker = networker
        self.configuration = configuration
    }
    
    func load(page: Int) -> AnyPublisher<GetMoviesResponse, Error> {
        let request = GetPopularMoviesRequest(page: page, configuration: configuration)
        return networker.send(request: request) { error in
            APIError.unknownError(underlyingError: error)
        }.eraseToAnyPublisher()
    }
}

struct PopularMovieServiceMock: PopularMoviesService {
    func load(page: Int) -> AnyPublisher<GetMoviesResponse, Error> {
        Just(GetMoviesResponse.empty())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
