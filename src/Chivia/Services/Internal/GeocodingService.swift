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

class GeocodingService {
    
    let GEOCODING_SERVICE_URL = "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyC_LXnJZa7FXv_xsz8_WCL_4Ltt1MdExNU"
    
    func get(address: String) -> Promise<CLLocationCoordinate2D> {
        return Promise { fulfill, reject in
            Alamofire
                .request("\(GEOCODING_SERVICE_URL)&address=\(address.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)")
                .validate()
                .responseJSON { response in
                    if response.result.isSuccess, let data = response.data {
                        let json = JSON(data: data)
                        let location = json["results"][0]["geometry"]["location"]
                        let lat = location["lat"].doubleValue
                        let lng = location["lng"].doubleValue
                        fulfill(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                    }
                    else if let data = response.data {
                        let json = JSON(data: data)
                        reject(GenericError(message: json["message"].stringValue))
                    }
                    else if let err = response.error {
                        reject(err)
                    }
            }
        }
    }
    
}
