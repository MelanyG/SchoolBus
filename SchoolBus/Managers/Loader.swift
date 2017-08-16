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
    static var updateRouteTimer: Timer!
    
    class func loadPoints(for rootNumber: Int, completion handler: @escaping (_ result:List<PointModel>?, _ statusCode: Int) -> Void) {
        NetworkManager.getCompsByRouteFast(route: String(describing: rootNumber),
                                           completion: { (result: DataResult<AllCompsModel>, statusCode: Int) in
                                            switch result {
                                            case .success(let comps):
                                                handler(comps.points, statusCode)
                                            case .failure(let error):
                                                debugPrint(error)
                                                handler(nil, statusCode)
                                            }
        })
    }
    
    class func loadRoutes(for date: Date, completion handler: @escaping (_ result:DayRouts?, _ statusCode: Int) -> Void) {
        NetworkManager.getRoutesByDateFast(date: date.shortDate) {
            (result: DataResult<DayRouts>, statusCode: Int) in
            
            switch result {
            case .success(let value):
                value.date = date
                DatabaseManager.shared.addItem(dayItem: value)
                handler(value, statusCode)
            case .failure(let error):
                debugPrint(error)
                handler(nil, statusCode)
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
    
    class func checkIfThereNeedToLoadNewRoute(completion handler: @escaping (_ loaded: Bool, _ statusCode: Int) -> Void) {
        for i in 0..<DatabaseManager.shared.items.count {
            if DatabaseManager.shared.items[i].date.theDayisTheSame() && i > 0 {
                for j in 1...i {
                    let day = DatabaseManager.shared.items.last?.date.addNoOfDays(noOfDays: j)
                    Loader.loadRoutes(for: day!, completion: { (result: DayRouts?, statusCode: Int) in
                        if result != nil {
                            handler(true, statusCode)
                        }
                    })
                }
            } else {
                break
            }
        }
    }
    
    class func startUpdateRouteTimer() {
        //        updateRouteTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(loadRoutes), userInfo: nil, repeats: true)
        //    updateRouteTimer.fire()
    }
}
