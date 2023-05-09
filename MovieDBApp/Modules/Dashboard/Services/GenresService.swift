//
//  GenresService.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import Combine

protocol GenresService {
    func load() -> AnyPublisher<GetGenresResponse, Error>
}

struct GenresServiceImpl: GenresService {
    private let networker: NetworkAgent
    private let configuration: RequestNetworkConfiguration
    
    init(networker: NetworkAgent, configuration: RequestNetworkConfiguration) {
        self.networker = networker
        self.configuration = configuration
    }
    
    func load() -> AnyPublisher<GetGenresResponse, Error> {
        let request = GetGenresRequest(configuration: configuration)
        return networker.send(request: request) { error in
            APIError.unknownError(underlyingError: error)
        }.eraseToAnyPublisher()
    }
}

struct GenresServiceMock: GenresService {
    func load() -> AnyPublisher<GetGenresResponse, Error> {
        Just(GetGenresResponse.empty())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
