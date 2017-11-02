//
//  File.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/21/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import Alamofire
import PromiseKit
import SwiftyJSON

class ReportService {
    
    let ROUTE_SERVICE_URL = "http://localhost:3000/report" // "https://chivia.herokuapp.com/report"
    
    func post(report: Report) -> Promise<Bool> {
        return Promise { fulfill, reject in
            Alamofire
                .request("\(ROUTE_SERVICE_URL)", method: .post, parameters: report.toJSON().dictionaryObject, encoding: JSONEncoding.default)
                .validate()
                .responseJSON { response in
                    if response.result.isSuccess, let _ = response.data {
                        fulfill(true)
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
