//
//  RouteModel.swift
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

class RouteModel: Object, Mappable {
    
    dynamic var routeNum: Int = 0
    dynamic var extIdent: String = ""
    dynamic var beginTime: Date = Date()
    dynamic var endTime: Date = Date()
    dynamic var travelDuration: Int = 0
    dynamic var distance: Int = 0
    dynamic var qtyOfPoints: Int = 0
    var points: List<PointModel>?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        routeNum <- map["Route_Num"]
        extIdent <- map["Ext_Ident"]
        beginTime <- (map["RouteTime_B"], DateTransform(dateFormat: .Strange))
        endTime <- (map["RouteTime_E"], DateTransform(dateFormat: .Strange))
        travelDuration <- map["Travel_Duration"]
        distance <- map["distance"]
        qtyOfPoints <- map["Count_Comps"]
    }
    
    func selectMyPoints(pointsArray: [PointModel]) {
        let myPoints = pointsArray.filter({
            $0.routeNum == routeNum
        })
        points = List(myPoints)
    }
}
