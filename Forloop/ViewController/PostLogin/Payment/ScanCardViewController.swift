//
//  ScanCardViewController.swift
//  Fuel Delivery
//
//  Created by Parikshit on 09/10/19.
//  Copyright © 2019 Nakul Sharma. All rights reserved.
//

import UIKit

protocol ScanCardViewControllerDelegate {
    func cardDidScan(viewcontroller:ScanCardViewController, withCardInfo cardInfo:CardIOCreditCardInfo)
    func cardDidScan(viewcontroller:ScanCardViewController, isUserChooseManual wantManual:Bool)
}

class ScanCardViewController: UIViewController,CardIOViewDelegate {
    @IBOutlet weak var cardIOView : CardIOView!
    @IBOutlet weak var showScanningButton: UIButton!
    var scanOverLayView: UIView = UIView()
    var delegate : ScanCardViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SCAN CARD"
        self.navigationItem.rightBarButtonItem?.title = "Fill Manually"
        self.showScanningButton.setTitle("SCANNING..", for: .normal)
        startScan()
    }
    @IBAction func onClickClose(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickFillManually(_ sender: UIBarButtonItem){
        delegate?.cardDidScan(viewcontroller: self, isUserChooseManual: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func startScan()  {
        if CardIOUtilities.canReadCardWithCamera(){
            self.cardIOView.delegate = self
            scanOverLayView.backgroundColor = UIColor.clear
            self.cardIOView.guideColor = appColor.red
            self.cardIOView.detectionMode = .cardImageAndNumber
            self.cardIOView.scanExpiry = true
            self.cardIOView.hideCardIOLogo = true
            self.cardIOView.scannedImageDuration = 0
            self.cardIOView.scanInstructions = "Hold card here.\nIt will scan automatically."
            
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.scanOverLayView.frame = self.cardIOView.cameraPreviewFrame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        self.delegate?.cardDidScan(viewcontroller: self, withCardInfo: cardInfo)
        self.dismiss(animated: true, completion: nil)
    }
    
}
