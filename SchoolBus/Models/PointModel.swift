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
//    dynamic var timeFactArrival: Date = Date()
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var distance: Double = 0
//    dynamic var timeToArraiveIntoPoint: Double = 0
    dynamic var travelTime: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        routeNum <- map[SBConstants.ModelConstants.PointRoutNum]
        pointId <- map[SBConstants.ModelConstants.PointCompID]
        externalIdentifier <- map[SBConstants.ModelConstants.ExtIdentifier]
        isVisited <- map[SBConstants.ModelConstants.PointIsVisited]
        positionInRoute <- map[SBConstants.ModelConstants.PointPosition]
        address <- map[SBConstants.ModelConstants.PointAddress]
        name <- map[SBConstants.ModelConstants.PointName]
        timeArrival <- (map[SBConstants.ModelConstants.PointTimeArrival], DateTransform(dateFormat: .Standart))
//        timeFactArrival <- (map[SBConstants.ModelConstants.PointTimeArrivalFact], DateTransform(dateFormat: .Standart))
        latitude <- map[SBConstants.ModelConstants.PointLatitude]
        longitude <- map[SBConstants.ModelConstants.PointLongitude]
        distance <- map[SBConstants.ModelConstants.PointDistance]
//        timeToArraiveIntoPoint <- map["distance"]
        travelTime <- map[SBConstants.ModelConstants.PointTravelTime]
    }
}
