//
//  RouteViewModel.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/5/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import UIKit

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
    
    var fullName: String { return "" }
    var childPicture: UIImage? { return UIImage() }
    var currentStatus: String { return "" }
    var modelPin: UIImage? { return UIImage() }
    
    var edgePoints: (title: String, description: String) {
        if index == 0, let count = model?.qtyOfPoints, count > 1, let address = model?.points?[0].address {
            return (title: "Вiдправлення", description: address)
        }
        if index == 1, let count = model?.qtyOfPoints, count > 1, let address = model?.points?[count - 1].address  {
            return (title: "Кiнець маршруту", description: address)
        }
        return (title: "", description: "")
    }
    
    var routeDetails: (image: UIImage?, title: String, description: String) {
        if index == 0 {
            return (image: UIImage(named: "distance"), title: "Вiдстань", description: distance + " км")
        } else if index == 1 {
        return (image: UIImage(named: "tripDuration"), title: "Час поїздки", description: duration + " хв.")
        }
        return (image: UIImage(named: "averageSpeed"), title: "Середня швидкiсть", description: "60" + " км/год")
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
        return Date.getTime(model?.timeArrival ?? Date())
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
    
    var routeDetails: (image: UIImage?, title: String, description: String) {
        return (image: UIImage(), title: "", description: "")
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
            return "\(childPoint.positionInRoute - 1) зупинка о \(Date.getTime(childPoint.timeArrival))"
        }
        return ""
    }
    
    var pointDistanceAndTime: String {
        let doubleStr = String(format: "%.1f", ceil((model?.distance ?? 0)/1000))
        return "\(doubleStr) km / \(model?.travelTime ?? 0) min"
    }
    
    var fullName: String {
        return model?.name ?? ""
    }
    
    var childPicture: UIImage? {
        return UIImage(named: "defaultImage")
    }
    
    var modelPin: UIImage? {
        if index == 0 {
            return UIImage(named: "bluePin")
        }
        return UIImage(named: "greenPin")
    }
    
    var currentStatus: String {
        if model?.isVisited != nil {
            return SBConstants.PointStatus.IsOnTheWay
        } else {
            return SBConstants.PointStatus.IsWaiting
        }
    }
    var edgePoints: (title: String, description: String) {
        if index == 0 {
            return (title: model?.address ?? "", description: "Вiдправлення")
        }
        return (title: model?.address ?? "", description: "Кiнець маршруту")
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
    var fullName: String { get }
    var childPicture: UIImage? { get }
    var modelPin: UIImage? { get }
    var currentStatus: String { get }
    var edgePoints: (title: String, description: String) { get }
    var routeDetails: (image: UIImage?, title: String, description: String) { get }
}

