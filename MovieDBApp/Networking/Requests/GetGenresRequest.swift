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

struct GetGenresResponse: Decodable, EmptyValue {
    let genres: [APIGenre]?
    
    static func empty() -> GetGenresResponse {
        GetGenresResponse(genres: nil)
    }
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
    
    var queryItems: [String: String] {
        [
            "api_key": configuration.apiKey,
            "language": "\(language)"
        ]
    }
}
