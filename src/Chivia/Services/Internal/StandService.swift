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
    
    let STAND_SERVICE_URL = "http://localhost:3000/stand"
    
    func get() -> Promise<[Stand]> {
        return Promise { fulfill, reject in
            Alamofire
                .request("\(STAND_SERVICE_URL)")
                .responseJSON { response in
                    if let data = response.data {
                        let json = JSON(data: data)
                        var stands = [Stand]()
                        
                        for item in json.arrayValue {
                            stands.append(Stand(json: item))
                        }
                        
                        fulfill(stands)
                    }
                    else {
                        //reject()
                    }
            }
        }
    }
    
}
