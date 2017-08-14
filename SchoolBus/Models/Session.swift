//
//  Session.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/4/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Session: Object, Mappable {

    dynamic var sessionId = ""
    dynamic var error: ErrorResponse?
    var email: String?
    var password: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sessionId <- map[SBConstants.ModelConstants.SessionID]
        error <-  map[SBConstants.ModelConstants.ErrorResponse]
    }
}
