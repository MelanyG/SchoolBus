//
//  RouteRoute.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/18/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import Alamofire

enum RouteRoute: Route {

    case getAllRoutes(path: String, sessionId: String, date: String)
    case getAllRoutesFast(path: String, sessionId: String, date: String)
    case getAllCompsToRoute(path: String, sessionId: String, routeID: String)
    
    var method: HTTPMethod {
        switch self {
        case .getAllRoutes:
            return .get
        case .getAllRoutesFast:
            return .get
        case .getAllCompsToRoute:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getAllRoutes(let path, _, _):
            return "\(path)/DEX_Export_Response_JSON"
        case .getAllRoutesFast(let path, _, _):
            return "\(path)/ResponseDeliveryRoutes_Get"
        case .getAllCompsToRoute(let path, _, _):
            return "\(path)/ResponseDeliveryComps_Get"
        }
    }
    
    var query: String {
        switch self {
        case .getAllRoutes(_, let sessionID, let date):
            var params = "Session_Ident=\(sessionID)"
            params += "&Date_Data=\(date)"
            params += "&CompInfo=1"
            return params
        case .getAllRoutesFast(_, let sessionID, let date):
            var params = "Session_Ident=\(sessionID)"
            params += "&page=1"
            params += "&rows=100000000"
            params += "&sidx=Route_Num"
            params += "&Date_Data=\(date)"
            return params
        case .getAllCompsToRoute(_, let sessionID, let routeID):
            var params = "Session_Ident=\(sessionID)"
            params += "&page=1"
            params += "&rows=100000000"
            params += "&sidx=Ext_Code"
            params += "&ByObserver=1"
            params += "&sord=asc"
            params += "&Route_Id=\(routeID)"
            return params
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .getAllRoutes:
            return ["Content-Type": "application/json"]
        case .getAllRoutesFast:
            return ["Content-Type": "application/json"]
        case .getAllCompsToRoute:
            return ["Content-Type": "application/json"]
        }
    }

}
