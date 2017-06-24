//
//  DateTransform.swift
//  SchoolBus
//
//  Created by Melaniia Hulianovych on 6/24/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

public enum DateFormat: String {
    case Standart = "yyyy-MM-dd'T'HH:mm:ss"
    case Strange = "ddMMyyyyHHmm"
}

public struct DateTransform: TransformType {
    
    let dateTransformer = DateFormatter()
    
    public init(dateFormat: DateFormat) {
        dateTransformer.dateFormat = dateFormat.rawValue
        dateTransformer.timeZone = TimeZone(secondsFromGMT: 0)
        dateTransformer.locale = Locale.current
    }
    
    public func transformFromJSON(_ value: Any?) -> Date? {
        if let dateString = value as? String {
            return dateTransformer.date(from: dateString)
        }
        return nil
    }
    public func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return dateTransformer.string(from: date)
        }
        return nil
    }
    
}
