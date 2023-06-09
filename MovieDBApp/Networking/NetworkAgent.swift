//
//  NetworkAgent.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import Alamofire
import Combine

struct NetworkAgent {
    func send<T: Decodable, ErrorType: Error>(request: DataRequest,
                                              mapError: @escaping(Error) -> ErrorType) -> AnyPublisher<T, ErrorType> {
        AF.request(request.url,
                   method: request.method,
                   parameters: request.queryItems,
                   headers: HTTPHeaders(request.headers))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishData()
            .tryMap { dataResponse -> Data in
                guard let data = dataResponse.data, !data.isEmpty else {
                    throw APIError.invalidData
                }
                
                return data
            }
            .tryMap { data -> T in
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    print(String(describing: error))
                    if let errorString = String(data: data, encoding: .utf8) {
                        throw APIError.parsingError(description: errorString)
                    }
                    
                    throw APIError.unknownError(underlyingError: error)
                }
                
            }
            .mapError(mapError)
            .eraseToAnyPublisher()
    }
}
