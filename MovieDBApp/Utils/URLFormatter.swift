//
//  URLFormatter.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation

struct URLFormatter {
    private let urlLoader: BaseURLLoader
    
    init(urlLoader: BaseURLLoader) {
        self.urlLoader = urlLoader
    }
    
    func formatURL(urlKey: BaseURL, _ parameters: String...) -> String {
        guard let baseURLString = urlLoader.load()[urlKey],
              let url = URL(string: baseURLString) else { return "" }
        
        let composedURL = parameters.reduce(url) { partialResult, next in
            partialResult.appending(component: next)
        }
        
        return composedURL.absoluteString
    }
}
