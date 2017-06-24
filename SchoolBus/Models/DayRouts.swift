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
    var points: List<PointModel>?
    var date: Date = Date()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        routs <- (map["Route"], ListTransform<RouteModel>())
        points <- (map["Comps"], ListTransform<PointModel>())
    }
    
    func connectRoutsWithPoints() {
        if let routs = routs, let points = points {
            for rout in routs {
                rout.selectMyPoints(pointsArray: Array(points))
            }
        }
    }
}
