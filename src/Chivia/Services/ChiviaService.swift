//
//  ChiviaService.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/21/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import Foundation

class ChiviaService {
    
    let geocoding: GeocodingService
    let report: ReportService
    let route: RouteService
    
    private static var instance: ChiviaService?
    
    private init() {
        geocoding = GeocodingService()
        report = ReportService()
        route = RouteService()
    }
    
    static func singleton() -> ChiviaService {
        if instance == nil {
            instance = ChiviaService()
        }
        
        return instance!
    }
    
}
