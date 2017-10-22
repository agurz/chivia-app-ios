//
//  File.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/21/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import Alamofire
import CoreLocation
import PromiseKit
import SwiftyJSON

class RouteService {
    
    let ROUTE_SERVICE_URL = "http://localhost:3000/route"
    
    func get(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Promise<Route> {
        print("\(ROUTE_SERVICE_URL)?from=\(from.latitude),\(from.longitude)&to=\(to.latitude),\(to.longitude)")
        return Promise { fulfill, reject in
            Alamofire
                .request("\(ROUTE_SERVICE_URL)?from=\(from.longitude),\(from.latitude)&to=\(to.longitude),\(to.latitude)")
                .responseJSON { response in
                    if let data = response.data {
                        let route = Route(json: JSON(data: data))
                        fulfill(route)
                    }
                    else {
                        //reject()
                    }
            }
        }
    }
    
}
