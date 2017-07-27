//
//  ErrorResponse.swift
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

class ErrorResponse: Object, Mappable {
    
    dynamic var error = 0
    dynamic var errorDescription = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        error <- map[SBConstants.ModelConstants.ErrorResponseError]
        errorDescription <- map[SBConstants.ModelConstants.ErrorResponseMsg]
    }
}
