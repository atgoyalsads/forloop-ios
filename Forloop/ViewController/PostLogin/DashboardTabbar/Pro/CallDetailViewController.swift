//
//  CallDetailViewController.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 11/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class CallDetailViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var callDetailLabel: UILabel!
    @IBOutlet weak var navView: UIView!
    var heightOfSections: [CGFloat] = [220,50,50,50,50]
    var call = CallHistoryModel()
    var user = User()
    var callID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.callID = call.id
        self.user = User.loadSavedUser()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.navView.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
        self.loadCallDetailApi(callID: callID)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func backTapped(_ sender: Any) {
           self.navigationController?.pop(true)
       }
                    
    func registerCells() {
        let callDurationTableViewCellNib = UINib(nibName: "CallDurationTableViewCell", bundle: nil)
        self.tableview.register(callDurationTableViewCellNib, forCellReuseIdentifier: "CallDurationTableViewCell")
        let callChargeTableViewCellNib = UINib(nibName: "CallChargeTableViewCell", bundle: nil)
        self.tableview.register(callChargeTableViewCellNib, forCellReuseIdentifier: "CallChargeTableViewCell")
        let reviewTableViewCellNib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        self.tableview.register(reviewTableViewCellNib, forCellReuseIdentifier: "ReviewTableViewCell")
        let reviewsTableViewCellNib = UINib(nibName: "ReviewsTableViewCell", bundle: nil)
        self.tableview.register(reviewsTableViewCellNib, forCellReuseIdentifier: "ReviewsTableViewCell")
        let addNoteTableViewCellNib = UINib(nibName: "AddNoteTableViewCell", bundle: nil)
        self.tableview.register(addNoteTableViewCellNib, forCellReuseIdentifier: "AddNoteTableViewCell")
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }
                    
            
            func loadCallDetailApi(callID:String){
                if !AppSettings.isConnectedToNetwork{
                  NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
                     return
                 }
                AppSettings.shared.showLoader(withStatus: "Loading..")
                CallListService.sharedInstance.getCallDetails(callID: callID) { (success, resCall, message) in
                    AppSettings.shared.hideLoader()
                    if success{
                        if let someCall = resCall{
                            self.call = someCall
                            self.tableview.reloadData()
                        }
                    }else{
                        NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
                    }
                }
            }
    
    
    @IBAction func callTapped(_ sender:Any) {
        NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)
     }
    

}

extension CallDetailViewController: UITableViewDataSource, UITableViewDelegate {
                            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return heightOfSections[indexPath.section]
        case 1:
            return heightOfSections[indexPath.section]
        case 2:
            if call.callReview.isEmpty{
                return 0
            }else{
            if indexPath.row == 0 {
                return heightOfSections[indexPath.section]
                }
             return UITableView.automaticDimension
            }
           
        case 3:
            if self.call.question.count == 0{
              return 0
            }else{
                if indexPath.row == 0 {
                    return heightOfSections[indexPath.section]
                }
            }

            return UITableView.automaticDimension
        case 4:
            if indexPath.row == 0 {
                return heightOfSections[indexPath.section]
            }
            return 200
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return heightOfSections.count
    }
                    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        
        case 1:
            return 4
        case 2:
            
            return 2
        case 3:
            return self.call.question.count+1
        case 4:
            return 2
        default:
            return 1
        }
    }
                    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallDurationTableViewCell", for: indexPath) as! CallDurationTableViewCell
            cell.selectionStyle = .none
            cell.callerName.text = call.dialerUser.displayName
            cell.callDurationLabel.text = "Call Time:\(call.durationMinutes) Min"
            cell.callDate.text = CommonClass.formattedDateWithString(call.createdAt, format: "h:mm a d MMM, yyyy")//getDateFromDateString(history.createdAt, format: "dd-MMMM-yyyy")//history.createdAt
            cell.userTwoImage.sd_setImage(with: URL(string:self.call.dialerUser.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "user_placeholder"))
             cell.userOneImage.sd_setImage(with: URL(string:self.call.receiverUser.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "user_placeholder"))
            cell.reviewLabel.text = String(format: "%.1f", call.rating)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallChargeTableViewCell", for: indexPath) as! CallChargeTableViewCell
            cell.selectionStyle = .none
            switch  indexPath.row {
            case 0:
                cell.dollarLabel.isHidden = true
                cell.chargeNameLabel.text = "Call Category"
                cell.chargeLabel.text = call.callCategory
                cell.borderView.isHidden = true
            case 1:
                cell.dollarLabel.isHidden = false
                cell.chargeNameLabel.text = "Total Call Charge"
                cell.chargeLabel.text = String(format: "%.2f", call.totalPrice)
                cell.borderView.isHidden = true
            case 2:
                cell.dollarLabel.isHidden = false
                cell.chargeNameLabel.text = "QANSD Commision 20%"
                cell.chargeLabel.text = "0.00"
                cell.borderView.isHidden = true
            case 3:
                cell.dollarLabel.isHidden = false
                cell.chargeNameLabel.text = "You Earned"
                cell.chargeLabel.text = String(format: "%.2f", call.totalPrice)
                cell.borderView.backgroundColor = appColor.backgroundAppColor
                cell.borderView.isHidden = false
            default:
                cell.dollarLabel.isHidden = false
                cell.chargeNameLabel.text = ""
                cell.chargeLabel.text = ""
                cell.borderView.isHidden = true
                
            }
            return cell
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
                cell.selectionStyle = .none
                cell.backgroundColor = appColor.backgroundAppColor
                cell.headerLabel.text = "Review"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
                cell.selectionStyle = .none
                cell.backgroundColor = appColor.backgroundAppColor
                cell.reviewsLabel.text = call.callReview
                return cell
            }
            
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
                cell.selectionStyle = .none
                cell.headerLabel.text = "Asked Questions"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
                let question = self.call.question[indexPath.row-1]
                cell.selectionStyle = .none
                cell.reviewsLabel.textColor = UIColor.black
                cell.reviewsLabel.text = "\(indexPath.row). " + question.question
                return cell
            }
        case 4:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
                cell.selectionStyle = .none
                cell.headerLabel.text = "Add a Note"
                cell.backgroundColor = appColor.backgroundAppColor
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNoteTableViewCell", for: indexPath) as! AddNoteTableViewCell
                cell.selectionStyle = .none
                cell.backgroundColor = appColor.backgroundAppColor
                cell.sendMessageLabel.text = "Send Message to \(call.dialerUser.displayName.capitalized)"
                cell.buttonToCall.addTarget(self, action: #selector(callTapped(_:)), for: .touchUpInside)
                cell.swipeView.delegate = self
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallDurationTableViewCell", for: indexPath) as! CallDurationTableViewCell
            cell.selectionStyle = .none

            return cell
        }
    }
    
//     @IBAction func flingActionCallback(_ sender: TGFlingActionButton) {
//        print(sender.swipe_direction)
//        if sender.swipe_direction == .right {
//           //self.placeCallApi()
//         NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)
//           sender.reset()
//            //TO DO: Add the code for actions to be performed once the user swipe the button to right.
//        }
//        if sender.swipe_direction == .left {
//             //TO DO: Add the code for actions to be performed once the user swipe the button to left.
//        }
//    }
}

extension CallDetailViewController:MTSlideToOpenDelegate{
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
         sender.resetStateWithAnimation(false)
    }
    
    
}

