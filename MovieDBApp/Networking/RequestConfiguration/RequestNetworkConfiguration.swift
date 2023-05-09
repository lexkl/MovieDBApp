//
//  RequestNetworkConfiguration.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation

protocol RequestNetworkConfiguration {
    var endPointStorage: EndpointStorage { get }
    var baseURL: String { get }
    var apiKey: String { get }
}

struct DefaultNetworkConfiguration: RequestNetworkConfiguration {
    let endPointStorage: EndpointStorage
    let baseURL: String
    let apiKey: String
}
