//
//  HomeMapViewDelegate.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/24/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import Foundation

protocol HomeMapViewDelegate {
    
    func homeMapView(homeMapView: HomeMapView, routeDetected route: Route)
    
}
