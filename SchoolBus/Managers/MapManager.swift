//
//  MapManager.swift
//  SchoolBus
//
//  Created by Andrey Shabunko on July/18/2017.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class MapManager {
    
    static var session = CacheManager.currentSession?.sessionId
    
    /// Gets all route geometry (route parts, delivery points)
    static func getRouteData() {
        
        /// Improve -> add methods getSessionId() and getRouteId
        let requestURL = "https://calc.ant-logistics.com/AntLogistics/AntService.svc/ResponseDeliveryRoutes_GetRoute?Session_Ident=" + MapManager.session! + "&Route_Id=1"
        
        Alamofire.request(requestURL, method: .get).responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                /// JSON data parsing
                if let jsonData = responseData.result.value as? [String: Any] {
                    
                    /// Route parts geometry
                    let linesData = jsonData["lines"] as? [String: Any]
                    let featuresData = linesData!["features"] as? [[String: Any]]

                    MapViewController.routePoints += featuresData!.map { $0["geometry"] as! [String: Any] }.map { $0["coordinates"] as! [[Double]] }.flatMap { $0 }.map { RoutePoint(latitude: $0.last!, longitude: $0.first!) }

                    /// Delivery points geometry
                    let pointsData = jsonData["points"] as? [String: Any]
                    let featuresData2 = pointsData!["features"] as? [[String: Any]]
                    
                    MapViewController.deliveryPoints += featuresData2!.map { $0["properties"] as! [[String]] }.map { $0.filter { $0.contains("54") || $0.contains("53") || $0.contains("57") || $0.contains("67") }.flatMap { $0 } }.map {
                        let deliveryName = $0[1]
                        let deliveryAdress = $0[3]
                        let deliveryTime = $0[5]
                        let deliveryCoordinates = $0[7]
                        
                        let deliveryLatitude = deliveryCoordinates.substring(with: deliveryCoordinates.startIndex ..< deliveryCoordinates.index(deliveryCoordinates.startIndex, offsetBy: 10))
                        let deliveryLongitude = deliveryCoordinates.substring(with: deliveryCoordinates.index(deliveryCoordinates.startIndex, offsetBy: 11) ..< deliveryCoordinates.endIndex)
                        
                        return DeliveryPoint(latitude: Double(deliveryLatitude)!,
                                             longitude: Double(deliveryLongitude)!,
                                             name: deliveryName,
                                             adress: deliveryAdress,
                                             time: deliveryTime)
                    }
                }
            
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Create full route points array
    static func createFullRoutePointsArray() {
        
        var fullRoutePoints = [RoutePoint]()
        
        for num in 0 ..< MapViewController.routePoints.count {
            if num + 1 < MapViewController.routePoints.count {
                let startPoint = MapViewController.routePoints[num]
                let finishPoint = MapViewController.routePoints[num + 1]
                
                let startLocation = CLLocation(latitude: startPoint.pointCoordinates.latitude, longitude: startPoint.pointCoordinates.longitude)
                let finishLocation = CLLocation(latitude: finishPoint.pointCoordinates.latitude, longitude: finishPoint.pointCoordinates.longitude)
                
                /// Gets distance between points in meters
                let distanceBetweenPoints = Int(startLocation.distance(from: finishLocation))
                
                /// If ! (distance < 1 meter && start and finish points are equal )
                if distanceBetweenPoints != 0 {
                    let step = 1 // 1 meter step
                    let countOfNewPoints = distanceBetweenPoints / step
                    
                    /// Creates an increment for latitude, longitude
                    let latitudeDifference = finishPoint.pointCoordinates.latitude - startPoint.pointCoordinates.latitude
                    let longitudeDifference = finishPoint.pointCoordinates.longitude - startPoint.pointCoordinates.longitude
                    
                    let latitudeIncrement = latitudeDifference / Double(countOfNewPoints)
                    let longitudeIncrement = longitudeDifference / Double(countOfNewPoints)
                    
                    /// Fill new array with updated coordinates - start point + generated points
                    fullRoutePoints.append(startPoint)
                    
                    for num in 1 ... countOfNewPoints {
                        let newPoint = RoutePoint(latitude: startPoint.pointCoordinates.latitude + latitudeIncrement * Double(num),
                                                  longitude: startPoint.pointCoordinates.longitude + longitudeIncrement * Double(num) )
                        fullRoutePoints.append(newPoint)
                    }
                    
                    if finishPoint.pointCoordinates.latitude != MapViewController.routePoints.last?.pointCoordinates.latitude
                        && finishPoint.pointCoordinates.longitude != MapViewController.routePoints.last?.pointCoordinates.longitude {
                        fullRoutePoints.removeLast()
                    }
                }
            }
        }
        
        MapViewController.fullRoutePoints = fullRoutePoints
    }
    
    /// School bus position
    static func getSchoolBusPosition() {
        
        let requestURL = "https://calc.ant-logistics.com/AntLogistics/AntService.svc/GadgetCurrentState_Get?Session_Ident=" + MapManager.session! + "&Route_Id=1"
        
        Alamofire.request(requestURL, method: .get).responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                if let jsonData = responseData.result.value as? [String: Any] {
                    let points = jsonData.filter { $0.key == "points" }.map { $0.value as! [String: Any] }.flatMap { $0 }
                    let features = points.filter { $0.key == "features" }.map {$0.value as! [[String:Any]]}.flatMap { $0 }.flatMap { $0 }
                    let geometry = features.filter { $0.key == "geometry" }.map { $0.value as! [String: Any] }.flatMap { $0 }
                    let coordinates = geometry.filter { $0.key == "coordinates" }.map {$0.value as! [Double]}.flatMap { $0 }
                    MapViewController.busPosition = RoutePoint(latitude: coordinates.last!, longitude: coordinates.first!)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
