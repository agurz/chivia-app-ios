//
//  ReportType.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 11/2/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import SwiftyJSON
import UIKit

class ReportType {
    
    var id: Int
    var name: String
    var iconColor: UIColor
    var iconString: String
    
    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        iconColor = UIColor(hex: json["iconColor"].stringValue)
        iconString = json["iconString"].stringValue
    }
    
    func toJSON() -> JSON {
        return [
            "id": id,
            "name": name,
            "iconColor": iconColor.hexDescription(),
            "iconString": iconString
        ]
    }
    
    static var issue: ReportType {
        get {
            return ReportType(json: JSON([
                "id": 1,
                "name": "Incidente",
                "iconColor": "#e52b50",
                "iconString": "alert"
                ]))
        }
    }
    
    static var mapIssue: ReportType {
        get {
            return ReportType(json: JSON([
                "id": 1,
                "name": "Incidente en el mapa",
                "iconColor": "#ffbf00",
                "iconString": "issue-opened"
                ]))
        }
    }
    
    static var theft: ReportType {
        get {
            return ReportType(json: JSON([
                "id": 1,
                "name": "Robo",
                "iconColor": "#a52a2a",
                "iconString": "bug"
            ]))
        }
    }
    
}
