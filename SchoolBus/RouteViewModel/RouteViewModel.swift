//
//  RouteViewModel.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/5/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class RouteViewModel: DataRepresentative {
    
    var model: RouteModel?
    var index: Int = 0
    
    public init(with model1: RouteModel, and index1: Int) {
        model = model1
        index = index1
    }
    
    var startTime: String {
        if let startTime = model?.beginTime {
            return Date.getTime(startTime)
        }
        return ""
    }
    
    var endTime: String {
        if let endTime = model?.endTime {
            return Date.getTime(endTime)
        }
        return ""
    }
    
    var distance: String {
        if let distance = model?.distance {
            return "\(distance / 1000)"
        }
        return ""
    }
    var duration: String {
        if let duration = model?.travelDuration {
            return "\(duration )"
        }
        return ""
    }
    
    var point: PointModel? {
        if let qty = model?.qtyOfPoints, index < qty {
            return model?.points?[index] ?? nil
        }
        return nil
    }
    var previousPoint: PointModel? {
        if let qty = model?.qtyOfPoints, index - 1 < qty && index >= 0 {
            return model?.points?[index] ?? nil
        }
        return nil
    }
    
    var pointAddress: String {
        if let childPoint = point {
            return childPoint.address
        }
        return ""
    }
    
    var pointPosition: String {
        if let childPoint = point {
            return "Stop \(childPoint.positionInRoute) - \(Date.getTime(childPoint.timeArrival))"
        }
        return ""
    }
    
    var pointDistanceAndTime: String {
        if let previousArrivalTime = previousPoint?.timeArrival {
            let difference = Date.getTimeInterval(between: previousArrivalTime, and: point?.timeArrival ?? Date())
            return "\(point?.distance ?? 0) km / \(difference) min"
        }
        return ""
    }
    
}

protocol DataRepresentative {
    
    var startTime: String { get }
    var endTime: String { get }
    var distance: String { get }
    var duration: String { get }
    var pointAddress: String { get }
    var pointPosition: String { get }
    var pointDistanceAndTime: String { get }

    
}

