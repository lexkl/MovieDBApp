//
//  DashboardContentViewModel.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import Combine

protocol DashboardContentViewModel {
    var statePublisher: AnyPublisher<DashboardContentViewState, Never> { get }
    
    func load()
}

final class DashboardContentViewModelImpl: DashboardContentViewModel {
    private let provider: DashboardContentProvider
    private let stateMachine: DashboardContentStateMachine
    
    private let stateSubject = CurrentValueSubject<DashboardContentViewState, Never>(.loading)
    var statePublisher: AnyPublisher<DashboardContentViewState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(provider: DashboardContentProvider, stateMachine: DashboardContentStateMachine) {
        self.provider = provider
        self.stateMachine = stateMachine
    }
    
    func load() {
        provider.load(page: 1)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] movies in
                guard let self else { return }
                let newState = stateMachine.reduce(state: stateSubject.value,
                                                   event: .onLoad(movies: movies))
                stateSubject.send(newState)
            }
            .store(in: &cancellables)

    }
}
