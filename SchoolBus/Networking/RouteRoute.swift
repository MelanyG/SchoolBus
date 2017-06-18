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
    
    var method: HTTPMethod {
        switch self {
        case .getAllRoutes:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getAllRoutes(let path, _, _):
            return "\(path)/DEX_Export_Response_JSON"
        }
    }
    
    var query: String {
        switch self {
        case .getAllRoutes(_, let sessionID, let date):
            var params = "Session_Ident=\(sessionID)"
            params += "&Date_Data=\(date)"
            params += "&CompInfo=1"
            return params
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .getAllRoutes:
            return ["Content-Type": "application/json"]
        }
    }

}
