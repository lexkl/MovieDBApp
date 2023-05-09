//
//  BaseURLLoader.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation

enum BaseURL: String {
    case baseURL
    case imagesURL
}

protocol BaseURLLoader {
    func load() -> [BaseURL: String]
}

struct DefaultBaseURLLoader: BaseURLLoader {
    let loader: PlistLoader
    
    private let baseURLSourceName = "BaseURLs"
    
    func load() -> [BaseURL: String] {
        guard let loadedPlist = try? loader.stringDictionaryPlist(name: baseURLSourceName) else {
            return [:]
        }
        
        return map(plist: loadedPlist)
    }
    
    private func map(plist: [String: String]) -> [BaseURL: String] {
        var mappedPlist = [BaseURL: String]()
        
        plist.forEach { (key: String, value: String) in
            guard let keyAsBaseURL = BaseURL(rawValue: key) else {
                return
            }
            
            mappedPlist[keyAsBaseURL] = value
        }
        
        return mappedPlist
    }
}
