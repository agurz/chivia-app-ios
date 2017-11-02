//
//  StandService.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/22/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import Alamofire
import PromiseKit
import SwiftyJSON

class StandService {
    
    let STAND_SERVICE_URL = "https://chivia.herokuapp.com/stand"
    
    func get() -> Promise<[Stand]> {
        return Promise { fulfill, reject in
            Alamofire
                .request("\(STAND_SERVICE_URL)")
                .validate()
                .responseJSON { response in
                    if response.result.isSuccess, let data = response.data {
                        let json = JSON(data: data)
                        var stands = [Stand]()
                        
                        for item in json.arrayValue {
                            stands.append(Stand(json: item))
                        }
                        
                        fulfill(stands)
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
