//
//  EndpointsLoader.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation

protocol APIEndpointsLoader {
    func load() -> [APIEndpoint: String]
}

struct DefaultAPIEndpointsLoader: APIEndpointsLoader {
    let loader: PlistLoader
    
    private let endPointsSourceName = "APIEndpoints"
    
    func load() -> [APIEndpoint: String] {
        guard let loadedPlist = try? self.loader.stringDictionaryPlist(name: endPointsSourceName) else {
            return [:]
        }
        
        return map(plist: loadedPlist)
    }
    
    private func map(plist: [String: String]) -> [APIEndpoint: String] {
        var mappedPlist = [APIEndpoint: String]()
        
        plist.forEach { (key: String, value: String) in
            guard let keyAsBaseURL = APIEndpoint(rawValue: key) else {
                return
            }
            
            mappedPlist[keyAsBaseURL] = value
        }
        
        return mappedPlist
    }
}
