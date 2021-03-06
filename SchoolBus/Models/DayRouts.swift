//
//  DayRouts.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/19/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class DayRouts: Object, Mappable {
    
    var routs: List<RouteModel>?
    var date: Date = Date()
    var records: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        routs <- (map[SBConstants.ModelConstants.DayRouteFast], ListTransform<RouteModel>())
        records <- (map[SBConstants.ModelConstants.DayRoutsCount])
    }
}
