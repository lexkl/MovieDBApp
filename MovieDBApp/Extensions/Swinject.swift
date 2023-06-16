//
//  Swinject.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import Swinject

extension Container {
    static let shared: Container = {
        let container = Container()
        
        registerNetworkUtils(container: container)
        registerServices(container: container)
        
        return container
    }()
}

private extension Container {
    static func registerNetworkUtils(container: Container) {
        container.register(PlistLoader.self) { _ in
            DefaultPlistLoader()
        }
        
        container.register(BaseURLLoader.self) { resolver in
            let plistLoader = resolver.resolve(PlistLoader.self)!
            return DefaultBaseURLLoader(loader: plistLoader)
        }
        
        container.register(PrivateDataLoader.self) { resolver in
            let plistLoader = resolver.resolve(PlistLoader.self)!
            return DefaultPrivateDataLoader(loader: plistLoader)
        }
        
        container.register(APIEndpointsLoader.self) { resolver in
            let plistLoader = resolver.resolve(PlistLoader.self)!
            return DefaultAPIEndpointsLoader(loader: plistLoader)
        }
        
        container.register(URLFormatter.self) { resolver in
            let urlLoader = resolver.resolve(BaseURLLoader.self)!
            return URLFormatter(urlLoader: urlLoader)
        }
        
        container.register(NetworkAgent.self) { _ in
            NetworkAgent()
        }
        
        container.register(EndpointStorage.self) { resolver in
            let endpointsLoader = resolver.resolve(APIEndpointsLoader.self)!
            let endpoints = endpointsLoader.load()
            return DefaultEndpointStorage(endPoints: endpoints)
        }
        
        container.register(RequestNetworkConfiguration.self) { resolver in
            let urlLoader = resolver.resolve(BaseURLLoader.self)!
            let privateDataLoader = resolver.resolve(PrivateDataLoader.self)!
            let storage = resolver.resolve(EndpointStorage.self)!
            let baseURL = urlLoader.load()[.baseURL]!
            let apiKey = privateDataLoader.load()[.apiKey]!
            return DefaultNetworkConfiguration(endPointStorage: storage, baseURL: baseURL, apiKey: apiKey)
        }
    }
    
    static func registerServices(container: Container) {
        container.register(GenresService.self) { resolver in
            let networker = resolver.resolve(NetworkAgent.self)!
            let configuration = resolver.resolve(RequestNetworkConfiguration.self)!
            return GenresServiceImpl(networker: networker, configuration: configuration)
        }
        
        container.register(ImageService.self) { _ in
            return ImageServiceImpl()
        }
        
        container.register(PopularMoviesService.self) { resolver in
            let networker = resolver.resolve(NetworkAgent.self)!
            let configuration = resolver.resolve(RequestNetworkConfiguration.self)!
            return PopularMoviesServiceImpl(networker: networker, configuration: configuration)
        }
        
        container.register(MovieDetailsService.self) { resolver in
            let networker = resolver.resolve(NetworkAgent.self)!
            let configuration = resolver.resolve(RequestNetworkConfiguration.self)!
            return MovieDetailsServiceImpl(networker: networker, configuration: configuration)
        }
    }
}
