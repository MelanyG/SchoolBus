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

  dynamic var routeId: Int = 0
  dynamic var routeNum: Int = 0
  dynamic var extIdent: String = ""
  dynamic var beginTime: Date = Date()
  dynamic var endTime: Date = Date()
  dynamic var travelDuration: String = ""
  dynamic var distance: String = ""
  dynamic var avgSpeed: String = ""
  dynamic var qtyOfPoints: Int = 0
  var points: List<PointModel>?
  var lastChangedData: Date = Date()

  required convenience init?(map: Map) {
    self.init()
  }

  func mapping(map: Map) {
    routeId <- map[SBConstants.ModelConstants.PointRoutId]
    routeNum <- map[SBConstants.ModelConstants.PointRoutNum]
    extIdent <- map[SBConstants.ModelConstants.ExtIdentifier]
    beginTime <- (map[SBConstants.ModelConstants.RouteTimeBegin], DateTransform(dateFormat: .Short))
    endTime <- (map[SBConstants.ModelConstants.RouteTimeEnd], DateTransform(dateFormat: .Short))
    travelDuration <- map[SBConstants.ModelConstants.RoutTravelDuration]
    distance <- map[SBConstants.ModelConstants.PointDistance]
    avgSpeed <- map[SBConstants.ModelConstants.RoutAverageSpeed]
    qtyOfPoints <- map[SBConstants.ModelConstants.CountComps]
    //        points <- (map[SBConstants.ModelConstants.DayRouteFast], ListTransform<PointModel>())
  }

  func updateMyPoints(array: [Int]) {
    for point in points! {
      for item in array {
        if point.positionInRoute == item {
          point.visited = true
          break
        }
      }
    }
  }
}
