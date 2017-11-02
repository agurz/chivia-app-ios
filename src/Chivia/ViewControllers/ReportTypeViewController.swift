//
//  ReportViewController.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/24/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import MZFormSheetPresentationController

class ReportTypeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ReportTypeCollectionViewCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    
    private var collectionData: [ReportType] = [
        ReportType.issue,
        ReportType.mapIssue,
        ReportType.theft
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    internal func collectionView(_ _: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return collectionData.count
    }
    
    internal func collectionView(_ _: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportTypeCollectionViewCell", for: indexPath) as! ReportTypeCollectionViewCell
        cell.delegate = self
        cell.reportType = collectionData[indexPath.row]
        return cell
    }
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func reportTypeCollectionViewCell(clicked reportType: ReportType) {
        let reportViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        reportViewController.reportType = reportType
        
        let sheetViewController = MZFormSheetPresentationViewController(contentViewController: reportViewController)
        sheetViewController.presentationController?.contentViewSize = UILayoutFittingCompressedSize
        
        present(sheetViewController, animated: true, completion: nil)
    }

    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
