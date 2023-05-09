//
//  Realm.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 09.05.2023.
//

import Foundation
import RealmSwift

extension Realm {
    static func tryWrite(writeClosure: (Realm) -> Void) throws {
        do {
            let realm = try Realm()
            try realm.write {
                writeClosure(realm)
            }
        } catch {
            throw RealmError.unableToWrite(description: error.localizedDescription)
        }
    }
}
