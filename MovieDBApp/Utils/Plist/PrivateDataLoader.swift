//
//  PrivateDataLoader.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation

enum Private: String {
    case apiKey
}

protocol PrivateDataLoader {
    func load() -> [Private: String]
}

struct DefaultPrivateDataLoader: PrivateDataLoader {
    let loader: PlistLoader
    
    private let privateDataSourceName = "Private"
    
    func load() -> [Private: String] {
        guard let loadedPlist = try? self.loader.stringDictionaryPlist(name: privateDataSourceName) else {
            return [:]
        }
        
        return map(plist: loadedPlist)
    }
    
    private func map(plist: [String: String]) -> [Private: String] {
        var mappedPlist = [Private: String]()
        
        plist.forEach { (key: String, value: String) in
            guard let keyAsBaseURL = Private(rawValue: key) else {
                return
            }
            
            mappedPlist[keyAsBaseURL] = value
        }
        
        return mappedPlist
    }
}
