//
//  CacheManager.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/4/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class CacheManager {
    
static var currentSession: Session? {
    
    get {
        return DatabaseManager.shared.currentSession()
    }
    set {
        if let session = newValue {
            DatabaseManager.shared.saveCurrentSession(session: session)
        } else {
            DatabaseManager.shared.removeCurrentSession()
        }
    }
}
    
    static var availableServer: Server? {
        
        get {
            return DatabaseManager.shared.currentServer()
        }
        set {
            if let currentServer = newValue {
                DatabaseManager.shared.saveCurrentServer(server: currentServer)
            } else {
                DatabaseManager.shared.removeCurrentServer()
            }
        }
    }
    
    static func cleanAll() {
        currentSession = nil
        availableServer = nil
    }

}
