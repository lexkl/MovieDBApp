//
//  DashboardContentViewState.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 09.05.2023.
//

import Foundation

enum DashboardContentViewState {
    case loading
    case loaded(movies: [CarouselMoviePresentable])
    case error(error: Error)
}

enum DashboardContentEvent {
    case onLoad(movies: [CarouselMoviePresentable])
    case onError(error: Error)
}

struct DashboardContentStateMachine: ViewStateMachine {
    typealias StateType = DashboardContentViewState
    typealias EventType = DashboardContentEvent
    
    func reduce(state: DashboardContentViewState, event: DashboardContentEvent) -> DashboardContentViewState {
        switch state {
        case .loading:
            switch event {
            case .onLoad(let movies):
                return .loaded(movies: movies)
            case .onError(let error):
                return .error(error: error)
            }
        default:
            break
        }
        
        return state
    }
}
