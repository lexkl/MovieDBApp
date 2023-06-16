//
//  Errors.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation

enum APIError: Error {
    case unknownError(underlyingError: Error)
    case invalidData
    case parsingError(description: String)
    case emptyData
}
