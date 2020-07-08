//
//  SelectUserRoleViewController.swift
//  Forloop
//
//  Created by Tecorb on 10/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit


protocol SelectUserRoleViewControllerDelegate {
    func selectUser(_ viewController: SelectUserRoleViewController,didSelectIndex:Int ,didSuccess success:Bool)
}

class SelectUserRoleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var aTableView: UITableView!
    @IBOutlet weak var showSelectPaymentLabel:UILabel!
    @IBOutlet weak var submitButton:UIButton!

    
    var selectedIndex: Int = 0

    var delegate : SelectUserRoleViewControllerDelegate?
    var isFromSignUp:Bool = false
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "Select User Role".uppercased()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.aTableView.backgroundColor = .clear
        self.aTableView.dataSource = self
        self.aTableView.delegate = self
        self.submitButton.setTitle("DONE", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(submitButton, borderColor: .clear, borderWidth: 0)
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else{return}
//        guard let touchedView = touch.view else{return}
//        if touchedView == self.view{
//            dismiss(animated: true, completion: nil)
//        }
//    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectDefaultPayCell", for: indexPath) as! SelectDefaultPayCell
        cell.selectButton.isSelected = (self.selectedIndex == indexPath.row)
        if indexPath.row == 0 {
            cell.selectLabel.text = "Pro"
            
        }else{
            cell.selectLabel.text = "Seeker"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
       aTableView.reloadData()
    }

    
    @IBAction func onClickSubmitButton(_ sender:UIButton) {
        if selectedIndex == 0{
            AppSettings.shared.isLoggedIn = false
            self.selectUserRole(role: SelectUserRole.pro.rawValue)

        }else{
            AppSettings.shared.isLoggedIn = false

            self.selectUserRole(role: SelectUserRole.learner.rawValue)

        }


    }
    
    func selectUserRole(role:String){
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            return
        }

        AppSettings.shared.showLoader(withStatus: "Loading..")
        LogInService.sharedInstance.selectUserRole(role) { (success, resUser,message) in
            AppSettings.shared.hideLoader()
            if success{
                if let aUser = resUser{
                    self.user = aUser
                    if self.isFromSignUp{
                        self.afterSignUpUserStatus()
                    }else{
                        if role == SelectUserRole.learner.rawValue{
                            self.afterLoginLearnerGetDetailStatus()
                        }else{
                            self.afterLoginGetProDetailStatus()
                        }
                    }

                }else{
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: message)

                }
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }
        
        
    }
    
    
    func afterLoginLearnerGetDetailStatus(){
        if !self.user.proUserStatus.isDisplayName{
            let addProfileVC = AppStoryboard.Learner.viewController(LearnerDisplayNameViewController.self)
            self.navigationController?.pushViewController(addProfileVC, animated: true)
            
        }else if !self.user.proUserStatus.isDetails{
            let awsSecondVc = AppStoryboard.Learner.viewController(LearnerEditProfileViewController.self)
            self.navigationController?.pushViewController(awsSecondVc, animated: true)
            
        }
        else{
            AppSettings.shared.proceedToDashboard()
            
        }
        
    }
    
    
    func afterLoginGetProDetailStatus(){
        if !self.user.proUserStatus.isDisplayName{
            let addProfileVC = AppStoryboard.Main.viewController(UserAddProfilePictureViewController.self)
            self.navigationController?.pushViewController(addProfileVC, animated: true)
            
        }else if !self.user.proUserStatus.isDetails{
            let awsSecondVc = AppStoryboard.Main.viewController(UserDetailViewController.self)
            self.navigationController?.pushViewController(awsSecondVc, animated: true)
          
        }else if !self.user.proUserStatus.isLinks{
            let awsSecondVc = AppStoryboard.Main.viewController(AWSLinkViewController.self)
            self.navigationController?.pushViewController(awsSecondVc, animated: true)
            
        }
        else if !self.user.proUserStatus.isSubcategories{
            
            let categoryVC = AppStoryboard.Main.viewController(SelectCategoriesViewController.self)
            self.navigationController?.pushViewController(categoryVC, animated: true)
            
        }
        else{
            AppSettings.shared.proceedToDashboard()

        }
        
    }
    
    func afterSignUpUserStatus(){
        if self.user.selectedRole == SelectUserRole.pro.rawValue{
            let addProfileVC = AppStoryboard.Main.viewController(UserAddProfilePictureViewController.self)
            self.navigationController?.pushViewController(addProfileVC, animated: true)
        } else if self.user.selectedRole == SelectUserRole.learner.rawValue{
            let addProfileVC = AppStoryboard.Learner.viewController(LearnerDisplayNameViewController.self)
            self.navigationController?.pushViewController(addProfileVC, animated: true)
        }else{
            AppSettings.shared.proceedToDashboard()

        }

    }
    
    
    
    
    
    
    @IBAction func onClickCancekButton(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    

}
