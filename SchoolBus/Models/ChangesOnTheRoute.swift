//
//  ChangesOnTheRoute.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 8/17/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class ChangesOnTheRoute: Object, Mappable {
    
    var isChangeFact: Bool = false
    var isChangeRoue: Bool = false
    var visitedItems: String = ""
    var error: ErrorResponse?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        isChangeFact <- map[SBConstants.ModelConstants.RoutChangedFact]
        isChangeRoue <- map[SBConstants.ModelConstants.RoutChanged]
        visitedItems <- map[SBConstants.ModelConstants.RouteVisitedItems]
        error <- map[SBConstants.ModelConstants.ErrorResponse]

    }
}
