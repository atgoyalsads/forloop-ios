//
//  ResetPasswordViewController.swift
//  Forloop
//
//  Created by Tecorb on 22/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSMobileClient

class ResetPasswordViewController: UIViewController  {
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var reenterPasswordTextField : UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backView: UIView!


    var email:String!
    var otp = ""


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        self.decorateViews()
    }
    
    func decorateViews(){
        CommonClass.makeViewCircularWithCornerRadius(self.submitButton, borderColor: .clear, borderWidth: 0, cornerRadius: 25)
        CommonClass.makeCircularCornerNewMethodRadius(backView, cornerRadius: 20)

    }
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationViews()
    }


    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupNavigationViews(){
        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.makeTransparent()
    }

    @IBAction func onClickBackButton(_ sender: UIBarButtonItem){
        self.navigationController?.pop(true)
//        if let signInVC = self.navigationController?.viewControllers.filter({ (vc) -> Bool in
//            vc is ForgotPasswordViewController
//        }).first{
//            self.navigationController?.popToViewController(signInVC, animated: true)
//        }
    }

    @IBAction func onClickSubmitButton(_ sender: UIButton){
        let password = passwordTextField.text!
        let rePassword = reenterPasswordTextField.text!
        if password.isEmpty {
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Please enter password", completionBlock: {})
            return
        }
        
        if rePassword.isEmpty {
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Please enter confirm password", completionBlock: {})
            return
        }


        let validation = self.validateParams(password: password)
        if !validation.success{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: validation.message, completionBlock: {})
            return
        }
        
        if password != rePassword {
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Password and confirm password should be same", completionBlock: {})
            return
        }

        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            return
        }
        
        AppSettings.shared.showLoader(withStatus: "Resetting..")
        self.resetPassword(email: email, otp: otp, password: password)
        
    }

    func resetPassword(email:String,otp:String,password:String){
              AWSMobileClient.default().confirmForgotPassword(username: email, newPassword: password, confirmationCode: otp) { (forgotPasswordResult, error) in
                  DispatchQueue.main.async {
                    AppSettings.shared.hideLoader()
                  if let forgotPasswordResult = forgotPasswordResult {
                      switch(forgotPasswordResult.forgotPasswordState) {
                      case .done:                          
                          NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Password changed successfully", completionBlock: {
                              if let signInVC = self.navigationController?.viewControllers.filter({ (vc) -> Bool in
                                  vc is LoginViewController
                              }).first{
                                  self.navigationController?.popToViewController(signInVC, animated: false)
                              }
                          })
                      default:
                          print_debug("Error: Could not change password.")
                      }
                  } else if let error = error {
                      if let Error = error as? AWSMobileClientError {
                          NKToastHelper.sharedInstance.showErrorAlert(self, message: "\(Error)")
                      }
                  }
              }
          }
          
    }

    func validateParams(password:String) -> (success:Bool,message:String){
        let passwordValidation = CommonClass.validatePassword(password)
        if !passwordValidation{
            return (false,warningMessage.validPassword.rawValue)
        }
        return (true,"")
    }

}
