//
//  EndpointStorage.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation

enum APIEndpoint: String {
    case moviePopular
    case movieDetails
    case genres
}

protocol EndpointStorage {
    func endpointURL(endpoint: APIEndpoint) -> String?
    func formattedEndpointURL(endpoint: APIEndpoint, _ parameters: String...) -> String?
    func formattedEndpointURL(endpoint: APIEndpoint, arguments: [String]) -> String?
}

struct DefaultEndpointStorage: EndpointStorage {
    let endPoints: [APIEndpoint: String]
    
    func endpointURL(endpoint: APIEndpoint) -> String? {
        return endPoints[endpoint]
    }
    
    func formattedEndpointURL(endpoint: APIEndpoint, _ parameters: String...) -> String? {
        guard let endPoint = endpointURL(endpoint: endpoint) else {
            return nil
        }
        
        return String(format: endPoint, arguments: parameters)
    }
    
    func formattedEndpointURL(endpoint: APIEndpoint, arguments: [String]) -> String? {
        guard let endPoint = endpointURL(endpoint: endpoint) else {
            return nil
        }
        
        return String(format: endPoint, arguments: arguments)
    }
}
