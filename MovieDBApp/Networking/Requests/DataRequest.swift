//
//  DataRequest.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import Alamofire

protocol DataRequest {
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [String: String] { get }
}

extension DataRequest {
    var headers: [String: String] {
        [:]
    }
    
    var queryItems: [String: String] {
        [:]
    }
    
    func formattedURL(endPointsStorage: EndpointStorage,
                      baseURL: String,
                      endPoint: APIEndpoint,
                      _ parameters: String...) -> String {
        guard let endPoint = endPointsStorage.formattedEndpointURL(endpoint: endPoint,
                                                                   arguments: parameters) else {
            print("There is no url for endpoint \(endPoint.rawValue)")
            return ""
        }
        
        guard let url = URL(string: baseURL) else {
            print("Incorrect URL \(baseURL)")
            return ""
        }
        
        return url.appendingPathComponent(endPoint).absoluteString
    }
}
