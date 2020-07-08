//
//  AWSLinkViewController.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 08/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit

class AWSLinkViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var heightOfRows:[CGFloat] = [70,160]
    var blogger = ""
    var insta = ""
    var linkedIn = ""
    var pinterest = ""
    var isSentToNextScreen:Bool = false
    var isEdit:Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColor.backgroundAppColor

        self.registerCells()
        if isEdit{
            self.setPreviousUserData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.navigationController?.navigationBar.isHidden =  true
    }
    
    func registerCells() {
            let getStartedCellNib = UINib(nibName: "GetStartedTableViewCell", bundle: nil)
            self.tableview.register(getStartedCellNib, forCellReuseIdentifier: "GetStartedTableViewCell")
            let enterLinkTableViewCellnib = UINib(nibName: "EnterLinkTableViewCell", bundle: nil)
            self.tableview.register(enterLinkTableViewCellnib, forCellReuseIdentifier: "EnterLinkTableViewCell")
            let nextCellnib = UINib(nibName: "NextPreviousButtonTableViewCell", bundle: nil)
            self.tableview.register(nextCellnib, forCellReuseIdentifier: "NextPreviousButtonTableViewCell")
            tableview.delegate = self
            tableview.dataSource = self
        }
    

    func setPreviousUserData(){
        let user = User.loadSavedUser()

        self.insta = user.linkInstagram
        self.blogger = user.linkBlogger
        self.linkedIn = user.linkLinkedin
        self.pinterest = user.linkPinterest
        self.tableview.reloadData()
    }
        
        @IBAction func backTapped(_ sender: Any) {
            self.navigationController?.pop(true)
        }
        
        @IBAction func nextTapped(_ sender: Any) {
            let user = User.loadSavedUser()
            if blogger == "" && insta == "" && linkedIn == "" && pinterest == ""{
                self.isSentToNextScreen = false
            }else{
                if user.linkBlogger == blogger && user.linkInstagram == insta && user.linkLinkedin == linkedIn && user.linkPinterest == pinterest{
                    self.isSentToNextScreen = true
                }else{
                    self.isSentToNextScreen = false
                }
            }
            if isSentToNextScreen{
                self.afterLoginGetDetailStatus(user: user)

            }else{
                self.newDataUploadToAws()
            }
    }
    
    
    func newDataUploadToAws(){
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            return
        }
        AppSettings.shared.showLoader(withStatus: "Loading..")
        LogInService.sharedInstance.updateUserLinks(self.blogger, self.insta, self.linkedIn, self.pinterest) { (success,resUser,message)  in
            AppSettings.shared.hideLoader()
                 if success {
                     if let aUser = resUser{
                         self.afterLoginGetDetailStatus(user: aUser)
                     }
                 } else {
                     NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
                 }
             }

    }
    
    
    
    func afterLoginGetDetailStatus(user:User){
        if isEdit{
            let awsSecondVc = AppStoryboard.Main.viewController(CertificateViewController.self)
            awsSecondVc.isEdit = self.isEdit
            self.navigationController?.pushViewController(awsSecondVc, animated: true)
        }else{
            if !user.proUserStatus.isPrice{
            let awsSecondVc = AppStoryboard.Main.viewController(CertificateViewController.self)
            self.navigationController?.pushViewController(awsSecondVc, animated: true)
                        
            }else if !user.proUserStatus.isSubcategories{
                
            let categoryVC = AppStoryboard.Main.viewController(SelectCategoriesViewController.self)
            self.navigationController?.pushViewController(categoryVC, animated: true)
                
            }
            else{
            AppSettings.shared.proceedToDashboard()

            }
        }

        
    }
        
            func validateParams() -> (success:Bool,message:String) {
                if self.blogger != "" {
                    return (true,"")
                }
                if self.insta != ""{
                    return (true,"")
                }
                if self.linkedIn != ""{
                    return (true,"")
                }
                if self.pinterest != "" {
                    return (true,"")
                }
                return (false,"")
            }
        
            func moveToCertificate() {
                let certificateVC = AppStoryboard.Main.viewController(CertificateViewController.self)
                self.navigationController?.pushViewController(certificateVC, animated: true)
            }

    }

extension AWSLinkViewController: UITableViewDataSource, UITableViewDelegate {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch section {

                case 0:
                    return 4
                case 1:
                    return 1
                default:
                    return 1
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                let section = indexPath.section
                switch section {
                    case 0:
                        return heightOfRows[section]
                    case 1:
                        return heightOfRows[section]
                    default:
                        return 200
                }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let section = indexPath.section
            switch section {

                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EnterLinkTableViewCell") as! EnterLinkTableViewCell
                    cell.linkTextfield.delegate = self
                    cell.linkTextfield.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)

                    switch indexPath.row {
                        case 0:
                            cell.linkTextfield.placeholder = "Enter your blogger url"
                            cell.linkImage.image = UIImage(named: "blogger_icon")
                            cell.linkTextfield.text = blogger
                        case 1:
                        cell.linkTextfield.placeholder = "Enter your instagram url"

                        cell.linkImage.image = UIImage(named: "instagram_icon")
                        cell.linkTextfield.text = insta

                        case 2:
                        cell.linkTextfield.placeholder = "Enter your linkedin url"

                        cell.linkImage.image = UIImage(named: "linkedin_icon")
                        cell.linkTextfield.text = linkedIn

                        case 3:
                        cell.linkTextfield.placeholder = "Enter your pinterest url"

                        cell.linkImage.image = UIImage(named: "pinterest_icon")
                        cell.linkTextfield.text = pinterest

                        default:
                            cell.linkTextfield.placeholder = "Default"
                    }
                    cell.selectionStyle = .none
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NextPreviousButtonTableViewCell") as! NextPreviousButtonTableViewCell
                    cell.backButton.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
                    cell.nextButton.addTarget(self, action: #selector(nextTapped(_:)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GetStartedTableViewCell") as! GetStartedTableViewCell
                    cell.selectionStyle = .none
                    return cell
            }
        }
        
    }

extension AWSLinkViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let indexPath = textField.tableViewIndexPath(self.tableview) as IndexPath? {
                switch indexPath.row {
                    case 0:
                        if let bloggerLink = textField.text {
                            self.blogger = bloggerLink
                        }
                    case 1:
                        if let instaLink = textField.text {
                            self.insta = instaLink
                        }
                    case 2:
                        if let linkedLink = textField.text {
                            self.linkedIn = linkedLink
                        }
                    case 3:
                        if  let pinLink = textField.text {
                            self.pinterest = pinLink
                        }
                    default:
                        break
                }
            }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let indexPath = textField.tableViewIndexPath(self.tableview) as IndexPath? {
                switch indexPath.row {
                    case 0:
                        if let bloggerLink = textField.text {
                            self.blogger = bloggerLink
                        }
                    case 1:
                        if let instaLink = textField.text {
                            self.insta = instaLink
                        }
                    case 2:
                        if let linkedLink = textField.text {
                            self.linkedIn = linkedLink
                        }
                    case 3:
                        if  let pinLink = textField.text {
                            self.pinterest = pinLink
                        }
                    default:
                        break
                }
            }
        
    }
    
    @objc  func textDidChanged(_ textField: UITextField) -> Void {
        if let indexPath = textField.tableViewIndexPath(self.tableview) as IndexPath? {
                switch indexPath.row {
                    case 0:
                        if let bloggerLink = textField.text {
                            self.blogger = bloggerLink
                        }
                    case 1:
                        if let instaLink = textField.text {
                            self.insta = instaLink
                        }
                    case 2:
                        if let linkedLink = textField.text {
                            self.linkedIn = linkedLink
                        }
                    case 3:
                        if  let pinLink = textField.text {
                            self.pinterest = pinLink
                        }
                    default:
                        break
                }
            }
        
    }
    
}
