//
//  ContactVerifyDetailViewController.swift
//  Forloop
//
//  Created by Tecorb on 11/03/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit

class ContactVerifyDetailViewController: UIViewController {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var otpView: VPMOTPView!
    @IBOutlet weak var otpFirstLabel: UILabel!
    @IBOutlet weak var otpSecondLabel: UILabel!
    @IBOutlet weak var otpThirdLabel: UILabel!
    @IBOutlet weak var otpFourthLabel: UILabel!
    @IBOutlet weak var otpFifthLabel: UILabel!
    @IBOutlet weak var otpSixLabel: UILabel!

    var otp = ""
    var user = User()
    var appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateViews()
        self.user = User.loadSavedUser()
        self.appDelegate?.scheduleNotification(code: otp)
        self.submitButton.isEnabled = true
        self.submitButton.alpha = 1.0
        self.toggleResend()
        self.perform(#selector(toggleResend), with: nil, afterDelay: 15)
        self.setupOTPView()
        // Do any additional setup after loading the view.
    }
    
    func setupOTPView(){
        if self.otp.isEmpty{return}
        let arr = otp.map { String($0) }
        if arr.count == 6{
            self.otpFirstLabel.text = arr[0]
            self.otpSecondLabel.text = arr[1]
            self.otpThirdLabel.text = arr[2]
            self.otpFourthLabel.text = arr[3]
            self.otpFifthLabel.text = arr[4]
            self.otpSixLabel.text = arr[5]
        }
  
    }
    


    
    
    @objc func toggleResend(){
        self.submitButton.isEnabled = !self.submitButton.isEnabled
       // self.didNotReceivedCodeLabel.alpha = (self.didNotReceivedCodeLabel.alpha == 1.0) ? 0.2 : 1.0
        self.submitButton.alpha = (self.submitButton.alpha == 1.0) ? 0.2 : 1.0
    }
    
    func decorateViews(){
        CommonClass.makeViewCircularWithRespectToHeight(self.submitButton, borderColor: .clear, borderWidth: 0)
        CommonClass.makeViewCircularWithCornerRadius(otpFirstLabel, borderColor: appColor.lightGray, borderWidth: 1, cornerRadius: 5)
        CommonClass.makeViewCircularWithCornerRadius(otpSecondLabel, borderColor: appColor.lightGray, borderWidth: 1, cornerRadius: 5)
        CommonClass.makeViewCircularWithCornerRadius(otpThirdLabel, borderColor: appColor.lightGray, borderWidth: 1, cornerRadius: 5)
        CommonClass.makeViewCircularWithCornerRadius(otpFourthLabel, borderColor: appColor.lightGray, borderWidth: 1, cornerRadius: 5)
        CommonClass.makeViewCircularWithCornerRadius(otpFifthLabel, borderColor: appColor.lightGray, borderWidth: 1, cornerRadius: 5)
        CommonClass.makeViewCircularWithCornerRadius(otpSixLabel, borderColor: appColor.lightGray, borderWidth: 1, cornerRadius: 5)

    }
    @IBAction func onClickBackButton(_ sender:UIButton){
        self.navigationController?.pop(true)
    }
    
    @IBAction func onClickSubmitButton(_ sender:UIButton){
        self.checkTwilloVerifyContact()
    }
    
    func navigateToUSerSelectOption() {
         let userRoleVC = AppStoryboard.Main.viewController(SelectUserRoleViewController.self)
         userRoleVC.isFromSignUp = true
         self.navigationController?.pushViewController(userRoleVC, animated: true)
     }
     
     
     func navigateToNextScreen(){
         if self.user.selectedRole == SelectUserRole.pro.rawValue{
             AppSettings.shared.proceedToDashboard()
         }else if  self.user.selectedRole == SelectUserRole.learner.rawValue{
             AppSettings.shared.proceedToDashboard()

             
         }else{
             AppSettings.shared.isLoggedIn = false
             let userRoleVC = AppStoryboard.Main.viewController(SelectUserRoleViewController.self)
             userRoleVC.isFromSignUp = false
             self.navigationController?.pushViewController(userRoleVC, animated: true)
            
        }

         
     }
    

    
    
    
    func checkTwilloVerifyContact(){
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            return
        }

        AppSettings.shared.showLoader(withStatus: "Loading..")
        CallTwilloService.sharedInstance.checkContactForTwillo { (code, otp, message) in
            AppSettings.shared.hideLoader()
            if code == 200{
                if self.user.selectedRole == ""{
                    self.navigateToUSerSelectOption()
                }else{
                    self.navigateToNextScreen()
                }
            }else if code == 404{
                
            }else if code == 100{
                if let verifyCode = otp{
                    self.otp = verifyCode
                    self.setupOTPView()
                    self.toggleResend()
                    self.perform(#selector(self.toggleResend), with: nil, afterDelay: 15)
                }


            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }
    }

}



