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
    
    public init(with model1: RouteModel?, and index1: Int) {
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
        if let qty = model?.qtyOfPoints, index > 3 && qty > 0 {
            return model?.points?[index - 4] ?? nil
        }
        return nil
    }
    var previousPoint: PointModel? {
        if let qty = model?.qtyOfPoints, index - 1 >= 0 && qty > 0{
            return model?.points?[index - 4] ?? nil
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
        return ""
    }
    
    var pointDistanceAndTime: String {
        return ""
    }
}

class PointViewModel: DataRepresentative {
    
    var model: PointModel?
    var index: Int = 0
    
    public init(with model1: PointModel?, and index1: Int) {
        model = model1
        index = index1
    }
    
    var startTime: String {
        return ""
    }
    var endTime: String {
        return ""
    }
    var distance: String {
        return ""
    }
    
    var duration: String {
        return ""
    }
    
    var pointAddress: String {
        let fullAddress = model?.address.components(separatedBy: [","])
        if let address = fullAddress, address.count > 0 {
            return address[0] + address[1]
        }
        return ""
    }
    
    var pointPosition: String {
        if let childPoint = model {
            return "\(childPoint.positionInRoute - 1) stop at \(childPoint.positionInRoute - 1) - \(Date.getTime(childPoint.timeArrival))"
        }
        return ""
    }
    
    var pointDistanceAndTime: String {
        let doubleStr = String(format: "%.1f", ceil((model?.distance ?? 0)/1000))
        return "\(doubleStr) km / \(model?.travelTime ?? 0) min"
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

