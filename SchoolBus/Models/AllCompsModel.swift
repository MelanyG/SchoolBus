//
//  AllCompsModel.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 8/6/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class AllCompsModel: Object, Mappable {
    
    var points: List<PointModel>?
    dynamic var error: ErrorResponse?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        error <-  map[SBConstants.ModelConstants.ErrorResponse]
        points <- (map[SBConstants.ModelConstants.DayRouteFast], ListTransform<PointModel>())
    }
    
    //    func selectMyPoints(pointsArray: [PointModel]) {
    //        let myPoints = pointsArray.filter({
    //            $0.routeNum == routeNum
    //        })
    //        points = List(myPoints)
    //    }
}
