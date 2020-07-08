//
//  SelectPriceUnitViewController.swift
//  Forloop
//
//  Created by Tecorb on 31/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

protocol SelectPriceUnitViewControllerDelegate {
    func selectPricePerUnit(_ viewController: SelectPriceUnitViewController,didSelectIndex:Int ,didSuccess success:Bool)
}

class SelectPriceUnitViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var aTableView: UITableView!
    @IBOutlet weak var submitButton:UIButton!

    
    var selectedIndex: Int = 0

    var delegate : SelectPriceUnitViewControllerDelegate?
    var selectPrice = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.aTableView.dataSource = self
        self.aTableView.delegate = self
        self.submitButton.setTitle("SUBMIT", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        guard let touchedView = touch.view else{return}
        if touchedView == self.view{
           // dismiss(animated: true, completion: nil)
            self.delegate?.selectPricePerUnit(self, didSelectIndex: self.selectedIndex, didSuccess: false)

        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PricePerUnitTableViewCell", for: indexPath) as! PricePerUnitTableViewCell
        let tempCharge = Double(self.selectPrice) ?? 0
        if indexPath.row == 0 {
            let minutes = tempCharge/60

            cell.labelText.text = "$ " + String(format: "%.2f",minutes ) + " per minute"
            
        }else if indexPath.row == 1{
            let halfHour = tempCharge/2
            
          cell.labelText.text = "$ " + String(format: "%.2f",halfHour ) + " per 30 minutes"
        }else{
            
            cell.labelText.text = "$ " + String(format: "%.2f",tempCharge ) + " per hour"

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
       aTableView.reloadData()
    }
    
    
    @IBAction func onClickSubmitButton(_ sender:UIButton) {
        self.delegate?.selectPricePerUnit(self, didSelectIndex: self.selectedIndex, didSuccess: true)

    }
    
    
    @IBAction func onClickCancekButton(_ sender:UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.delegate?.selectPricePerUnit(self, didSelectIndex: self.selectedIndex, didSuccess: false)

    }
    

}

