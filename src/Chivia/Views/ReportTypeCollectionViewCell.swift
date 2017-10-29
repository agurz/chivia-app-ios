//
//  ReportCollectionViewCell.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/29/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import LGButton
import UIKit

class ReportTypeCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet var button: LGButton!
    @IBOutlet var label: UILabel!
    
    public var delegate: ReportTypeCollectionViewCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("ReportTypeCollectionViewCell", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func button(_ sender: LGButton) {
        delegate?.reportTypeCollectionViewCell(clicked: self)
    }
    
}
