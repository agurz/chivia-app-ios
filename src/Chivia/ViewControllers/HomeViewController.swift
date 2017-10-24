//
//  ViewController.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/18/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import DynamicButton
import MapboxDirections
import MapboxNavigation

class HomeViewController: UIViewController {

    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var mapView: HomeMapView!
    @IBOutlet var reportButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapViewSetup()
        reportButtonSetup()
    }
    
    private func mapViewSetup() {
    }
    
    private func reportButtonSetup() {
    }
    
    @IBAction func findBestRouteButton(_ _: UIButton) {
        destinationTextField.endEditing(true)
        findAddressCoordinatesAndSetDestination(address: destinationTextField.text!)
    }
    
    private func findAddressCoordinatesAndSetDestination(address: String) {
        ChiviaService
            .singleton()
            .geocoding
            .get(address: address)
            .then {
                self.mapView.setDestination(destination: $0)
            }
    }
    
}
