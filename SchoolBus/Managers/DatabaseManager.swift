//
//  DatabaseManager.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/4/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit
import RealmSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    var items: [DayRouts] = []
    
    var realm: Realm {
         return try! Realm()
    }
    
    func saveCurrentSession(session: Session) {
        try! realm.write {
            realm.add(session)
        }
    }
    
    func removeCurrentSession() {
        if let session = currentSession() {
            try! realm.write {
                realm.delete(session)
            }
        }
    }
    
    func currentSession() -> Session? {
        return realm.objects(Session.self).first
    }
    
    func saveCurrentServer(server: Server) {
        try! realm.write {
            realm.add(server)
        }
    }
    
    func removeCurrentServer() {
        if let server = currentServer() {
            try! realm.write {
                realm.delete(server)
            }
        }
    }
    
    func currentServer() -> Server? {
        return realm.objects(Server.self).first
    }
    
    func addItem(dayItem: DayRouts) {
        items.append(dayItem)
    }

}

