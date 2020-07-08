//
//  CallExperienceViewController.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 13/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class CallExperienceViewController: UIViewController {

    @IBOutlet weak var callerImage: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var displayName:UILabel!
    var call = CallHistoryModel()
    var questions = [QuestionModel]()
    var review = ""
    var appExprience = ""
    var overAllExprience = ""
    var rating:Double = 0
    var isAddress:Bool = true
    var tipsArray = ["$1","$2","$5","OTHERS"]
    var tempArray = ["$10","$20","$30","$40","$50","$60","$70","$80","$90","$100"]
    var selectTips = ""
    var tipsParams = [Dictionary<String,Any>]()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var selectIndex = -1
    var receriverUser = User()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        questions.append(QuestionModel())

        self.callerImage.sd_setImage(with: URL(string:receriverUser.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "user_placeholder"))
        self.displayName.text = receriverUser.displayName
        self.view.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }
    
    override func viewDidLayoutSubviews() {
        CommonClass.makeCircularCornerNewMethodRadius(self.callerImage, cornerRadius: self.callerImage.frame.width/2)
    }
    
    func registerCells() {
        let reviewTableViewCellNib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        tableview.register(reviewTableViewCellNib, forCellReuseIdentifier: "ReviewTableViewCell")
        let reviewsTableViewCellNib = UINib(nibName: "ReviewsTableViewCell", bundle: nil)
        tableview.register(reviewsTableViewCellNib, forCellReuseIdentifier: "ReviewsTableViewCell")
        let rateCallerTableViewCellNib = UINib(nibName: "RateCallerTableViewCell", bundle: nil)
        tableview.register(rateCallerTableViewCellNib, forCellReuseIdentifier: "RateCallerTableViewCell")
        let descriptionTextViewTableViewCellNib = UINib(nibName: "DescriptionTextViewTableViewCell", bundle: nil)
        tableview.register(descriptionTextViewTableViewCellNib, forCellReuseIdentifier: "DescriptionTextViewTableViewCell")
        let tipTableViewCellNib = UINib(nibName: "TipTableViewCell", bundle: nil)
        tableview.register(tipTableViewCellNib, forCellReuseIdentifier: "TipTableViewCell")
        let yesNoTableViewCellNib = UINib(nibName: "YesNoTableViewCell", bundle: nil)
        tableview.register(yesNoTableViewCellNib, forCellReuseIdentifier: "YesNoTableViewCell")
        let addQuestionTableViewCellNib = UINib(nibName: "AddQuestionTableViewCell", bundle: nil)
        tableview.register(addQuestionTableViewCellNib, forCellReuseIdentifier: "AddQuestionTableViewCell")
        let submitTableViewCellNib = UINib(nibName: "SubmitTableViewCell", bundle: nil)
        tableview.register(submitTableViewCellNib, forCellReuseIdentifier: "SubmitTableViewCell")
        let tempTextViewTableViewCellNib = UINib(nibName: "TempTextViewTableViewCell", bundle: nil)
        tableview.register(tempTextViewTableViewCellNib, forCellReuseIdentifier: "TempTextViewTableViewCell")
        let writeQuestionTableViewCellNib = UINib(nibName: "WriteQuestionTableViewCell", bundle: nil)
        tableview.register(writeQuestionTableViewCellNib, forCellReuseIdentifier: "WriteQuestionTableViewCell")
        



        tableview.dataSource = self
        tableview.delegate = self
    }
    
    @IBAction func backTapped(_ sender: Any) {
       // self.navigationController?.pop(true)
        self.navigationController?.popToRoot(true)
    }
    
    @IBAction func submitTapped(_ sender:Any) {
        for i in (0..<self.questions.count){
            var param = Dictionary<String,String>()
            param.updateValue(self.questions[i].label, forKey: "label")
            param.updateValue("\(self.questions[i].rating)", forKey: "rating")
            tipsParams.append(param)
        }
    
        let options = self.questions.filter{$0.label.isEmpty}.first
        if let otp = options{
           if otp.label.isEmpty{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter question ")
            }else{
                self.setCallingRating()
            }
        }else{
            self.setCallingRating()

        }
//        if options?.label.isEmpty{
//            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter question ")
//        }else{
//            self.setCallingRating()
//        }

//        if options.count == 0{
//          NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter question ")
//        }else{
//           self.setCallingRating()
//        }
        
//        if questions.count == 1{
//            if (questions.first!.label.isEmpty){
//                NKToastHelper.sharedInstance.showErrorAlert(self, message: "Questions must be present")
//                return
//            }else{
//                self.setCallingRating()
//
//            }
//        }else{
//            self.setCallingRating()
//
//        }
//
    }
    
    @IBAction func onClickAddQuestionButton(_ sender:UIButton){
        let addQuesVC = AppStoryboard.Learner.viewController(AddQuestionViewController.self)
        addQuesVC.delegate = self
        self.navigationController?.pushViewController(addQuesVC, animated: true)
    }
    
    @IBAction func onClickYesButton(_ sender:UIButton){
        if isAddress{return}
        self.isAddress = true
        self.tableview.reloadSections([5], with: .none)
        
        
    }
    
    @IBAction func onClickNoButton(_ sender:UIButton){
        if !isAddress{return}
        self.isAddress = false
        self.tableview.reloadSections([5], with: .none)
    }
    
    func setCallingRating(){
        if !AppSettings.isConnectedToNetwork{
           NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            return
         }
        
        AppSettings.shared.showLoader(withStatus: "Loading..")

        LearnerService.sharedInstance.setCallingRating(callId: self.call.id, rating: "\(self.rating)", review: self.review, questions: self.tipsParams, tip: self.selectTips, questionAnswer: self.isAddress, notLinked: self.overAllExprience, newFeatures: self.appExprience) { success,message in
            AppSettings.shared.hideLoader()
           if success{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: message) {
                self.navigationController?.popToRoot(true)
            }
          }
        }
    }

}

extension CallExperienceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 2
        case 4:
            return 1
        case 5:
            return 3
        case 6:
            return questions.count+1
        case 7:
            return 5
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return 50
            }
            return UITableView.automaticDimension
        case 1:
            return 50
        case 2:
            return 150
        case 3:
            return 25
        case 4:
            return 80
        case 5:
            switch indexPath.row {
            case 0:
                return UITableView.automaticDimension
            case 1:
                return 70
            case 2:
                return UITableView.automaticDimension
            default:
                return 50
            }
        case 6:
            if indexPath.row == self.questions.count {
                return 50
            }else{
               return 250
            }

        case 7:
            switch indexPath.row {
            case 0:
                return UITableView.automaticDimension
            case 1:
                return 150
            case 2:
                return UITableView.automaticDimension
            case 3:
                return 150
            case 4:
                return 70
            default:
                return 50
            }
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.reviewConstraint.constant = 30
                cell.headerLabel.font = fonts.Roboto.medium.font(fontSize.xxLarge)
                cell.headerLabel.text = "How was your Call?"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.leadingConstant.constant = 30
                cell.reviewsLabel.text = "Your feedback is important to make Seeker Experience Better"
                cell.reviewsLabel.textColor = UIColor.darkGray
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RateCallerTableViewCell", for: indexPath) as! RateCallerTableViewCell
            cell.selectionStyle = .none
            cell.ratingView.rating = Float(self.rating)
            cell.ratingLabel.text = String(format: "%.1f", self.rating)
            cell.ratingView.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TempTextViewTableViewCell", for: indexPath) as! TempTextViewTableViewCell
            cell.selectionStyle = .none
            cell.aTextView.placeholder = "Write here your Review"
            cell.aTextView.delegate = self
            cell.aTextView.text = review

            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.reviewConstraint.constant = 30
            if indexPath.row == 0 {
                cell.headerLabel.font = fonts.Roboto.medium.font(fontSize.xLarge)
                cell.headerLabel.text = "Would you like to Tip @\(receriverUser.fname.capitalized) \(receriverUser.lname.capitalized)"
            } else {
                cell.headerLabel.font = fonts.Roboto.regular.font(fontSize.medium)
                cell.headerLabel.text = "Full Tip Amount Goes Directly to the Pro"
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipTableViewCell", for: indexPath) as! TipTableViewCell
//            cell.tips = self.tipsArray
            cell.setCollectionCiewData(tips: self.tipsArray, selectIndex: self.selectIndex)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case 5:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.leadingConstant.constant = 30
                cell.reviewsLabel.font = fonts.Roboto.regular.font(fontSize.medium)
                cell.reviewsLabel.text = "was your question addressed on this call?"
                cell.reviewsLabel.textColor = UIColor.darkGray
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "YesNoTableViewCell", for: indexPath) as! YesNoTableViewCell
                cell.selectionStyle = .none
                cell.yesButton.addTarget(self, action: #selector(onClickYesButton(_:)), for: .touchUpInside)
                cell.noButton.addTarget(self, action: #selector(onClickNoButton(_:)), for: .touchUpInside)
                if isAddress{
                    cell.yesButton.setTitleColor(appColor.white, for: .normal)
                    cell.noButton.setTitleColor(appColor.black, for: .normal)
                    cell.yesButton.backgroundColor = appColor.appBlueColor
                    cell.noButton.backgroundColor = appColor.white


                }else{
                    cell.noButton.setTitleColor(appColor.white, for: .normal)
                    cell.yesButton.setTitleColor(appColor.black, for: .normal)
                    cell.noButton.backgroundColor = appColor.appBlueColor
                    cell.yesButton.backgroundColor = appColor.white
                }

                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.leadingConstant.constant = 30
                cell.reviewsLabel.font = fonts.Roboto.regular.font(fontSize.medium)
                cell.reviewsLabel.text = "what question did you have for the Pro on this call?"
                cell.reviewsLabel.textColor = UIColor.darkGray
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
                return cell
            }
            
        case 6:
            if indexPath.row == self.questions.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddQuestionTableViewCell", for: indexPath) as! AddQuestionTableViewCell
                cell.selectionStyle = .none
                cell.addButton.addTarget(self, action: #selector(onClickAddQuestionButton(_:)), for: .touchUpInside)
                return cell
             }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WriteQuestionTableViewCell", for: indexPath) as! WriteQuestionTableViewCell
                let question = self.questions[indexPath.row]
                cell.aTextView.placeholder = "Write here"
                cell.selectionStyle = .none
                cell.ratingLabel.isHidden = true
                cell.aTextView.text = question.label
                cell.ratingView.rating = Float(question.rating)
                cell.aTextView.delegate = self
                cell.delegate = self
                cell.setTableViewData(index: indexPath.row)
                return cell

            }
            
            
        case 7:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.leadingConstant.constant = 30
                cell.reviewsLabel.font = fonts.Roboto.regular.font(fontSize.medium)
                cell.reviewsLabel.text = "what did you not like about the overall experience?"
                cell.reviewsLabel.textColor = UIColor.darkGray
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TempTextViewTableViewCell", for: indexPath) as! TempTextViewTableViewCell
                cell.selectionStyle = .none
                cell.aTextView.placeholder = "Write here"
                cell.aTextView.delegate = self
                cell.aTextView.text = overAllExprience
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.leadingConstant.constant = 30
                cell.reviewsLabel.font = fonts.Roboto.regular.font(fontSize.medium)
                cell.reviewsLabel.text = "what new features would you like to add to  app/experience?"
                cell.reviewsLabel.textColor = UIColor.darkGray
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TempTextViewTableViewCell", for: indexPath) as! TempTextViewTableViewCell
                cell.selectionStyle = .none
                cell.selectionStyle = .none
                cell.aTextView.placeholder = "Write here"
                cell.aTextView.delegate = self
                cell.aTextView.text = appExprience
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitTableViewCell", for: indexPath) as! SubmitTableViewCell
                cell.selectionStyle = .none
                cell.submitButton.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath)
            return cell
        }
    }
    
}


extension CallExperienceViewController:UITextViewDelegate{
   
    
    func textViewDidBeginEditing(_ textView: UITextView) {
         if let indexPath = textView.tableViewIndexPath(self.tableview) as IndexPath?{
            if indexPath.section == 2{
                if let cell = tableview.cellForRow(at: indexPath) as? TempTextViewTableViewCell{
                 if   textView == cell.aTextView{
                    review = textView.text!
                  }
                }
            }else if indexPath.section == 6{
                if let cell = tableview.cellForRow(at: indexPath) as? WriteQuestionTableViewCell{
                    if indexPath.row == questions.count{return}
                 if  textView == cell.aTextView{
                    self.questions[indexPath.row].label = textView.text!
                  }
                }

            }else if indexPath.section == 7{
                if let cell = tableview.cellForRow(at: indexPath) as? TempTextViewTableViewCell{
                    if  textView == cell.aTextView{
                    if indexPath.row == 1{
                        self.overAllExprience = textView.text!
                    }else if indexPath.row == 3{
                        self.appExprience = textView.text!
                    }
                  }
                }
            }

        }

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
         if let indexPath = textView.tableViewIndexPath(self.tableview) as IndexPath?{
            if indexPath.section == 2{
                if let cell = tableview.cellForRow(at: indexPath) as? TempTextViewTableViewCell{
                 if   textView == cell.aTextView{
                    review = textView.text!
                  }
                }
            }else if indexPath.section == 6{
                if let cell = tableview.cellForRow(at: indexPath) as? WriteQuestionTableViewCell{
                    if indexPath.row == questions.count{return}
                 if  textView == cell.aTextView{
                    self.questions[indexPath.row].label = textView.text!
                  }
                }

            }else if indexPath.section == 7{
                if let cell = tableview.cellForRow(at: indexPath) as? TempTextViewTableViewCell{
                    if  textView == cell.aTextView{
                    if indexPath.row == 1{
                        self.overAllExprience = textView.text!
                    }else if indexPath.row == 3{
                        self.appExprience = textView.text!
                    }
                  }
                }
            }

        }

    }
    
    
    func textViewDidChange(_ textView: UITextView) {
         if let indexPath = textView.tableViewIndexPath(self.tableview) as IndexPath?{
            if indexPath.section == 2{
                if let cell = tableview.cellForRow(at: indexPath) as? TempTextViewTableViewCell{
                 if   textView == cell.aTextView{
                    review = textView.text!
                  }
                }
            }else if indexPath.section == 6{
                if let cell = tableview.cellForRow(at: indexPath) as? WriteQuestionTableViewCell{
                    if indexPath.row == questions.count{return}
                 if  textView == cell.aTextView{
                    self.questions[indexPath.row].label = textView.text!
                  }
                }

            }else if indexPath.section == 7{
                if let cell = tableview.cellForRow(at: indexPath) as? TempTextViewTableViewCell{
                    if  textView == cell.aTextView{
                    if indexPath.row == 1{
                        self.overAllExprience = textView.text!
                    }else if indexPath.row == 3{
                        self.appExprience = textView.text!
                    }
                  }
                }
            }

        }

    }
    
}

extension CallExperienceViewController:AddQuestionViewControllerDelegate{
    func addQuestionViewController(viewController: UIViewController, question: String, success: Bool) {
        viewController.navigationController?.pop(true)
        if success{
            if question.isEmpty{return}
            var temp = QuestionModel()
            temp.label = question
            self.questions.append(temp)
            self.tableview.reloadData()
        }
    }
    
    
}


extension CallExperienceViewController : WriteQuestionTableViewCellDelegate{
    func writeQuestionTableViewCell(tableViewIndexPathRow: Int, success: Bool, rating: Float) {
        if success{
            self.questions[tableViewIndexPathRow].rating = Double(rating)
        }
    }

}

extension CallExperienceViewController:NKFloatRatingViewDelegate{
    func floatRatingView(_ ratingView: NKFloatRatingView, didUpdate rating: Float) {
        self.rating = Double(rating)
        self.tableview.reloadSections([1], with: .none)
    }
    
    
}

extension CallExperienceViewController:TipTableViewCellDelegate{
    func tipTableViewCellDelegate(indexpath: IndexPath, success: Bool) {
        if success{
            self.selectIndex = indexpath.item
            if self.tipsArray.count-1 == indexpath.item{
                self.setUpTipsPicker()
            }else{
                self.selectTips = self.tipsArray[indexpath.item]
                self.tableview.reloadSections([4], with: .none)
            }


        }
    }
    
    
    
}


extension CallExperienceViewController: UIPickerViewDataSource,UIPickerViewDelegate{
          ////////// set up organitionPicker View
        
            func setUpTipsPicker() {
                picker = UIPickerView.init()
                picker.delegate = self
                picker.dataSource = self
                picker.backgroundColor = UIColor.white
                picker.setValue(UIColor.black, forKey: "textColor")
                picker.autoresizingMask = .flexibleWidth
                picker.contentMode = .center
                picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
                self.view.addSubview(picker)

                toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
                let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onClickOrganitionDone(_:)))
                doneButton.tintColor = appColor.white
                let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
                let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(onClickCancel(_:)))
                cancelButton.tintColor = appColor.white
                let array = [cancelButton, spaceButton, doneButton]
                toolBar.setItems(array, animated: true)
                toolBar.barStyle = UIBarStyle.default
                toolBar.barTintColor = appColor.appBlueColor
                toolBar.tintColor = appColor.white
                self.view.addSubview(toolBar)
                
                
            }

        
            @IBAction func onClickOrganitionDone(_ sender: UIBarButtonItem){
                if self.tempArray.isEmpty {
                    self.view.endEditing(true)
                    return
                }
                self.selectTips = tempArray[picker.selectedRow(inComponent: 0)]
//                self.tipsArray.append(self.selectTips)
//                self.tipsArray.swapAt(self.tipsArray.count-1, self.tipsArray.count-2)
//                self.selectIndex = self.tipsArray.count-2
//                self.tipsArray.insert(self.selectTips, at: self.tipsArray.count-1)

                if self.tipsArray.count == 4{
                    self.tipsArray.insert(self.selectTips, at: self.tipsArray.count-1)

                }else{
                    self.tipsArray.remove(at: self.tipsArray.count-2)
                    self.tipsArray.insert(self.selectTips, at:self.tipsArray.count-1 )
                }
                self.selectIndex = self.tipsArray.count-2
                toolBar.removeFromSuperview()
                picker.removeFromSuperview()
//                self.tableview.reloadData()
               self.tableview.reloadSections([4], with: .none)
            }

        
        
        @IBAction func onClickCancel(_ sender: UIBarButtonItem){
            toolBar.removeFromSuperview()
            picker.removeFromSuperview()

        }
        
        

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
              return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {

            return 60.0
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                
             return self.tempArray.count
 

            }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
                
                return self.tempArray[row]

            }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
                if self.tipsArray.isEmpty {
                    return
                }
//                self.selectTips = self.tipsArray[row]


  }
}



