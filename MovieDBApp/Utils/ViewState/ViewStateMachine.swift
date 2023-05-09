//
//  ViewStateMachine.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 09.05.2023.
//

import Foundation

protocol ViewStateMachine {
    associatedtype StateType
    associatedtype EventType
    
    func reduce(state: StateType, event: EventType) -> StateType
}
