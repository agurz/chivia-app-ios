//
//  ReportViewController.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/24/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var collectionData: [[String:String]] = [
        ["title": "Peligro!", "icon": "warning", "color": "#f34567"],
        ["title": "Peligro!", "icon": "warning", "color": "#f34567"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func collectionView(_ _: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return collectionData.count
    }
    
    internal func collectionView(_ _: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportCollectionViewCell", for: indexPath) as! ReportCollectionViewCell
        cell.button.bgColor = UIColor.init(hex: collectionData[indexPath.row]["color"]!)
        cell.button.leftIconString = collectionData[indexPath.row]["icon"]!
        return cell
    }

}
