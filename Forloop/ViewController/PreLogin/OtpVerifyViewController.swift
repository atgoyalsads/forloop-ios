//
//  OtpVerifyViewController.swift
//  Forloop
//
//  Created by Tecorb on 22/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSMobileClient


class OTPVerificationViewController: UIViewController {
    @IBOutlet weak var otpView: VPMOTPView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var resendbutton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!

    var email:String!
    var appAction:appAction!
    var otpString :String = ""
    var password:String = ""



    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(selectNotification(_:)), name: .CUSTOM_NOTIFICATION, object: nil)

        self.view.backgroundColor = appColor.backgroundAppColor
        self.setupOTPView()
        self.resendbutton.isEnabled = true
        self.resendbutton.alpha = 1.0
//        self.toggleResend()
//        self.perform(#selector(toggleResend), with: nil, afterDelay: 30)
        if self.appAction == .login{
            self.resendOtpForSignUp(confirmCode: otpString, email: email)
            
        }
        self.emailLabel.text = email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    func setupOTPView(){
        self.otpView.otpFieldFont = fonts.Roboto.medium.font(.xXXLarge)
        otpView.otpFieldSize = self.otpView.frame.size.width * 1/8
        otpView.otpFieldSeparatorSpace = 10
        otpView.otpFieldsCount = 6
        otpView.otpFieldDefaultBorderColor = .black
        otpView.otpFieldEnteredBorderColor = .black
        otpView.otpFieldBorderWidth = 2
        otpView.shouldAllowIntermediateEditing = false
        otpView.otpFieldDisplayType = .underlinedBottom
//        otpView.otpFieldDefaultBackgroundColor = appColor.blackOne
//        otpView.otpFieldEnteredBackgroundColor = appColor.blackOne
        otpView.otpFieldTextColor = appColor.appBlueColor
        otpView.cursorColor = appColor.appBlueColor
        otpView.delegate = self
        otpView.initalizeUI()

        CommonClass.makeViewCircularWithRespectToHeight(submitButton, borderColor: .clear, borderWidth: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @objc func selectNotification(_ notification:Notification) {
        self.view.endEditing(true)

    }
    
    

//    @objc func toggleResend(){
//        self.resendbutton.isEnabled = !self.resendbutton.isEnabled
//       // self.didNotReceivedCodeLabel.alpha = (self.didNotReceivedCodeLabel.alpha == 1.0) ? 0.2 : 1.0
//        self.resendbutton.alpha = (self.resendbutton.alpha == 1.0) ? 0.2 : 1.0
//    }
    
    @IBAction func onclickBackButton(_ sender : UIBarButtonItem){
        self.navigationController?.pop(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClickResend(_ sender: UIButton){
        self.otpView.initalizeUI()
         if ((self.appAction == .signUp) || (self.appAction == .login)){
            self.resendOtpForSignUp(confirmCode: otpString, email: email)
            
        }else if appAction == .forgotPassword{
            self.otpSendToEmail(email: self.email)

        }
    }

    
    func otpSendToEmail(email:String){
        AppSettings.shared.showLoader(withStatus: "Loading..")
        AWSMobileClient.default().forgotPassword(username: email) { (forgotPasswordResult, error) in
            DispatchQueue.main.async {
                AppSettings.shared.hideLoader()
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .confirmationCodeSent:
                    print("xyz")
                    //self.toggleResend()
                    //self.perform(#selector(self.toggleResend), with: nil, afterDelay: 60)

                default:
                    print("Error: Invalid case.")
                }
            } else if let error = error {
                if let Error = error as? AWSMobileClientError {
                    let message = CommonClass.sharedInstance.awsBackendMessageHandel(error: Error)
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
                }
            }
        }
     }
        
  }

    
    func verifyOTP(otp:String){
        self.view.endEditing(true)
        if ((self.appAction == .signUp) || (self.appAction == .login)){
            self.confirmSignUpUserForAws(confirmCode: otp, email: email)
            self.otpView.initalizeUI()

            
        }else if appAction == .forgotPassword{
            self.otpView.removeResponder()
            let resetPasswordVC = AppStoryboard.Main.viewController(ResetPasswordViewController.self)
            resetPasswordVC.otp = otp
            resetPasswordVC.email = email
            self.navigationController?.pushViewController(resetPasswordVC, animated: true)
        }
    }
    
    
    func resendOtpForSignUp(confirmCode:String,email:String){
        
        AppSettings.shared.showLoader(withStatus: "Loading..")

        AWSMobileClient.default().resendSignUpCode(username: email, completionHandler: { (result, error) in
            DispatchQueue.main.async {
            AppSettings.shared.hideLoader()
            if let signUpResult = result {
                print_debug("A verification code has been sent via \(signUpResult.codeDeliveryDetails!.deliveryMedium) at \(signUpResult.codeDeliveryDetails!.destination!)")
            } else if let error = error {
                if let Error = error as? AWSMobileClientError {
                    let message = CommonClass.sharedInstance.awsBackendMessageHandel(error: Error)
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
                }
                print("\(error.localizedDescription)")
            }
        }
        })
    }
    
    
    func confirmSignUpUserForAws(confirmCode:String,email:String){
        AppSettings.shared.showLoader(withStatus: "Loading")
        AWSMobileClient.default().confirmSignUp(username: email, confirmationCode: confirmCode) { (signUpResult, error) in
            DispatchQueue.main.async {

            if let signUpResult = signUpResult {
                switch(signUpResult.signUpConfirmationState) {
                case .confirmed:
                    self.registerWithSignUp()
                case .unconfirmed:
                    AppSettings.shared.hideLoader()

                    NKToastHelper.sharedInstance.showErrorAlert(self, message: "User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                case .unknown:
                    AppSettings.shared.hideLoader()

                    print_debug("Unexpected case")
                }
            } else if let error = error {
                AppSettings.shared.hideLoader()
                if let Error = error as? AWSMobileClientError {
                    let message = CommonClass.sharedInstance.awsBackendMessageHandel(error: Error)
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
                }
                print("\(error.localizedDescription)")
            }
        }
      }
    }
    
     func registerWithSignUp(){
        
         if !AppSettings.isConnectedToNetwork{
             NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
             return
         }
         AppSettings.shared.showLoader(withStatus: "Loading..")
         var params = Dictionary<String,String>()
         params.updateValue(email, forKey: "email")
         params.updateValue(password, forKey: "password")
         LogInService.sharedInstance.registerWith(params) { (success, resUser, message) in
             AppSettings.shared.hideLoader()
             if success{
                self.view.endEditing(true)
                NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Registration Successful. Please login with your new UserID & Password", completionBlock: {
                        if let signInVC = self.navigationController?.viewControllers.filter({ (vc) -> Bool in
                            vc is LoginViewController
                        }).first{
                            self.navigationController?.popToViewController(signInVC, animated: false)
                        }
                    })

             }else{
             NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: message, completionBlock: nil)
             }
         }
    
     }
     
    
    @IBAction func onClickSubmitButtton(_ sender: UIButton) {
        if self.otpString.count < 6{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Please enter 6 digit code")
        }else{
            self.verifyOTP(otp: self.otpString)

        }
    }


}


extension OTPVerificationViewController: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        if hasEntered{
            self.verifyOTP(otp: self.otpString)
            //self.verifyOTP(otp: self.otpString, authID: self.verificationID)
        }
        return hasEntered
    }

    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }

    func enteredOTP(otpString: String) {
        self.otpString = otpString
    }
}


////////////



