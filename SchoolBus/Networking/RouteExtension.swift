//
//  RouteExtension.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/3/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import Alamofire

enum RouteError: Error {
    case invalidURL
}

protocol RouteComponents {
    var authenticationHeaders: [String: String]?  { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var query: String  { get }
    var header: [String: AnyObject]? { get }
    var parameters: [String: AnyObject]? { get }
}

extension RouteComponents {
    var authenticationHeaders: [String: String]?  { return nil }
    var method: HTTPMethod { return .get }
    var path: String { return "" }
    var query: String  { return "" }
    var header: [String: AnyObject]? { return nil }
    var parameters: [String: AnyObject]? { return nil }
}

protocol Route: URLRequestConvertible, RouteComponents { }

extension Route {
    
    func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.query = query
        
        guard let fullUrl = urlComponents?.url else {
            throw RouteError.invalidURL
        }
        
        var urlRequest = URLRequest(url: fullUrl)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header as! [String : String]?
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        
        return urlRequest
    }
}
