//
//  Route.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/21/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import CoreLocation
import MapboxDirections
import SwiftyJSON

class Route {
    
    var geometry = [CLLocationCoordinate2D]()
    var waypoints = [Waypoint]()
    
    init(json: JSON) {
        // Initialize geometry
        for point in json["routes"][0]["geometry"].arrayValue {
            let lat = point.arrayValue[0].doubleValue
            let lng = point.arrayValue[1].doubleValue
            geometry.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
        }
        // Initialize waypoints
        for waypoint in json["waypoints"].arrayValue {
            let lat = waypoint["location"][1].doubleValue
            let lng = waypoint["location"][0].doubleValue
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            waypoints.append(Waypoint(coordinate: coordinate))
        }
    }
    
}
