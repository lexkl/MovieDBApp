//
//  Genres.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 09.05.2023.
//

import Foundation
import RealmSwift

class Genre: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var name: String = ""
    
    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
}
