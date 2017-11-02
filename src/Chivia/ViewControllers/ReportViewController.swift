//
//  ReportViewController.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/29/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import CoreLocation
import LGButton
import Toast_Swift

class ReportViewController : UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var reportTypeButton: LGButton!
    
    public var reportType: ReportType?
    public var userLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.becomeFirstResponder()
        
        reportTypeButton.bgColor = reportType!.iconColor
        reportTypeButton.leftIconString = reportType!.iconString
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reportButton(_ sender: UIButton) {
        let report = Report(json: [
            "id": -1,
            "type": reportType!.toJSON(),
            "description": descriptionTextView.text!,
            "latitude": userLocation!.latitude,
            "longitude": userLocation!.longitude,
        ])
        
        ChiviaService
            .singleton()
            .report
            .post(report: report)
            .then { _ in self.reportOk() }
            .catch { err in self.reportError(err: err) }
    }
    
    private func reportOk() {
        self.dismiss(animated: true, completion: nil)
        self.view.makeToast("Reporte enviado correctamente")
    }
    
    private func reportError(err: Error) {
        self.view.makeToast(err.localizedDescription)
    }
    
}
