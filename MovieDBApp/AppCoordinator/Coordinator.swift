//
//  Coordinator.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation

protocol Coordinator: CoordinatorStorage {
    var onFinish: () -> Void { get }
    
    func start()
}

protocol CoordinatorStorage: AnyObject {
    var coordinators: [Coordinator] { get set }
    
    func store(coordinator: Coordinator)
    func remove(coordinator: Coordinator)
}

extension CoordinatorStorage {
    func store(coordinator: Coordinator) {
        coordinators.append(coordinator)
    }
    
    func remove(coordinator: Coordinator) {
        coordinators.removeAll(where: { $0 === coordinator })
    }
}
