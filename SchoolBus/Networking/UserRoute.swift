//
//  UserRoute.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/4/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import Alamofire

enum UserRoute: Route {
    
    case serverID(path: String)
    case login(path: String, email: String, pass: String)
    case logout(path: String, email: String, pass: String, sessionID: String)
    
    var method: HTTPMethod {
        switch self {
        case .serverID:
            return .get
        case .login:
            return .post
        case .logout:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .serverID(let path):
            return "\(path)/config"
        case .login(let path, _, _):
            return "\(path)/DEX_UserAuthorization"
        case .logout(let path, _, _, _):
            return "\(path)/DEX_UserAuthorization"
        }
    }
    
    var query: String {
        switch self {
        case .serverID:
            return "req=dev"
        case .login(_, let email, let pass):
            var params = "type=login"
            params += "&email=\(email)"
            params += "&pass=\(pass)"
            return params
        case .logout(_, let email, let pass, let sessionID):
            var params = "type=logout"
            params += "&email=\(email)"
            params += "&pass=\(pass)"
            params += "&Session_Ident=\(sessionID)"
            return params
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .login, .logout:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        default: return ["":""]
        }
    }
    
}


