//
//  ImageService.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 09.05.2023.
//

import Foundation
import Combine
import UIKit
import Alamofire

protocol ImageService {
    func downloadImage(stringUrl: String) -> AnyPublisher<UIImage?, Error>
}

struct ImageServiceImpl: ImageService {
    func downloadImage(stringUrl: String) -> AnyPublisher<UIImage?, Error> {
        guard let url = URL(string: stringUrl) else {
            return Fail(error: APIError.parsingError(description: "Invalid url: \(stringUrl)"))
                .eraseToAnyPublisher()
        }
        
        return AF.download(url)
            .publishData()
            .compactMap { $0.value }
            .map { UIImage(data: $0) }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
