//
//  NerworkManager.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/3/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

enum Hosts: String {
    case Development = "https://ant-logistics.com"
    case ActiveServer = "https://main.ant-logistics.com/AntLogistics/AntService.svc"
}

enum DataStatusCode: Int {
    case OK = 0
    case Error = 1
    case ERR_SESSION_CLOSE = 2
    case ERR_KNOWN = 3
    case INFO = 4
    case WARNING = 5
    case VIOLATION_TARIFF = 6
    case Unauthorized = 401
    case NotFound = 404
}

typealias DataResult<T> = Alamofire.Result<T>

class NetworkManager {
    
    static func serverUrl() ->String{
        
        return Hosts.Development.rawValue
    }
    
    static func getActiveServerUrl() throws -> URL  {
        return try Hosts.Development.rawValue.asURL()
    }
    
    static let reachability = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    static func isConnectedToInternet() ->Bool {
        return reachability!.isReachable
    }
    
    static func loginUser<T: Mappable>(_ email: String, password: String, completion: @escaping (DataResult<T>, _ statusCode: Int) -> ()) {
        getActiveServerUrl{ (result: DataResult<String>, statusCode: Int) in

            switch result {
            case .success(let value):
                debugPrint(value)
                let server = Server()
                server.serverURL = value
                CacheManager.availableServer = server
                Alamofire.request(UserRoute.login(path: value, email: email, pass: password))
                    .validate()
                    .responseObject() { (response: DataResponse<T>) in
                        completion(response.result, response.response?.statusCode ?? DataStatusCode.OK.rawValue)
                }
            case .failure(let error):
                switch statusCode {
                case DataStatusCode.Unauthorized.rawValue: break
                //                    self.applicationController()?.resetState()
                default:
                    debugPrint(error)
                }
            }
            
        }
    }
    
    static func getActiveServerUrl(completion: @escaping (DataResult<String>, _ statusCode: Int) -> ()) {
        Alamofire.request(UserRoute.serverID(path: NetworkManager.serverUrl()))
            .validate()
            .responseString { response in
                completion(response.result, response.response?.statusCode ?? DataStatusCode.OK.rawValue)
        }
        
    }
    
    static func logoutUser<T: Mappable>(_ email: String, password: String, completion: @escaping (DataResult<T>, _ statusCode: Int) -> ()) {
        if let path = CacheManager.availableServer, let session = CacheManager.currentSession {
            Alamofire.request(UserRoute.logout(path: path.serverURL, email: email, pass: password, sessionID: session.sessionId))
                .responseObject() { (response: DataResponse<T>) in
                    completion(response.result, response.response?.statusCode ?? DataStatusCode.OK.rawValue)
            }
        }
    }
    
    static func getRoutesByDate<T: Mappable>(date: String, completion: @escaping (DataResult<T>, _ statusCode: Int) -> ()) {
        if let path = CacheManager.availableServer, let session = CacheManager.currentSession {
            Alamofire.request(RouteRoute.getAllRoutes(path: path.serverURL, sessionId: session.sessionId, date: date))
                .responseObject() { (response: DataResponse<T>) in
                    completion(response.result, response.response?.statusCode ?? DataStatusCode.OK.rawValue)
            }
        }
    }

    static func getRoutesByDateFast<T: Mappable>(date: String, completion: @escaping (DataResult<T>, _ statusCode: Int) -> ()) {
        if let path = CacheManager.availableServer, let session = CacheManager.currentSession {
            Alamofire.request(RouteRoute.getAllRoutesFast(path: path.serverURL, sessionId: session.sessionId, date: date))
                .responseObject() { (response: DataResponse<T>) in
                    completion(response.result, response.response?.statusCode ?? DataStatusCode.OK.rawValue)
            }
        }
    }
    
    static func getCompsByRouteFast<T: Mappable>(route routeNum: String, completion: @escaping (DataResult<T>, _ statusCode: Int) -> ()) {
        if let path = CacheManager.availableServer, let session = CacheManager.currentSession {
            Alamofire.request(RouteRoute.getAllCompsToRoute(path: path.serverURL, sessionId: session.sessionId, routeID: routeNum))
                .responseObject() { (response: DataResponse<T>) in
                    completion(response.result, response.response?.statusCode ?? DataStatusCode.OK.rawValue)
            }
        }
    }
    
    static func getUpdatesForRoute<T: Mappable>(route routeNum: String, last receivedChanges: String, completion: @escaping (DataResult<T>, _ statusCode: Int) -> ()) {
        if let path = CacheManager.availableServer, let session = CacheManager.currentSession {
            Alamofire.request(RouteRoute.getOneUpdatedRoute(path: path.serverURL, sessionId: session.sessionId, routeID: routeNum, lastChanges: receivedChanges))
                .responseObject() { (response: DataResponse<T>) in
                    completion(response.result, response.response?.statusCode ?? DataStatusCode.OK.rawValue)
            }
        }
    }

}
