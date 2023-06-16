//
//  GetMovieDetails.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 14.06.2023.
//

import Foundation
import Alamofire

struct ApiGenre: Decodable {
    let id: Int?
    let name: String?
}

struct ProductionCompany: Decodable {
    let id: Int?
    let logo_path: String?
    let name: String?
    let origin_country: String?
}

struct ProductionCountry: Decodable {
    let iso_3166_1: String?
    let name: String?
}

struct SpokenLanguage: Decodable {
    let english_name: String?
    let iso_639_1: String?
    let name: String?
}

struct Collection: Decodable {
    let id: Int?
    let name: String?
    let poster_path: String?
    let backdrop_path: String?
}

struct APIMovieDetails: Decodable {
    let adult: Bool?
    let backdrop_path: String?
    let belongs_to_collection: Collection?
    let budget: Int?
    let genres: [ApiGenre]?
    let homePage: String?
    let id: Int?
    let imdb_id: String?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Float?
    let poster_path: String?
    let production_companies: [ProductionCompany]?
    let production_countries: [ProductionCountry]?
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let spoken_languages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let vote_average: Float?
    let vote_count: Float?
}

struct GetMovieDetailsRequest: DataRequest {
    var url: String { formattedURL(endPointsStorage: configuration.endPointStorage,
                                   baseURL: configuration.baseURL,
                                   endPoint: .movieDetails,
                                   String(movieId)) }
    
    let method: HTTPMethod = .get
    
    private let movieId: Int
    private let configuration: RequestNetworkConfiguration
    
    init(movieId: Int, configuration: RequestNetworkConfiguration) {
        self.movieId = movieId
        self.configuration = configuration
    }
    
    var headers: [String: String] {
        [
            "Authorization": "Bearer \(configuration.apiKey)"
        ]
    }
}
