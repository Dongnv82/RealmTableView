//
//  DataController.swift
//  RealmTableView
//
//  Created by Minh Thang on 7/8/19.
//  Copyright © 2019 Minh Thang. All rights reserved.
//

import Foundation
import RealmSwift

class DataController{
    private let api: ChatterAPI
    
    init(api: ChatterAPI) {
        self.api = api
    }
    
    private var timer: Timer?
    
    // MARK: - fetch new messages
    
    func startFetchingMessages() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetch), userInfo: nil, repeats: true)
        timer!.fire()
    }
    
    func stopFetchingMessages() {
        timer?.invalidate()
    }
    
    @objc fileprivate func fetch() {
        api.getMessages { jsonObjects in
            let newMessages = jsonObjects.map { object in
                return Message(value: object)
            }
            
            let realm = try! Realm()
            let me = User.defaultUser(in: realm)
            
            try! realm.write {
                for message in newMessages {
                    me.messages.insert(message, at: 0)
                }
            }
        }
    }
    
    // MARK: - post new message
    
    func postMessage(_ message: String) {
        let realm = try! Realm()
        let user = User.defaultUser(in: realm)
        
        let new = Message(user: user, message: message)
        try! realm.write {
            user.outgoing.append(new)
        }
        
        let newId = new.id
        api.postMessage(new, completion: {[weak self] _ in
            self?.didSentMessage(id: newId)
        })
    }
    
    private func didSentMessage(id: String) {
        let realm = try! Realm()
        let user = User.defaultUser(in: realm)
        
        if let sentMessage = realm.object(ofType: Message.self, forPrimaryKey: id),
            let index = user.outgoing.index(of: sentMessage) {
            
            try! realm.write {
                user.outgoing.remove(at: index)
                user.messages.insert(sentMessage, at: 0)
                user.sent += 1
            }
        }
    }
}
