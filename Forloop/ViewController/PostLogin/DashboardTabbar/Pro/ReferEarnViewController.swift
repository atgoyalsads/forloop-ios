//
//  ReferEarnViewController.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 11/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class ReferEarnViewController: UIViewController {
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var referEarnLabel: UILabel!
    @IBOutlet weak var getDollarLabel: UILabel!
    @IBOutlet weak var shareYourLabel: UILabel!
    
    let referLink = "LEARN1ST"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.linkButton.setTitle("    \(referLink)    ", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func backTapped(_ sender:Any) {
        self.navigationController?.pop(true)
    }

    @IBAction func linkShareTapped(_ Sender:Any) {
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
