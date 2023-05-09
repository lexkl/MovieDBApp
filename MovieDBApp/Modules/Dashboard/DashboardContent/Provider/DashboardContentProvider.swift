//
//  DashboardContentProvider.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 09.05.2023.
//

import Foundation
import Combine
import RealmSwift

struct MovieData {
    let title: String
    let imageURL: String
    let genres: String
    let score: String
}

struct MovieDataPresentable {
    let title: String
    let image: UIImage?
    let genres: String
    let score: String
}

protocol DashboardContentProvider {
    var contentService: DashboardContentService { get }
    var imageService: ImageService { get }
    
    func load(page: Int) -> AnyPublisher<[CarouselMoviePresentable], Error>
}

protocol DashboardContentService {
    func load(page: Int) -> AnyPublisher<GetMoviesResponse, Error>
}

struct PopularMoviesProvider: DashboardContentProvider {
    let contentService: DashboardContentService
    let imageService: ImageService
    private let urlFormatter: URLFormatter
    
    init(contentService: DashboardContentService, imageService: ImageService, urlFormatter: URLFormatter) {
        self.contentService = contentService
        self.imageService = imageService
        self.urlFormatter = urlFormatter
    }
    
    func load(page: Int) -> AnyPublisher<[CarouselMoviePresentable], Error> {
        fetchMoviesData(page: page, urlFormatter: urlFormatter)
            .flatMap { movieDataArray in
                Publishers.Sequence(sequence: movieDataArray)
                    .flatMap { movieData -> AnyPublisher<MovieDataPresentable, Error> in
                        return imageService.downloadImage(stringUrl: movieData.imageURL)
                            .map { MovieDataPresentable(title: movieData.title,
                                                        image: $0,
                                                        genres: movieData.genres,
                                                        score: movieData.score) }
                            .eraseToAnyPublisher()
                    }
                    .map { CarouselMoviePresentable(title: $0.title,
                                                    image: $0.image,
                                                    genres: $0.genres,
                                                    score: $0.score) }
                    .collect()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

private extension DashboardContentProvider {
    func fetchMoviesData(page: Int, urlFormatter: URLFormatter) -> AnyPublisher<[MovieData], Error> {
        contentService.load(page: page)
            .tryMap { response -> [MovieData] in
                guard let results = response.results else {
                    throw APIError.parsingError(description: "No results")
                }
                
                return results.compactMap { apiMovie in
                        guard let title = apiMovie.title,
                              let genreIds = apiMovie.genre_ids,
                              let posterPath = apiMovie.poster_path else { return nil }
                        
                        let urlString = urlFormatter.formatURL(urlKey: .imagesURL,
                                                               PosterSizes.w500.rawValue,
                                                               posterPath)
                        let genresString = genreIds.compactMap { getGenreById($0) }.joined(separator: ", ")
                        let scoreString = String(apiMovie.vote_average ?? 0)
                        return MovieData(title: title,
                                         imageURL: urlString,
                                         genres: genresString,
                                         score: scoreString)
                    }
            }
            .eraseToAnyPublisher()
    }
    
    func getGenreById(_ id: Int) -> String {
        guard let realm = try? Realm(),
              let genre = realm.object(ofType: Genre.self, forPrimaryKey: id) else {
            return ""
        }
        
        return genre.name
    }
}
