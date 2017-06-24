//
//  DateExtension.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/18/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

extension Date {
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
         let strDate = formatter.string(from: self)
         return strDate
    }
    
    func addNoOfDays(noOfDays:Int) -> Date {
        let cal:NSCalendar = NSCalendar.current as NSCalendar
        cal.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let comps:NSDateComponents = NSDateComponents()
        comps.day = noOfDays
        return cal.date(byAdding: comps as DateComponents, to: self)!
    }
    
    static func convert(date from: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter.date(from: from) ?? Date()
    }
}
