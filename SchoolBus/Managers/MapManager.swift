//
//  MapManager.swift
//  SchoolBus
//
//  Created by Andrey Shabunko on July/18/2017.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import Alamofire

class MapManager {
    
    /// Gets all route geometry (route parts, delivery points)
    static func getRouteData(callback: @escaping ([String:Any], [String: Any]) -> ()) {
        
        /// Improve -> add methods getSessionId() and getRouteId
        let requestURL = "https://main.ant-logistics.com/AntLogistics/AntService.svc/ResponseDeliveryRoutes_GetRoute?Session_Ident=2D4AAA0D-3B19-4773-9F4D-879ECEE163D9&Route_Id=1"
        
        Alamofire.request(requestURL, method: .get).responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                var routePartsGeometry = [String: Any]()
                var deliveryPoints = [String: Any]()
                
                /// JSON data parsing
                if let jsonData = responseData.result.value as? [String: Any] {
                    
                    /// route parts geometry
                    let linesData = jsonData["lines"] as? [String: Any]
                    let featuresData = linesData!["features"] as? [[String: Any]]
                    
                    var number = 0
                    for line in featuresData! {
                        let lineGeometry = line["geometry"] as? [String: Any]
                        let lineCoordinates = lineGeometry!["coordinates"] as? [Any]
                        routePartsGeometry["line \(number)"] = lineCoordinates
                        number += 1
                    }
                    
                    /// delivery points
                    let pointsData = jsonData["points"] as? [String: Any]
                    let featuresData2 = pointsData!["features"] as? [[String: Any]]
                    
                    var number2 = 0
                    for feature in featuresData2! {
                        let featureProperties = feature["properties"] as? [[String]]
                        deliveryPoints["deliveryPoint \(number2)"] = featureProperties
                        number2 += 1
                    }

                    callback(routePartsGeometry, deliveryPoints)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
