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
    dynamic var travelDuration: String = ""
    dynamic var distance: String = ""
    dynamic var avgSpeed: String = ""
    dynamic var qtyOfPoints: Int = 0
    var points: List<PointModel>?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        routeNum <- map[SBConstants.ModelConstants.PointRoutNum]
        extIdent <- map[SBConstants.ModelConstants.ExtIdentifier]
        beginTime <- (map[SBConstants.ModelConstants.RouteTimeBegin], DateTransform(dateFormat: .Strange))
        endTime <- (map[SBConstants.ModelConstants.RouteTimeEnd], DateTransform(dateFormat: .Strange))
        travelDuration <- map[SBConstants.ModelConstants.RoutTravelDuration]
        distance <- map[SBConstants.ModelConstants.PointDistance]
        avgSpeed <- map[SBConstants.ModelConstants.RoutAverageSpeed]
        qtyOfPoints <- map[SBConstants.ModelConstants.CountComps]
        points <- (map[SBConstants.ModelConstants.DayRouteFast], ListTransform<PointModel>())
    }
    
//    func selectMyPoints(pointsArray: [PointModel]) {
//        let myPoints = pointsArray.filter({
//            $0.routeNum == routeNum
//        })
//        points = List(myPoints)
//    }
}
