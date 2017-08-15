//
//  Loader.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 8/15/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import RealmSwift

class Loader {
    
    class func loadPoints(for rootNumber: Int, completion handler: @escaping (_ result:List<PointModel>?) -> Void) {
        NetworkManager.getCompsByRouteFast(route: String(describing: rootNumber),
                                           completion: { (result: DataResult<AllCompsModel>, statusCode: Int) in
                                            switch result {
                                            case .success(let comps):
                                                handler(comps.points)
                                            case .failure(let error):
                                                debugPrint(error)
                                            }
        })
    }
    
    class func loadRoutes(for date: Date, completion handler: @escaping (_ result:DayRouts?) -> Void) {
        NetworkManager.getRoutesByDateFast(date: date.shortDate) {
            (result: DataResult<DayRouts>, statusCode: Int) in
            
            switch result {
            case .success(let value):
                value.date = date
                DatabaseManager.shared.addItem(dayItem: value)
                handler(value)
            case .failure(let error):
                switch statusCode {
                case DataStatusCode.Unauthorized.rawValue:
                    debugPrint(error)
                default:
                    debugPrint(error)
                    break
                }
            }
        }
    }
    
    class func getClosestRoute() -> RouteModel? {
        if DatabaseManager.shared.items.count > 0 {
            for day in DatabaseManager.shared.items {
                if day.date.theDayisTheSame() {
                    for route in day.routs! {
                        if Date.isDate(date: Date(), between: route.beginTime, and: route.endTime) {
                            return route
                        } else if Date() < route.beginTime {
                            return route
                        }
                    }
                } else {
                    return nil
                }
            }
        }
        return nil
    }
}
