//
//  ViewController.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/18/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import Alamofire
import MapboxDirections
import MapboxNavigation
import PromiseKit
import SwiftyJSON
import UIKit

class HomeViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var whereAreYouGoingTextField: UITextField!
    @IBOutlet weak var routePreferencesView: UIView!
    
    var bestRoute: JSON?
    var mapViewHasLocatedUser = false
    var whereAreYouGoingLocation: CLLocationCoordinate2D?
    var whereAreYouGoingPointAnnotation: MGLPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapViewSetup()
    }
    
    func mapViewSetup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.styleURL = MGLStyle.lightStyleURL()
        mapView.zoomLevel = 14
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        if (!mapViewHasLocatedUser) {
            mapView.setCenter(userLocation!.coordinate, animated: false)
            mapViewHasLocatedUser = true
        }
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 1
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return 2
    }
    
    func mapViewShowWhereAreYouGoingLocation() {
        DispatchQueue.main.async {
            if let annotations = self.mapView.annotations {
                self.mapView.removeAnnotations(annotations)
            }
            
            self.mapView.addAnnotation(self.whereAreYouGoingPointAnnotation!)
            
            self.mapView.setCamera(self.mapView.cameraThatFitsCoordinateBounds(MGLCoordinateBounds(sw: self.mapView.userLocation!.coordinate, ne: self.whereAreYouGoingLocation!), edgePadding: UIEdgeInsets(top: 108, left: 32, bottom: 132, right: 32)), animated: true)
        }
    }
    
    func mapViewSetBestRoutePolyline(coordinates: [CLLocationCoordinate2D]) {
        DispatchQueue.main.async {
            self.mapView.addAnnotation(MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count)))
            
            self.routePreferencesView.isHidden = false
        }
    }
    
    @IBAction func goButtonTouchUpInside(_ sender: UIButton) {
        whereAreYouGoingTextField.endEditing(true)
        
        if let address = whereAreYouGoingTextField.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            firstly {
                self.geocodeAddress(address: address)
            }
            .then {
                self.setWhereAreYouGoingLocation(location: $0)
            }
        }
    }
    
    func geocodeAddress(address: String) -> Promise<CLLocationCoordinate2D> {
        return Promise<CLLocationCoordinate2D> { fullfill, reject in
            let geocodeServiceUrl = "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyC_LXnJZa7FXv_xsz8_WCL_4Ltt1MdExNU"
            
            Alamofire
                .request("\(geocodeServiceUrl)&address=\(address)")
                .responseJSON { response in
                    if let data = response.data {
                        let json = JSON(data: data)
                        let location = json["results"][0]["geometry"]["location"]
                        let lat = location["lat"].doubleValue
                        let lng = location["lng"].doubleValue
                        fullfill(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                    }
                    else {
                        print("Couldn't geocode address \(address)")
                    }
            }
        }
    }
    
    func setWhereAreYouGoingLocation(location: CLLocationCoordinate2D) {
        whereAreYouGoingLocation = location
        whereAreYouGoingPointAnnotation = MGLPointAnnotation()
        whereAreYouGoingPointAnnotation?.coordinate = location
        
        mapViewShowWhereAreYouGoingLocation()
        
        firstly {
            self.findBestRouteToWhereAreYouGoingLocation()
        }
        .then {
            self.mapViewSetBestRoutePolyline(coordinates: $0)
        }
    }
    
    func findBestRouteToWhereAreYouGoingLocation() -> Promise<[CLLocationCoordinate2D]> {
        return Promise<[CLLocationCoordinate2D]> { fullfill, reject in
            let bestRouteServiceUrl = "https://601fc4fd.ngrok.io/route"
            
            let from = "\(mapView.userLocation!.coordinate.longitude),\(mapView.userLocation!.coordinate.latitude)"
            let to = "\(whereAreYouGoingLocation!.longitude),\(whereAreYouGoingLocation!.latitude)"
            
            Alamofire
                .request("\(bestRouteServiceUrl)?from=\(from)&to=\(to)")
                .responseJSON { response in
                    if let data = response.data {
                        self.bestRoute = JSON(data: data)
                        
                        let geometry = self.bestRoute!["routes"][0]["geometry"].arrayValue
                        var polylineCoordinates = [CLLocationCoordinate2D]()
                        
                        for point in geometry {
                            polylineCoordinates.append(CLLocationCoordinate2D(latitude: point.arrayValue[0].doubleValue, longitude: point.arrayValue[1].doubleValue))
                        }
                        
                        fullfill(polylineCoordinates)
                    }
            }
        }
    }
    
    @IBAction func navigateButtonTouchUpInside(_ sender: UIButton) {
        if bestRoute != nil {
            var waypoints = [Waypoint]()
            
            for waypoint in bestRoute!["waypoints"].arrayValue {
                let lat = waypoint["location"][1].doubleValue
                let lng = waypoint["location"][0].doubleValue
                let waypointCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                waypoints.append(Waypoint(coordinate: waypointCoordinate))
            }
            
            let routeOptions = RouteOptions(waypoints: waypoints)
            routeOptions.includesSteps = true
            routeOptions.routeShapeResolution = .full
            
            Directions.shared.calculate(routeOptions) { (waypoints, routes, error) in
                guard let route = routes?.first else { return }
                self.presentNavigationViewController(route: route)
            }
        }
    }
    
    func presentNavigationViewController(route: Route) {
        DispatchQueue.main.async {
            let navigationViewController = NavigationViewController(for: route)
            self.present(navigationViewController, animated: true, completion: nil)
        }
    }
    
}
