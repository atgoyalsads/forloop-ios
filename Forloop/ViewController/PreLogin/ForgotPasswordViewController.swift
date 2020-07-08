//
//  ForgotPasswordViewController.swift
//  Forloop
//
//  Created by Tecorb on 22/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSMobileClient

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailView: UIView!



    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.setStatusBar(backgroundColor: appColor.backgroundAppColor)


    }
    override func viewWillLayoutSubviews() {

        self.decorateViews()
        
    }
    
    
    
   func setStatusBar(backgroundColor: UIColor) {
          if #available(iOS 13, *)
          {
              let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
              statusBar.backgroundColor = backgroundColor
              UIApplication.shared.keyWindow?.addSubview(statusBar)
          } else {
             // ADD THE STATUS BAR AND SET A CUSTOM COLOR
             let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
             if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = backgroundColor
             }
             UIApplication.shared.statusBarStyle = .lightContent
          }
      }
    

    func decorateViews(){
        CommonClass.makeViewCircularWithRespectToHeight(self.submitButton, borderColor: .clear, borderWidth: 0)
        CommonClass.makeViewCircularWithRespectToHeight(self.emailTextField, borderColor: .clear, borderWidth: 0)
        CommonClass.makeCircularCornerNewMethodRadius(emailView, cornerRadius: 20)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
         
     }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func otpSendToEmail(email:String){
        AppSettings.shared.showLoader(withStatus: "Loading..")
        AWSMobileClient.default().forgotPassword(username: email) { (forgotPasswordResult, error) in
            DispatchQueue.main.async {
                AppSettings.shared.hideLoader()
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .confirmationCodeSent:
                    self.openOTPScreen(email: email)
                    print_debug("Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)")
                default:
                    print_debug("Error: Invalid case.")
                }
            } else if let error = error {
                if let Error = error as? AWSMobileClientError {
                    let message = CommonClass.sharedInstance.awsBackendMessageHandel(error: Error)
                    print_debug("\(message)")
                    if message == "Username/client id combination not found."{
                        NKToastHelper.sharedInstance.showErrorAlert(self, message: "There is no account registered with this email.")

                    }else{
                        NKToastHelper.sharedInstance.showErrorAlert(self, message: message)

                    }

                }
            }
        }
    }
        
    }



    @IBAction func onClickBackButton(_ sender: UIBarButtonItem){
        self.navigationController?.pop(true)
    }
    
    @IBAction func onClickSubmitButton(_ sender: UIBarButtonItem){
        guard let email = self.emailTextField.text else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter your email")
            return
        }
        
        let validation  = self.validateParams(email: email)
        if !validation.success{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: validation.message)
            return
        }
        
        self.otpSendToEmail(email: email)

    }
    
    
        func openOTPScreen( email: String, appAction: appAction = .forgotPassword){
            let otpVC = AppStoryboard.Main.viewController(OTPVerificationViewController.self)
            otpVC.appAction = appAction
            otpVC.email = email
            self.navigationController?.pushViewController(otpVC, animated: true)
        }



    func validateParams(email:String) -> (success:Bool,message:String){
      
        if email.trimmingCharacters(in: .whitespaces).count == 0{
            return (false,"Please enter your email")
        }

        return (true,"")
    }



}



