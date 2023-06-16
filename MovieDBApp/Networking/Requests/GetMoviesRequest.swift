//
//  GetMoviesRequest.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 09.05.2023.
//

import Foundation
import Alamofire

struct APIMovie: Decodable {
    let poster_path: String?
    let adult: Bool?
    let overview: String?
    let release_date: String?
    let genre_ids: [Int]?
    let id: Int?
    let original_title: String?
    let original_language: String?
    let title: String?
    let backdrop_path: String?
    let popularity: Float?
    let vote_count: Int?
    let video: Bool?
    let vote_average: Float?
}

struct GetMoviesResponse: Decodable {
    let page: Int?
    let results: [APIMovie]?
    let total_results: Int?
    let total_pages: Int?
}

struct GetPopularMoviesRequest: DataRequest {
    var url: String { formattedURL(endPointsStorage: configuration.endPointStorage,
                                   baseURL: configuration.baseURL,
                                   endPoint: .moviePopular) }
    
    let method: HTTPMethod = .get
    
    private let language: String
    private let page: Int
    private let configuration: RequestNetworkConfiguration
    
    init(page: Int, language: String = "en-US", configuration: RequestNetworkConfiguration) {
        self.page = page
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
            "page": String(page),
            "language": language
        ]
    }
}
