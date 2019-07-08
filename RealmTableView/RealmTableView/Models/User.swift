//
//  User.swift
//  RealmTableView
//
//  Created by Minh Thang on 7/8/19.
//  Copyright © 2019 Minh Thang. All rights reserved.
//

import Foundation
import RealmSwift

func imageUrlForName(_ name: String) -> URL {
    return URL(string: "https://api.adorable.io/avatars/150/" + name.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)! + ".png")!
}

class User: Object {
    // MARK: - Init
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    // MARK: - Properties
    @objc dynamic var name = ""
    @objc dynamic var sent = 0
    
    // MARK: - Collections
    let messages = List<Message>()
    let outgoing = List<Message>()
    
    var avatarUrl: URL {
        return imageUrlForName(self.name)
    }
    
    // MARK: - Meta
    override static func primaryKey() -> String? {
        return "name"
    }
    
    // MARK: - Etc
    private static func createDefaultUser(in realm: Realm) -> User {
        let me = User(name: "me")
        try! realm.write {
            realm.add(me)
        }
        return me
    }
    
    @discardableResult
    static func defaultUser(in realm: Realm) -> User {
        return realm.object(ofType: User.self, forPrimaryKey: "me")
            ?? createDefaultUser(in: realm)
    }
}
