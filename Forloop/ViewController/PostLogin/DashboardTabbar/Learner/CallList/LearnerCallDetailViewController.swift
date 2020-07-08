//
//  LearnerCallDetailViewController.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 12/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class LearnerCallDetailViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var callDetailLabel: UILabel!
    @IBOutlet weak var navView: UIView!
    
    var call = CallHistoryModel()
    var user = User()
    var callID = ""
    var receiverUser = ReceiverModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callID = call.id
        self.user = User.loadSavedUser()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
        self.loadCallDetailApi(callID: callID)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
               self.removePopSlide()

    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.pop(true)
    }
    
    func registerCells() {
        let callDurationTableViewCellNib = UINib(nibName: "CallDurationTableViewCell", bundle: nil)
        self.tableview.register(callDurationTableViewCellNib, forCellReuseIdentifier: "CallDurationTableViewCell")
        let callCategoryTableViewCellNib = UINib(nibName: "CallCategoryTableViewCell", bundle: nil)
        self.tableview.register(callCategoryTableViewCellNib, forCellReuseIdentifier: "CallCategoryTableViewCell")
        let reviewTableViewCellNib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        self.tableview.register(reviewTableViewCellNib, forCellReuseIdentifier: "ReviewTableViewCell")
        let questionTableViewCellNib = UINib(nibName: "QuestionTableViewCell", bundle: nil)
        self.tableview.register(questionTableViewCellNib, forCellReuseIdentifier: "QuestionTableViewCell")
        let questionAddressedTableViewCellNib = UINib(nibName: "QuestionAddressedTableViewCell", bundle: nil)
        self.tableview.register(questionAddressedTableViewCellNib, forCellReuseIdentifier: "QuestionAddressedTableViewCell")
        let ratingTableViewCellNib = UINib(nibName: "RatingTableViewCell", bundle: nil)
        self.tableview.register(ratingTableViewCellNib, forCellReuseIdentifier: "RatingTableViewCell")
        let reviewsTableViewCellNib = UINib(nibName: "ReviewsTableViewCell", bundle: nil)
        self.tableview.register(reviewsTableViewCellNib, forCellReuseIdentifier: "ReviewsTableViewCell")
        let callButtonTableViewCellNib = UINib(nibName: "CallButtonTableViewCell", bundle: nil)
        self.tableview.register(callButtonTableViewCellNib, forCellReuseIdentifier: "CallButtonTableViewCell")
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
                    self.receiverUser = self.call.receiverUser
                    self.tableview.reloadData()
                }
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }
    }
    
    func placeCallApi(){
        if !AppSettings.isConnectedToNetwork{
             NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
             return
         }
        AppSettings.shared.showLoader(withStatus: "Loading..")

        CallTwilloService.sharedInstance.placeCall(proId: self.call.receiverId, callCategory: self.call.callCategory) { (success,resCall,message) in
            AppSettings.shared.hideLoader()
            if success{
                if let someCall = resCall{
                    self.call = someCall
                    self.proceedToCallScreen()
                }
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }
        
    }
    
    
    func proceedToCallScreen(){
        var aUser = User()
        aUser.displayName = receiverUser.displayName
        aUser.image = receiverUser.image
        let callVC = AppStoryboard.Learner.viewController(CallViewController.self)
        callVC.call = self.call
        //callVC.outgoingValue = self.user.countryCode.removingWhitespaces() + self.user.contact
        if let temp = self.user.fname.split(separator: " ").first{
            callVC.identity = String(temp)
        }
        
        callVC.user = aUser
        self.navigationController?.pushViewController(callVC, animated: true)
    }
    
       @IBAction func callTapped(_ sender:Any) {
            self.placeCallApi()

        }


}

extension LearnerCallDetailViewController: UITableViewDataSource, UITableViewDelegate {
                            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 220
        case 1:
            return 50
        case 2:
            if call.callReview.isEmpty{
               return 0
            }else{
              if indexPath.row == 0 {
                return 50
              }
            return UITableView.automaticDimension
        }
           
        case 3:
            if  self.call.question.count == 0{
               return 0
            }else{
                if indexPath.row == 0 {
                   return 50
                }
                return UITableView.automaticDimension
            }

        case 4:
            return 70
        case 5:
            return 120
        case 6:
            if self.call.feedbackNotLiked.isEmpty{
               return 0
            }else{
            if indexPath.row == 0 {
                return 50
                }
              return UITableView.automaticDimension
            }
           
        case 7:
            return 70
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
                    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 2
        case 3:
            return self.call.question.count+1
        case 4:
            return 1
        case 5:
            return 1
        case 6:
            return 2
        case 7:
            return 1
        default:
            return 1
        }
    }
                    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallDurationTableViewCell", for: indexPath) as! CallDurationTableViewCell
            cell.selectionStyle = .none
            cell.callerName.text = call.receiverUser.displayName
            cell.callDurationLabel.text = "Call Time:\(call.durationMinutes) Min"
            cell.callDate.text = CommonClass.formattedDateWithString(call.createdAt, format: "h:mm a d MMM, yyyy")//getDateFromDateString(history.createdAt, format: "dd-MMMM-yyyy")//history.createdAt
            cell.userTwoImage.sd_setImage(with: URL(string:self.call.dialerUser.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "user_placeholder"))
            cell.userOneImage.sd_setImage(with: URL(string:self.call.receiverUser.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "user_placeholder"))
            cell.reviewLabel.text = String(format: "%.1f", call.rating)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallCategoryTableViewCell", for: indexPath) as! CallCategoryTableViewCell
            cell.selectionStyle = .none
            switch  indexPath.row {
            case 0:
                cell.dollarLabel.isHidden = true
                cell.categoryNameLabel.text = "Call Category"
                cell.categoryChargeLabel.text = call.callCategory
            case 1:
                cell.dollarLabel.isHidden = false
                cell.categoryNameLabel.text = "Tip @\(self.user.displayName)"
                cell.categoryChargeLabel.text = String(format: "%.2f", call.tip)
            default:
                cell.dollarLabel.isHidden = false
                cell.categoryNameLabel.text = "Total Call Charge"
                cell.categoryChargeLabel.text = "30.23"
                
            }
            return cell
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
                cell.selectionStyle = .none
                cell.headerLabel.text = "Review"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
                cell.selectionStyle = .none
                cell.reviewsLabel.textColor = .black
                cell.reviewsLabel.text = call.callReview
                return cell
            }
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
                cell.selectionStyle = .none
                cell.backgroundColor = appColor.backgroundAppColor
                cell.headerLabel.text = "Asked Questions"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
                let question = self.call.question[indexPath.row-1]
                cell.selectionStyle = .none
                cell.backgroundColor = appColor.backgroundAppColor
                cell.questionLabel.textColor = .black
                cell.questionLabel.text = "\(indexPath.row). " + "\(question.question)?"
                cell.answerOrNotLabel.text = question.isAnswer ? "   Answered" : "   Not Answered"
                return cell
                }
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAddressedTableViewCell", for: indexPath) as! QuestionAddressedTableViewCell
            cell.selectionStyle = .none
            cell.yesNoButton.setTitle(call.feedbackQuestionAddressed ? "Yes" : "No", for: .normal)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell", for: indexPath) as! RatingTableViewCell
            cell.selectionStyle = .none
            cell.ratingView.rating = Float(call.rating)
            cell.ratingLabel.text = String(format: "%.1f", call.rating)
            cell.ratingView.isUserInteractionEnabled = false
            return cell
        case 6:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
                cell.selectionStyle = .none
                cell.headerLabel.text = "Overall Experience"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
                cell.selectionStyle = .none
                cell.reviewsLabel.text = call.feedbackNotLiked
                return cell
            }
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallButtonTableViewCell", for: indexPath) as! CallButtonTableViewCell
            cell.selectionStyle = .none
            cell.callAgainLabel.text = "Call Again to \(call.receiverUser.displayName.capitalized)"
            cell.callButton.addTarget(self, action: #selector(callTapped(_:)), for: .touchUpInside)
            cell.swipeView.delegate = self
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallDurationTableViewCell", for: indexPath) as! CallDurationTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
//       @IBAction func flingActionCallback(_ sender: TGFlingActionButton) {
//         print(sender.swipe_direction)
//         if sender.swipe_direction == .right {
//            self.placeCallApi()
//            sender.reset()
//             //TO DO: Add the code for actions to be performed once the user swipe the button to right.
//         }
//         if sender.swipe_direction == .left {
//              //TO DO: Add the code for actions to be performed once the user swipe the button to left.
//         }
//     }
    
      
}

extension LearnerCallDetailViewController:MTSlideToOpenDelegate{
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        self.placeCallApi()
        sender.resetStateWithAnimation(false)


    }
}

extension LearnerCallDetailViewController:UIGestureRecognizerDelegate{
  
    func removePopSlide() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            return false
        }
        return true
    }
}

