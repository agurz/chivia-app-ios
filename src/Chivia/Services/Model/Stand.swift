//
//  Stand.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/22/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import CoreLocation
import MapboxDirections
import SwiftyJSON

class Stand {
    
    var id: Int
    var name: String
    var coordinate: CLLocationCoordinate2D
    var size: Int
    
    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        coordinate = CLLocationCoordinate2D(latitude: json["latitude"].doubleValue, longitude: json["longitude"].doubleValue)
        size = json["size"].intValue
    }
    
}

