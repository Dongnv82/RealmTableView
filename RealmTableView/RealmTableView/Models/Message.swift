//
//  Message.swift
//  RealmTableView
//
//  Created by Minh Thang on 7/8/19.
//  Copyright © 2019 Minh Thang. All rights reserved.
//

import Foundation
import RealmSwift

class Message: Object {
    
    // MARK: - Init
    convenience init(user: User, message: String) {
        self.init()
        self.name = user.name
        self.message = message
    }
    
    // MARK: - Persisted Properties
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var message = ""
    @objc dynamic var name = ""
    @objc dynamic var isFavorite = false
    @objc dynamic var timestamp = Date().timeIntervalSinceReferenceDate
    
    // MARK: - Dynamic properties
    var photoUrl: URL {
        return imageUrlForName(self.name)
    }
    
    // MARK: - Meta
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["isFavorite"]
    }
    
    // MARK: - Etc
    func toggleFavorite() {
        try? realm?.write {
            isFavorite = !isFavorite
        }
    }
    
}
