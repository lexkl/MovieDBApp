//
//  GetGenresRequest.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import Alamofire

struct APIGenre: Decodable {
    let id: Int?
    let name: String?
}

struct GetGenresResponse: Decodable {
    let genres: [APIGenre]?
}

struct GetGenresRequest: DataRequest {
    var url: String { formattedURL(endPointsStorage: configuration.endPointStorage,
                                   baseURL: configuration.baseURL,
                                   endPoint: .genres) }
    
    let method: HTTPMethod = .get
    
    private let language: String
    private let configuration: RequestNetworkConfiguration
    
    init(language: String = "en-US", configuration: RequestNetworkConfiguration) {
        self.language = language
        self.configuration = configuration
    }
    
    var headers: [String: String] {
        [
            "Authorization": "Bearer \(configuration.apiKey)"
        ]
    }
    
    var queryItems: [String: String] {
        [
            "language": "\(language)"
        ]
    }
}
