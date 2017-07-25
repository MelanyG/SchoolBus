//
//  MapViewController.swift
//  SchoolBus
//
//  Created by Andrey Shabunko on July/18/2017.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    /// Elements from server
    static var routePoints = [CLLocationCoordinate2D]()
    static var fullRoutePoints = [CLLocationCoordinate2D]()
    static var routeParts = [String: Any]()
    static var deliveryPoints = [[[String]]]()
    
    /// Bus
    static var busAnnotation = CustomPointAnnotation()
    static var busStepCounter = 0
    
    /// Route
    static var polylineCounter = 0
    static var markerCounter = 0
    static var timer = Timer()
    static var markerTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Show Lviv center
        let span = MKCoordinateSpanMake(0.02,0.02)
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(49.8380101, 24.0242067), span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.setCenter(CLLocationCoordinate2DMake(49.839508, 24.029021), animated: true)
        
        /// Takes route geometry from server (route parts, delivery points)
        MapManager.getRouteData { (routeParts, deliveryPoints) in
            if !routeParts.isEmpty && !deliveryPoints.isEmpty {
                
                /// Creates routes (route points geometry -> route parts -> full route)
                self.mapView.delegate = self
                
                /// Orderes route points from server
                var orderedPoints = [(latitude: Double, longtitude: Double)]()
                for number in 0 ..< routeParts.keys.count {
                    let linePointsArray = routeParts["line \(number)"] as! [[Double]]
                    for pointCoords in linePointsArray {
                        orderedPoints.append((pointCoords[1], pointCoords[0]))
                    }
                }
                
                /// Creates locations from points coordinates
                var orderedLocations = [CLLocationCoordinate2D]()
                for orderedPoint in orderedPoints {
                    orderedLocations.append(CLLocationCoordinate2D(latitude: orderedPoint.latitude,
                                                                   longitude: orderedPoint.longtitude))
                }
                
                /// Creates placemarks from locations
                var orderedPlacemarks = [MKPlacemark]()
                for orderedLocation in orderedLocations {
                    orderedPlacemarks.append(MKPlacemark(coordinate: orderedLocation,
                                                         addressDictionary: nil))
                }
                
                /// Creates map items from placemarks
                var orderedMapItems = [MKMapItem]()
                for orderedPlacemark in orderedPlacemarks {
                    orderedMapItems.append(MKMapItem(placemark: orderedPlacemark))
                }
                
                /// Orderes delivery points from server
                var orderedDeliveryPoints = [[[String]]]()
                for number in 0 ..< deliveryPoints.keys.count {
                    let orderedDeliveryPoint = deliveryPoints["deliveryPoint \(number)"] as! [[String]]
                    orderedDeliveryPoints.append(orderedDeliveryPoint)
                }
                
                /// Creates array with updated coords (route points + genereated points)
                var updatedRoutePoints = [CLLocationCoordinate2D]()
                
                for num in 0..<orderedLocations.count {
                    if num + 1 < orderedLocations.count {
                        let startPoint = orderedLocations[num]
                        let finishPoint = orderedLocations[num + 1]
                        
                        let startLocation = CLLocation(latitude: startPoint.latitude, longitude: startPoint.longitude)
                        let finishLocation = CLLocation(latitude: finishPoint.latitude, longitude: finishPoint.longitude)
                        
                        /// Gets distance between points in meters
                        let distanceBetweenPoints = Int(startLocation.distance(from: finishLocation))
                        
                        /// If ! (distance < 1 meter && start and finish points are equal )
                        if distanceBetweenPoints != 0 {
                            let step = 1 // 1 meter step
                            let countOfNewPoints = distanceBetweenPoints / step
                            
                            /// Creates an increment for latitude, longitude
                            let latitudeDifference = finishPoint.latitude - startPoint.latitude
                            let longitudeDifference = finishPoint.longitude - startPoint.longitude
                            
                            let latitudeIncrement = latitudeDifference / Double(countOfNewPoints)
                            let longitudeIncrement = longitudeDifference / Double(countOfNewPoints)
                            
                            /// Fill new array with updated coordinates - start point + generated points
                            updatedRoutePoints.append(startPoint)
                            
                            for num in 1...countOfNewPoints {
                                var newPoint = CLLocationCoordinate2D()
                                newPoint.latitude = startPoint.latitude + latitudeIncrement * Double(num)
                                newPoint.longitude = startPoint.longitude + longitudeIncrement * Double(num)
                                updatedRoutePoints.append(newPoint)
                            }
                            
                            if finishPoint.latitude != orderedLocations.last?.latitude &&
                                finishPoint.longitude != orderedLocations.last?.longitude {
                                updatedRoutePoints.removeLast()
                            }
                        }
                    }
                }
                
                MapViewController.routePoints = orderedLocations
                MapViewController.fullRoutePoints = updatedRoutePoints
                MapViewController.routeParts = routeParts
                MapViewController.deliveryPoints = orderedDeliveryPoints
            }
        }
    }
    
    /// Route drawing action
    @IBAction func drawRoute(_ sender: UIButton) {
        MapViewController.timer = Timer.scheduledTimer(timeInterval: TimeInterval(3.0), target: self, selector: #selector(drawRoutePolyline), userInfo: nil, repeats: true)
    }
    
    func drawRoutePolyline() {
        /// Route parts -> each line
        let routePartsGeometry = MapViewController.routeParts
        var clearRouteParts = [[[Double]]]()
        
        for num in 0..<routePartsGeometry.keys.count {
            let clearRoutePart = routePartsGeometry["line \(num)"] as! [[Double]]
            clearRouteParts.append(clearRoutePart)
        }
        
        /// Each line -> route part polyline
        var routePartPolylinePoints = [CLLocationCoordinate2D]()
        let currentRoutePart = clearRouteParts[MapViewController.polylineCounter]
        
        for pointCoordinates in currentRoutePart {
            routePartPolylinePoints.append(CLLocationCoordinate2DMake(pointCoordinates.last!, pointCoordinates.first!))
        }
        
        let routePartPolyLine = MKPolyline(coordinates: routePartPolylinePoints, count: routePartPolylinePoints.count)
        
        /// Focus on route part and add polyline
        var routePartAnnotations = [MKPointAnnotation]()
        for pointCoords in routePartPolylinePoints {
            let routePartPointAnnotation = MKPointAnnotation()
            routePartPointAnnotation.coordinate = pointCoords
            routePartAnnotations.append(routePartPointAnnotation)
        }
        
        self.mapView.showAnnotations(routePartAnnotations, animated: true)
        self.mapView.removeAnnotations(routePartAnnotations)
        self.mapView.add(routePartPolyLine)
        
        MapViewController.polylineCounter += 1
        
        /// Turn off the timer and set polylinecounter to 0
        if  MapViewController.polylineCounter == clearRouteParts.count {
            MapViewController.timer.invalidate()
            MapViewController.polylineCounter = 0
            
            /// Drop markers
            MapViewController.markerTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2.0), target: self, selector: #selector(self.dropDeliveryMarkers), userInfo: nil, repeats: true)
        }
    }
    
    func dropDeliveryMarkers() {
        /// Focus on all route
        var fullRouteAnnotations = [MKPointAnnotation]()
        for pointCoords in MapViewController.routePoints {
            let annotation = MKPointAnnotation()
            annotation.coordinate = pointCoords
            fullRouteAnnotations.append(annotation)
        }
        
        self.mapView.showAnnotations(fullRouteAnnotations, animated: true)
        self.mapView.removeAnnotations(fullRouteAnnotations)
        
        let dispatchTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            
            /// Get delivery points coordinates, name, adress and time
            let deliveryRoutePoints = MapViewController.deliveryPoints
            let currentDeliveryPoint = deliveryRoutePoints[MapViewController.markerCounter]
            
            let deliveryName = currentDeliveryPoint[6].last!
            let deliveryAdress = currentDeliveryPoint[7].last!
            let deliveryTime = currentDeliveryPoint[10].last!
            
            let deliveryCoordinates = currentDeliveryPoint[11].last!
            let deliveryLatitude = deliveryCoordinates.substring(with: deliveryCoordinates.startIndex ..< deliveryCoordinates.index(deliveryCoordinates.startIndex, offsetBy: 10))
            let deliveryLongitude = deliveryCoordinates.substring(with: deliveryCoordinates.index(deliveryCoordinates.startIndex, offsetBy: 11) ..< deliveryCoordinates.endIndex)
            
            let deliveryPointCoords = CLLocationCoordinate2DMake(Double(deliveryLatitude)!, Double(deliveryLongitude)!)
            
            let annotation = CustomPointAnnotation()
            annotation.coordinate = deliveryPointCoords
            annotation.title = "\(deliveryName)"
            annotation.subtitle = "\(deliveryAdress) \(deliveryTime)"
            
            annotation.imageName = (MapViewController.markerCounter == deliveryRoutePoints.count - 3) ? "school.png" : "home.png"
            
            self.mapView.addAnnotation(annotation)
            
            MapViewController.markerCounter += 1
            
            if MapViewController.markerCounter == deliveryRoutePoints.count {
                MapViewController.markerCounter = 0
                MapViewController.markerTimer.invalidate()
            }
        }
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        /// Focus on school bus
        let span = MKCoordinateSpanMake(0.005,0.005)
        let region = MKCoordinateRegionMake(MapViewController.fullRoutePoints.first!, span)
        self.mapView.setRegion(region, animated: true)
        
        let dispatchTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            /// Creates bus annotation
            MapViewController.busAnnotation.imageName = "schoolbus.png"
            MapViewController.busAnnotation.coordinate = MapViewController.fullRoutePoints.first!
            self.mapView.addAnnotation(MapViewController.busAnnotation)
            
            let dispatchTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                Timer.scheduledTimer(timeInterval: TimeInterval(0.05), target: self, selector: #selector(self.moveSchoolBus), userInfo: nil, repeats: true)
            }
        }
    }
    
    func moveSchoolBus() -> Void {
        MapViewController.busAnnotation.coordinate.latitude = MapViewController.fullRoutePoints[MapViewController.busStepCounter].latitude
        MapViewController.busAnnotation.coordinate.longitude = MapViewController.fullRoutePoints[MapViewController.busStepCounter].longitude
        MapViewController.busStepCounter += 1
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor(red: 244.0/255.0, green: 137.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        polylineRenderer.lineWidth = 2.0
        
        return polylineRenderer
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
