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
    let movieId: Int
}

struct MovieDataPresentable {
    let title: String
    let image: UIImage?
    let genres: String
    let score: String
    let movieId: Int
}

protocol DashboardContentProvider {
    var contentService: DashboardContentService { get }
    var imageService: ImageService { get }
    var genresService: GenresService { get }
    
    func load(page: Int) -> AnyPublisher<[CarouselMoviePresentable], Error>
}

protocol DashboardContentService {
    func load(page: Int) -> AnyPublisher<GetMoviesResponse, Error>
}

struct PopularMoviesProvider: DashboardContentProvider {
    let contentService: DashboardContentService
    let imageService: ImageService
    let genresService: GenresService
    private let urlFormatter: URLFormatter
    
    init(contentService: DashboardContentService,
         imageService: ImageService,
         genresService: GenresService,
         urlFormatter: URLFormatter) {
        self.contentService = contentService
        self.imageService = imageService
        self.genresService = genresService
        self.urlFormatter = urlFormatter
    }
    
    func load(page: Int) -> AnyPublisher<[CarouselMoviePresentable], Error> {
        loadGenres()
            .flatMap { _ in
                fetchMoviesData(page: page, urlFormatter: urlFormatter)
                    .flatMap { movieDataArray in
                        Publishers.Sequence(sequence: movieDataArray)
                            .flatMap { movieData -> AnyPublisher<MovieDataPresentable, Error> in
                                return imageService.downloadImage(stringUrl: movieData.imageURL)
                                    .map { MovieDataPresentable(title: movieData.title,
                                                                image: $0,
                                                                genres: movieData.genres,
                                                                score: movieData.score,
                                                                movieId: movieData.movieId) }
                                    .eraseToAnyPublisher()
                            }
                            .map { CarouselMoviePresentable(title: $0.title,
                                                            image: $0.image,
                                                            genres: $0.genres,
                                                            score: $0.score,
                                                            movieId: $0.movieId) }
                            .collect()
                    }
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
                              let posterPath = apiMovie.poster_path,
                              let movieId = apiMovie.id else { return nil }
                        
                        let urlString = urlFormatter.formatURL(urlKey: .imagesURL,
                                                               PosterSizes.w500.rawValue,
                                                               posterPath)
                        let genresString = genreIds.compactMap { getGenreById($0) }.joined(separator: ", ")
                        let scoreString = String(apiMovie.vote_average ?? 0)
                        return MovieData(title: title,
                                         imageURL: urlString,
                                         genres: genresString,
                                         score: scoreString,
                                         movieId: movieId)
                    }
            }
            .eraseToAnyPublisher()
    }
    
    func saveGenres(genres: [APIGenre]) -> Future<Bool, Never> {
        Future { promise in
            do {
                try Realm.tryWrite { realm in
                    for genreAPI in genres {
                        guard let id = genreAPI.id, let name = genreAPI.name else { return }
                        
                        let genre = Genre(id: id, name: name)
                        realm.add(genre, update: .all)
                    }
                }
            } catch {
                print(error)
            }
            
            promise(.success(true))
        }
    }
    
    func loadGenres() -> AnyPublisher<Bool, Error> {
        genresService.load()
            .tryMap { response in
                guard let genres = response.genres else { throw APIError.emptyData }
                return genres
            }
            .flatMap { genres in
                saveGenres(genres: genres)
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
