//
//  DashboardViewFactory.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation
import UIKit
import Swinject

protocol DashboardViewControllerFactory {
    func viewController(for segment: DashboardSegment) -> UIViewController
}

struct DashboardViewControllerFactoryImpl: DashboardViewControllerFactory {
    func viewController(for segment: DashboardSegment) -> UIViewController {
        switch segment {
        case .popular:
            return popular()
        case .new:
            return new()
        }
    }
}

private extension DashboardViewControllerFactoryImpl {
    func popular() -> UIViewController {
        let moviesService = Container.shared.resolve(PopularMoviesService.self)!
        let imageService = Container.shared.resolve(ImageService.self)!
        let urlFormatter = Container.shared.resolve(URLFormatter.self)!
        let provider = PopularMoviesProvider(contentService: moviesService,
                                             imageService: imageService,
                                             urlFormatter: urlFormatter)
        return createViewController(provider: provider)
    }
    
    func new() -> UIViewController {
        let moviesService = Container.shared.resolve(PopularMoviesService.self)!
        let imageService = Container.shared.resolve(ImageService.self)!
        let urlFormatter = Container.shared.resolve(URLFormatter.self)!
        let provider = PopularMoviesProvider(contentService: moviesService,
                                             imageService: imageService,
                                             urlFormatter: urlFormatter)
        return createViewController(provider: provider)
    }
    
    func createViewController(provider: DashboardContentProvider) -> UIViewController {
        let stateMachine = DashboardContentStateMachine()
        let viewModel = DashboardContentViewModelImpl(provider: provider, stateMachine: stateMachine)
        let viewController = DashboardContentViewController(viewModel: viewModel)
        return viewController
    }
}
