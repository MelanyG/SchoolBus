//
//  PointModel.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/18/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class PointModel: Object, Mappable {
    
    dynamic var routeNum: Int = 0
    dynamic var pointId: Int = 0
    dynamic var externalIdentifier: Int = 0
    dynamic var isVisited: Int = 0
    dynamic var positionInRoute: Int = 0
    dynamic var address: String = ""
    dynamic var name: String = ""
    dynamic var timeArrival: Date = Date()
    dynamic var timeFactArrival: String = ""
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        routeNum <- map["Route_Num"]
        pointId <- map["Comp_Id"]
        externalIdentifier <- map["Ext_Ident"]
        isVisited <- map["Is_Visited"]
        positionInRoute <- map["Pos_Id"]
        address <- map["Address"]
        name <- map["Comp_Name"]
        timeArrival <- (map["Time_Arrival"], DateTransform(dateFormat: .Standart))
        timeFactArrival <- map["Time_Arrival_fact"]
        latitude <- map["lat"]
        longitude <- map["lng"]
    }
}
