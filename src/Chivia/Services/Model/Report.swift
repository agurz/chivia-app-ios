//
//  Report.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 11/2/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import SwiftyJSON

class Report {
    
    var id: Int
    var type: ReportType
    var description: String
    //var date: Date
    var latitude: Float
    var longitude: Float
    
    init(json: JSON) {
        id = json["id"].intValue
        type = ReportType(json: json["type"])
        description = json["description"].stringValue
        //date = json["date"].stringValue
        latitude = json["latitude"].floatValue
        longitude = json["longitude"].floatValue
    }
    
    func toJSON() -> JSON {
        return [
            "id": id,
            "type": type.toJSON(),
            "description": description,
            //"date": "",
            "latitude": latitude,
            "longitude": longitude
        ]
    }
    
}
