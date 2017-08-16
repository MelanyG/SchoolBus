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

enum BusState { case departure, movement, arrival }

struct StateActions {
    
    private var busState: BusState = .departure
    
    var currentState: BusState { return busState }
    
    mutating func updateBus(state: BusState) {
        self.busState = state
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStatus: UILabel!

    /// Route elements
    static var routePoints = [RoutePoint]()
    static var fullRoutePoints = [RoutePoint]()
    static var deliveryPoints = [DeliveryPoint]()

    /// Bus elements
    static var busPinView = MKAnnotationView()
    static var busAnnotation = CustomPointAnnotation()
    static var hiddenBusAnnotation = CustomPointAnnotation()
    static var busStepCounter = 0
    static var busDirection = CLLocationDirection()
    static var busPosition = RoutePoint(latitude: 0, longitude: 0)
    
    static var timer = Timer()
    
    var busState: StateActions = StateActions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.isRotateEnabled = false
        self.showCurrentRoute()
        self.showDeliveryPoints()
        self.configureBusState()
        MapManager.createFullRoutePointsArray()
    }
    
    /// Configure current bus state
    func configureBusState() {
        switch busState.currentState {
        case .departure:
            print("Departure")
        case .movement:
            print("Movement")
        case .arrival:
            print("Arrival")
        }
    }
    
    /// Show and focus on current route
    func showCurrentRoute() {
        
        /// Show
        let routePolyline = MKPolyline(coordinates: MapViewController.routePoints.map { point -> CLLocationCoordinate2D in
            CLLocationCoordinate2DMake(point.pointCoordinates.latitude, point.pointCoordinates.longitude) }, count: MapViewController.routePoints.count)
        
        /// Focus
        let annotations = MapViewController.routePoints.map { (point) -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(point.pointCoordinates.latitude, point.pointCoordinates.longitude)
            return annotation }
        
        self.mapView.add(routePolyline)
        self.mapView.showAnnotations(annotations, animated: true)
        self.mapView.removeAnnotations(annotations)
    }
    
    /// Show delivery points on route
    func showDeliveryPoints() {
        
        let annotations = MapViewController.deliveryPoints.enumerated().map { (index, point) -> MKPointAnnotation in
            let annotation = CustomPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(point.pointCoordinates.latitude, point.pointCoordinates.longitude)
            
            switch index {
            case 0:
                annotation.identifier = "home"
            case MapViewController.deliveryPoints.count - 1:
                annotation.identifier = "school"
            default:
                annotation.identifier = "deliveryPoint"
            }
            
            return annotation as MKPointAnnotation
        }
        
        self.mapView.addAnnotations(annotations)
    }

    @IBAction func goPressed(_ sender: UIButton) {
        
        busState.updateBus(state: .movement)

        /// Focus on school bus
        let span = MKCoordinateSpanMake(0.005,0.005)
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(MapViewController.fullRoutePoints.first!.pointCoordinates.latitude,
                                                                       MapViewController.fullRoutePoints.first!.pointCoordinates.longitude), span)
        self.mapView.setRegion(region, animated: true)
        
        let dispatchTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            
            MapViewController.busAnnotation.identifier = "schoolBus"
            MapViewController.busAnnotation.coordinate = CLLocationCoordinate2DMake(MapViewController.fullRoutePoints.first!.pointCoordinates.latitude,
                                                                                    MapViewController.fullRoutePoints.first!.pointCoordinates.longitude)
            
            MapViewController.hiddenBusAnnotation.identifier = "hiddenSchoolBus"
            MapViewController.hiddenBusAnnotation.coordinate = MapViewController.busAnnotation.coordinate
            
            self.mapView.addAnnotations([MapViewController.busAnnotation, MapViewController.hiddenBusAnnotation])
            
            let dispatchTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(self.moveSchoolBus), userInfo: nil, repeats: true)
                Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(self.getSchoolBusPosition), userInfo: nil, repeats: true)
            }
        }
    }
    
    func getSchoolBusPosition() {
        MapManager.getSchoolBusPosition()
    }
    
    func moveSchoolBus() {
        MapViewController.busAnnotation.coordinate.latitude = MapViewController.fullRoutePoints[MapViewController.busStepCounter].pointCoordinates.latitude
        MapViewController.busAnnotation.coordinate.longitude = MapViewController.fullRoutePoints[MapViewController.busStepCounter].pointCoordinates.longitude
        MapViewController.hiddenBusAnnotation.coordinate = MapViewController.busAnnotation.coordinate
        
        /// Rotating bus
        let previousMapPoint = MKMapPoint(x: MapViewController.fullRoutePoints[MapViewController.busStepCounter].pointCoordinates.latitude,
                                          y: MapViewController.fullRoutePoints[MapViewController.busStepCounter].pointCoordinates.longitude)
        
        let nextMapPoint = MKMapPoint(x: MapViewController.fullRoutePoints[MapViewController.busStepCounter + 1].pointCoordinates.latitude,
                                      y: MapViewController.fullRoutePoints[MapViewController.busStepCounter + 1].pointCoordinates.longitude)
        
        MapViewController.busDirection = self.directionBetweenPoints(sourcePoint: previousMapPoint, nextMapPoint)
        MapViewController.busPinView.transform = self.mapView.transform.rotated(by: CGFloat(self.degreesToRadians(degrees: MapViewController.busDirection)))
        
        MapViewController.busStepCounter += 1
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        return fmod(radiansToDegrees(radians: atan2(y, x)), 360.0) + 82.5
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / Double.pi
    }
    
    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }

    /// Delegate mathods:
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor(red: 23.0/255.0, green: 137.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        polylineRenderer.lineWidth = 2.0
        return polylineRenderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let customPointAnnotation = annotation as? CustomPointAnnotation
        
        /// Prevent changing default user location annotation view (blue dot)
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationID = "Identifier"
        var annotationView = CustomAnnotationView()
    
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID) {
            annotationView = dequeuedAnnotationView as! CustomAnnotationView
            annotationView.annotation = annotation
            
            switch (customPointAnnotation?.identifier)! {
            case "schoolBus":
                annotationView.image = #imageLiteral(resourceName: "schoolBus")
                MapViewController.busPinView = annotationView
            case "hiddenSchoolBus":
                annotationView.image = UIImage()
                annotationView.frame.size.height += 20
                annotationView.frame.size.width += 20
            case "home":
                annotationView.image = #imageLiteral(resourceName: "home")
            case "school":
                annotationView.image = #imageLiteral(resourceName: "school")
            default:
                annotationView.image = #imageLiteral(resourceName: "deliveryPoint")
            }
            
            annotationView.identifier = (customPointAnnotation?.identifier)!
            
        } else {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
        }
        
        annotationView.canShowCallout = false
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let customAnnotationView = view as? CustomAnnotationView
        var customCalloutView = UIView()
        
        switch (customAnnotationView?.identifier)! {
        case "hiddenSchoolBus":
            customCalloutView = busState.currentState == .movement ?
                Bundle.main.loadNibNamed("MovementCallout", owner: self, options: nil)?[0] as! MovementCallout :
                Bundle.main.loadNibNamed("DepartureCallout", owner: self, options: nil)?[0] as! DepartureCallout

            var customCalloutViewFrame = customCalloutView.frame
            customCalloutViewFrame.origin = CGPoint(x: -customCalloutViewFrame.size.width / 2.32, y: -customCalloutViewFrame.size.height + 2.5)
            customCalloutView.frame = customCalloutViewFrame
            view.addSubview(customCalloutView)
            
        case "deliveryPoint":
            customCalloutView = Bundle.main.loadNibNamed("DeliveryPointCallout", owner: self, options: nil)?[0] as! DeliveryPointCallout
        
            var customCalloutViewFrame = customCalloutView.frame
            customCalloutViewFrame.origin = CGPoint(x: -customCalloutViewFrame.size.width / 3 , y: -customCalloutViewFrame.size.height + 5)
            customCalloutView.frame = customCalloutViewFrame
            view.addSubview(customCalloutView)
            
        default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        for childView:AnyObject in view.subviews{
            childView.removeFromSuperview();
        }
    }

}

class CustomPointAnnotation: MKPointAnnotation {
    var identifier = ""
}

class CustomAnnotationView: MKAnnotationView {
    var identifier = ""
}
