//
//  RoutePoint.swift
//  SchoolBus
//
//  Created by Andrey Shabunko on August/2/2017.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class RoutePoint: NSObject {
    var pointCoordinates = Coordinates()
    
    init(latitude: Double, longitude: Double) {
        self.pointCoordinates.latitude = latitude
        self.pointCoordinates.longitude = longitude
    }
    
}

class DeliveryPoint: RoutePoint {
    var name: String = ""
    var adress: String = ""
    var time: String = ""
    
    init(latitude: Double, longitude: Double, name: String, adress: String, time: String) {
        super.init(latitude: latitude, longitude: longitude)
        self.name = name
        self.adress = adress
        self.time = time
    }
    
}

struct Coordinates {
    var latitude: Double = 0
    var longitude: Double = 0
}
