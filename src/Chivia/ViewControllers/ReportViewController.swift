//
//  ReportViewController.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/29/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import LGButton

class ReportViewController : UIViewController {
    
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var reportTypeButton: LGButton!
    
    public var reportType: ReportType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTextView.layer.borderColor = UIColor.gray.cgColor
        commentsTextView.layer.borderWidth = 0.5
        commentsTextView.becomeFirstResponder()
        
        reportTypeButton.bgColor = reportType!.iconColor
        reportTypeButton.leftIconString = reportType!.iconString
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reportButton(_ sender: UIButton) {
        
    }
    
}
