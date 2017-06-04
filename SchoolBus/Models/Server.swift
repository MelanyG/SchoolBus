//
//  Server.swift
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

class Server: Object, Mappable {
    
    dynamic var serverURL: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        serverURL <- map
    }
}
