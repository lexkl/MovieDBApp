//
//  RealmError.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 09.05.2023.
//

import Foundation

enum RealmError: Error {
    case unableToWrite(description: String)
}
