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
    var visited: Bool = false
    dynamic var positionInRoute: Int = 0
    dynamic var positionTypeID: Int = 0
    dynamic var address: String = ""
    dynamic var name: String = ""
    dynamic var timeArrival: String = ""
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var distance: String = ""
    dynamic var travelTime: String = ""
    dynamic var isObserved: Bool = false
    dynamic var observerName: String = ""
    dynamic var phone: String = ""
    
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
        timeArrival <- map[SBConstants.ModelConstants.PointTimeArrival]
        positionTypeID <- map[SBConstants.ModelConstants.PointPositionID]
        latitude <- map[SBConstants.ModelConstants.PointLatitude]
        longitude <- map[SBConstants.ModelConstants.PointLongitude]
        distance <- map[SBConstants.ModelConstants.PointDistance]
        travelTime <- map[SBConstants.ModelConstants.PointTravelTime]
        isObserved <- map[SBConstants.ModelConstants.PointIsObserved]
        observerName <- map[SBConstants.ModelConstants.PointObserverName]
        phone <- map[SBConstants.ModelConstants.PointObserverPhone]
        visited = isVisited == 0 ? false : true
    }
}
