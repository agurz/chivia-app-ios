//
//  ViewController.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/18/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import MapboxDirections
import MapboxNavigation

class HomeViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var routePreferencesView: UIView!
    @IBOutlet weak var whereAreYouGoingTextField: UITextField!
    
    private var mapViewHasLocatedUser = false
    
    private var destination: CLLocationCoordinate2D?
    private var route: Route?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapViewSetup()
    }
    
    private func mapViewSetup() {
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
        return 3
    }
    
    @IBAction func goButtonTouchUpInside(_ _: UIButton) {
        findAddressCoordinatesAndSetDestination(address: whereAreYouGoingTextField.text!)
        whereAreYouGoingTextField.endEditing(true)
    }
    
    private func findAddressCoordinatesAndSetDestination(address: String) {
        ChiviaService
            .singleton()
            .geocoding
            .get(address: address)
            .then {
                self.setDestination(destination: $0)
            }
    }
    
    private func setDestination(destination: CLLocationCoordinate2D) {
        self.destination = destination
        
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = destination
        
        mapView.addAnnotation(annotation)
        mapView.setCamera(mapView.cameraThatFitsCoordinateBounds(MGLCoordinateBounds(sw: mapView.userLocation!.coordinate, ne: destination), edgePadding: UIEdgeInsets(top: 80, left: 32, bottom: 266, right: 32)), animated: true)
        
        ChiviaService
            .singleton()
            .route
            .get(from: mapView!.userLocation!.coordinate, to: destination)
            .then {
                self.setRoute(route: $0)
            }
    }
    
    private func setRoute(route: Route) {
        self.route = route
        
        mapView.addAnnotation(MGLPolyline(coordinates: route.geometry, count: UInt(route.geometry.count)))
        routePreferencesView.isHidden = false
    }
    
    @IBAction func navigateButtonTouchUpInside(_ _: UIButton) {
        if route != nil {
            let routeOptions = RouteOptions(waypoints: route!.waypoints)
            routeOptions.includesSteps = true
            routeOptions.routeShapeResolution = .full
            
            Directions.shared.calculate(routeOptions) { (waypoints, routes, error) in
                guard let route = routes?.first else { return }
                let navigationViewController = NavigationViewController(for: route)
                self.present(navigationViewController, animated: true, completion: nil)
            }
        }
    }
    
}
