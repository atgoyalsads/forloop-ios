//
//  ProfileViewController.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 12/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import Tags

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var notificationIcon: UIButton!
    @IBOutlet weak var favouriteIcon: UIButton!
    
    var user = User()
    var call = CallHistoryModel()
    var callUDID = ""
    var callCategory = ""
    var page = 2
    var perPage = 3
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.navView.backgroundColor = appColor.backgroundAppColor
        self.backView.backgroundColor = appColor.appBlueColor
        self.favouriteIcon.isSelected = self.user.isFavourite
        self.registerCells()
        // Do any additional setup after loading the view.
        //self.getTwilloAccessToken()
        self.getGenerateAccessToken()
    }
//
//    func getTwilloAccessToken(){
//        //if !AppSettings.shared.twilloToken.isEmpty{return}
//        if !AppSettings.isConnectedToNetwork{
//                NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
//                return
//            }
//        let usr = User.loadSavedUser()
//        CallTwilloService.sharedInstance.getTwilloAccessToken(identity: usr.displayName) { (success, token, message) in
//
//            if success{
//                AppSettings.shared.twilloToken = token
//            }
//        }
//
//    }
//
    func getGenerateAccessToken(){
         //if !AppSettings.shared.twilloToken.isEmpty{return}
         if !AppSettings.isConnectedToNetwork{
                 NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
                 return
             }
//        let usr = User.loadSavedUser()

        CallTwilloService.sharedInstance.newGenerateAccessToken(identity: self.user.fname) { message,success in
            if success{
                AppSettings.shared.twilloToken = message as! String

            }
        }

     }
//
//
//
//
//    func getCapibilityToken(){
//        //if !AppSettings.shared.twilloToken.isEmpty{return}
//        if !AppSettings.isConnectedToNetwork{
//                NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
//                return
//            }
//        CallTwilloService.sharedInstance.getCapibilityToken(clientName: "bob") { (success, token, message) in
//            if success{
//                AppSettings.shared.twilloToken = token
//
//            }
//        }
//
//    }
    
    
    func placeCallApi(){
        if !AppSettings.isConnectedToNetwork{
             NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
             return
         }
        AppSettings.shared.showLoader(withStatus: "Loading..")

        CallTwilloService.sharedInstance.placeCall(proId: self.user.ID, callCategory: self.callCategory) { (success,resCall,message) in
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
    
//    func callInitiate(receiverID:String){
//        if !AppSettings.isConnectedToNetwork{
//                NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
//                return
//            }
//        AppSettings.shared.showLoader(withStatus: "Loading..")
//        CallListService.sharedInstance.callInitiate(receiverId: receiverID) { (success, resCall, message) in
//            AppSettings.shared.hideLoader()
//            if success{
//                if let someCall = resCall{
//                    self.call = someCall
//                    self.proceedToCallScreen()
//                }
//            }else{
//                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
//            }
//        }
//
//    }
    
    
    func proceedToCallScreen(){
        let callVC = AppStoryboard.Learner.viewController(CallViewController.self)
        //callVC.receiverUser = self.user
        callVC.call = self.call
//        callVC.callUDID = self.callUDID
        //callVC.outgoingValue = self.user.countryCode.removingWhitespaces() + self.user.contact
        if let temp = self.user.fname.split(separator: " ").first{
            callVC.identity = String(temp)
        }
        callVC.user = self.user
        self.navigationController?.pushViewController(callVC, animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func registerCells() {
        let userImageTableViewCellNib = UINib(nibName: "UserImageTableViewCell", bundle: nil)
        tableview.register(userImageTableViewCellNib, forCellReuseIdentifier: "UserImageTableViewCell")
        let reviewTableViewCellNib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        self.tableview.register(reviewTableViewCellNib, forCellReuseIdentifier: "ReviewTableViewCell")
        let reviewsTableViewCellNib = UINib(nibName: "ReviewsTableViewCell", bundle: nil)
        self.tableview.register(reviewsTableViewCellNib, forCellReuseIdentifier: "ReviewsTableViewCell")
        let numberOfCallTableViewCellNib = UINib(nibName: "NumberOfCallTableViewCell", bundle: nil)
        self.tableview.register(numberOfCallTableViewCellNib, forCellReuseIdentifier: "NumberOfCallTableViewCell")
        let ratingDetailTableViewCellNib = UINib(nibName: "RatingDetailTableViewCell", bundle: nil)
        self.tableview.register(ratingDetailTableViewCellNib, forCellReuseIdentifier: "RatingDetailTableViewCell")
        let callButtonTableViewCellNib = UINib(nibName: "CallButtonTableViewCell", bundle: nil)
        self.tableview.register(callButtonTableViewCellNib, forCellReuseIdentifier: "CallButtonTableViewCell")
        let questionTableViewCellNib = UINib(nibName: "QuestionTableViewCell", bundle: nil)
        self.tableview.register(questionTableViewCellNib, forCellReuseIdentifier: "QuestionTableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.pop(true)
    }
    
    @IBAction func favouriteTapped(_ sender: Any) {
        self.addFavoutire()

    }
    
    @IBAction func notificationTapped(_ sender: Any) {
        NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)

    }
    
    @IBAction func callTapped(_ sender:Any) {
//        self.proceedToCallScreen()
        self.placeCallApi()
        //self.callInitiate(receiverID: self.user.ID)
        
//        NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please add the card details before initiating the call") {
//            let paymentVC = AppStoryboard.Payment.viewController(PaymentOptionViewController.self)
//            self.navigationController?.pushViewController(paymentVC, animated: true)
//        }
        

    }
    
    private func makeButton(_ text: String) -> TagButton {
        let button = TagButton()
        button.setTitle(text, for: .normal)
        //button.setImage(UIImage(named: "tick_unsel"), for: .normal)
        //button.setImage(UIImage(named: "tick_sel"), for: .selected)
        
        let options = ButtonOptions(
            layerColor: appColor.blue,//UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0),
            layerRadius: 5,
            layerWidth: 1,
            tagTitleColor: UIColor.blue,
            tagFont: fonts.Roboto.regular.font(.small),
            tagBackgroundColor: appColor.lightGray)//UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0))
        button.setEntity(options)
        return button
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            if self.user.userDescription.isEmpty{
                return 0
            }else{
                if indexPath.row == 0 {
                    return 50
                }
                return UITableView.automaticDimension
            }

        case 2:
            return 50
        case 3:
            if  self.user.question.count == 0{
                return 0
            }else{
                if indexPath.row == 0 {
                    return 50
                }
                return UITableView.automaticDimension
            }
        case 4:
            if indexPath.row == 0 {
                return 70
            }
            return UITableView.automaticDimension
        case 5:
            return 70
        default:
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return 2
            case 2:
                return 3
            case 3:
                return self.user.question.count+1
            case 4:
                return self.user.ratings.count == 0 ? 0 : self.user.ratings.count+1
            case 5:
                return 1
            default:
                return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserImageTableViewCell", for: indexPath) as! UserImageTableViewCell
            cell.userImage.sd_setImage(with: URL(string:self.user.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "profile_icon"))
            cell.userName.text = self.user.displayName.capitalized
             cell.descriptionLabel.text = user.userDescription
            cell.tagButton = user.allProSkills.compactMap({ self.makeButton($0.skill.uppercased()) })
            cell.chargeLabel.text = Rs + String(format: "%.1f", user.pricePerHours) + "/hour"
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                cell.reviewConstraint.constant = 30.0
                cell.headerLabel.font = fonts.Roboto.medium.font(fontSize.large)
                cell.headerLabel.text = "About"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
                cell.backgroundColor = .white
                cell.selectionStyle = .none
                cell.leadingConstant.constant = 30.0
                cell.reviewsLabel.text = user.userDescription
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberOfCallTableViewCell", for: indexPath) as! NumberOfCallTableViewCell
            cell.selectionStyle = .none
            switch indexPath.row {
            case 0:
                cell.backgroundColor = .white
                cell.dollarLabel.isHidden = true
                cell.chargeLabel.text = "\(self.user.callsDataDetails.totalCalls)"
                cell.headerOfCell.text = "Number of Call"
                cell.imageOfcell.image = UIImage(named: "cll_icon")
            case 1:
                cell.dollarLabel.isHidden = false
                cell.chargeLabel.text = String(format: "%.2f", user.callsDataDetails.avgAmount)//self.user.call
                cell.headerOfCell.text = "Average Call Amount"
                cell.imageOfcell.image = UIImage(named: "call_amount")
            case 2:
                cell.dollarLabel.isHidden = true
                cell.chargeLabel.text =  String(format: "%.2f", user.callsDataDetails.avgMinutes)
                cell.headerOfCell.text = "Average Call Minutes"
                cell.imageOfcell.image = UIImage(named: "time_icon")
            default:
                cell.dollarLabel.isHidden = true
                
            }
            return cell
        case 3:
            return self.cellForAskedQuestion(tableView: tableView, indexPath: indexPath)
        case 4:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
                cell.selectionStyle = .none
                cell.backgroundColor = appColor.appBlueColor
                cell.reviewConstraint.constant = 30.0
                cell.headerLabel.font = fonts.Roboto.medium.font(fontSize.xxLarge)
                cell.headerLabel.textColor = .white
                cell.headerLabel.text = "Ratings"
                return cell
            } else {
                return self.cellForRatingDetailTableViewCell(tableView: tableView, indexPath: indexPath)
            }
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallButtonTableViewCell", for: indexPath) as! CallButtonTableViewCell
            cell.callAgainLabel.text = "Call \(user.displayName.capitalized)"
            cell.callButton.addTarget(self, action: #selector(callTapped(_:)), for: .touchUpInside)
            cell.backgroundColor = appColor.appBlueColor
            cell.swipeView.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserImageTableViewCell", for: indexPath) as! UserImageTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        
        
    }
    
    

    func cellForAskedQuestion(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell{
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = appColor.backgroundAppColor
            cell.headerLabel.text = "Asked Questions"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
            let question = self.user.question[indexPath.row-1]
            cell.selectionStyle = .none
            cell.backgroundColor = appColor.backgroundAppColor
            cell.questionLabel.textColor = .black
            cell.questionLabel.text = "\(indexPath.row). " + "\(question.question)?"
            cell.answerOrNotLabel.text = question.isAnswer ? "   Answered" : "   Not Answered"
            return cell
            }
    }
    
    
//     @IBAction func flingActionCallback(_ sender: TGFlingActionButton) {
//        print(sender.swipe_direction)
//        if sender.swipe_direction == .right {
//           self.placeCallApi()
//           sender.reset()
//            //TO DO: Add the code for actions to be performed once the user swipe the button to right.
//        }
//        if sender.swipe_direction == .left {
//             //TO DO: Add the code for actions to be performed once the user swipe the button to left.
//        }
//    }
    
    
    func cellForRatingDetailTableViewCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingDetailTableViewCell", for: indexPath) as! RatingDetailTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = appColor.appBlueColor
        let rating = self.user.ratings[indexPath.row-1]
        if indexPath.row == self.user.ratings.count {
            cell.borderView.isHidden = true
            cell.timeConstraint.constant = -5
        } else {
            cell.borderView.isHidden = false
            cell.timeConstraint.constant = 15
        }
        
        cell.reviewLabel.text = rating.callReview
        cell.reviewerNameLabel.text = rating.reviewedBy.capitalized
        cell.ratingLabel.text = String(format: "%.1f", rating.rating)
        cell.dateTimeLabel.text = CommonClass.formattedDateWithString(rating.createdAt, format: "h:mm a, d MMM yyyy")

        return cell
    }
    
}

extension ProfileViewController{
    func addFavoutire(){
        if !AppSettings.isConnectedToNetwork{
             NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
             return
         }
        AppSettings.shared.showLoader(withStatus: "Loading..")
        
        LearnerService.sharedInstance.addProFavourites(proUserId: self.user.ID) { (success, message) in
            AppSettings.shared.hideLoader()
            if success{
                if self.user.isFavourite{
                    
                    self.user.isFavourite = false
                    self.favouriteIcon.isSelected = false
                }else{
                    self.user.isFavourite = true
                    self.favouriteIcon.isSelected = true

                }
            }
        }
    }
    
    func loadProRating(_ page: Int,perPage:Int) -> Void {
           if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
               if self.page > 2{
                   self.page = self.page - 1
               }
            AppSettings.shared.hideLoader()
               return
           }
           self.isLoading = true
        ProService.sharedInstance.getProRatingPagination(ProID: self.user.ID, page: page, perPage: perPage) {(success, resRatings, message) in
            AppSettings.shared.hideLoader()
               self.isLoading = false
               if let someRatings = resRatings{
                   if someRatings.count == 0{
                       if self.page > 2{
                           self.page = self.page - 1
                       }
                   }
                self.user.ratings.append(contentsOf:someRatings)
               }else{
                   if self.page > 2{
                       self.page = self.page - 1
                   }
               }
    
               self.tableview.reloadData()
           }
       }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tableview{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height+1) >= scrollView.contentSize.height)
            {
//                if self.perPage > self.user.ratings.count{return}
                if !isLoading{
                    if AppSettings.isConnectedToNetwork{
                        isLoading = true
                        self.page+=1
                        self.loadProRating(self.page, perPage: self.perPage)
                    }
                }
            }
        }
    }
    
    
}

extension ProfileViewController:MTSlideToOpenDelegate{
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        self.placeCallApi()
        sender.resetStateWithAnimation(false)


    }
    
}
