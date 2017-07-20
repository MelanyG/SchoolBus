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
        formatter.locale = Locale(identifier: "uk")
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
        formatter.locale = Locale(identifier: "uk")
        return formatter.date(from: from) ?? Date()
    }
    
    static func getDayOfWeek(_ day: Date) -> String {
        let weekdays = [
            "Нд",
            "Пн",
            "Вт",
            "Сер",
            "Чт",
            "Пт",
            "Суб"
        ]
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: day)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd   LLL    HH   mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "uk")
        let selectedDate = formatter.string(from: day)
        if day == Date() {
            return "Сьогодні"
        }
        return weekdays[weekDay - 1] + "  " + selectedDate
    }
    
    static func getTime(_ day: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "uk")
        return formatter.string(from: day)
    }
    
    static func getTimeInterval(between startTime: Date?, and endTime: Date) -> Int {
        if let starttime = startTime {
            let requestedComponent: Set<Calendar.Component> = [.minute]
            let timeDifference = Calendar.current.dateComponents(requestedComponent, from: starttime, to: endTime)
            return timeDifference.minute ?? 0
        }
        return 0
    }
    
}
