//
//  GetMoviesRequest.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 09.05.2023.
//

import Foundation
import Alamofire

struct APIMovie: Decodable, EmptyValue {
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
    
    static func empty() -> APIMovie {
        APIMovie(poster_path: "", adult: false, overview: "", release_date: "",
                 genre_ids: [], id: 0, original_title: "", original_language: "",
                 title: "", backdrop_path: "", popularity: 0.0, vote_count: 0,
                 video: false, vote_average: 0.0)
    }
}

struct GetMoviesResponse: Decodable, EmptyValue {
    let page: Int?
    let results: [APIMovie]?
    let total_results: Int?
    let total_pages: Int?
    
    static func empty() -> GetMoviesResponse {
        GetMoviesResponse(page: 0, results: [], total_results: 0, total_pages: 0)
    }
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
    
    var queryItems: [String: String] {
        [
            "api_key": configuration.apiKey,
            "page": "\(page)",
            "language": "\(language)"
        ]
    }
}
