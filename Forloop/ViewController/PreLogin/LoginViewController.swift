//
//  LoginViewController.swift
//  Forloop
//
//  Created by Tecorb on 04/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSMobileClient
import SwiftyJSON

class LoginViewController: UIViewController {
    @IBOutlet weak var aTableView:UITableView!
    
    var height:[CGFloat] = [100,270,190,220]
    var email="";var password="";
    var user = User()
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
//    var auth: AWSCognitoAuth = AWSCognitoAuth.default()
//    var session: AWSCognitoAuthUserSession?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.aTableView.backgroundColor = .clear
        self.registerCells()
        //self.confirmLoginUser()
        // Do any additional setup after loading the view.

        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    

    
    
    func registerCells() {
        let socailAuthlNib = UINib(nibName: "SocialAuthTableViewCell", bundle: nil)
        self.aTableView.register(socailAuthlNib, forCellReuseIdentifier: "SocialAuthTableViewCell")
        let submitNib = UINib(nibName: "SubmitButtonTableViewCell", bundle: nil)
        self.aTableView.register(submitNib, forCellReuseIdentifier: "SubmitButtonTableViewCell")
        let loginUserNib = UINib(nibName: "LoginUserCell", bundle: nil)
        self.aTableView.register(loginUserNib, forCellReuseIdentifier: "LoginUserCell")
        let headerNib = UINib(nibName: "LoginHeaderCell", bundle: nil)
        self.aTableView.register(headerNib, forCellReuseIdentifier: "LoginHeaderCell")

        self.aTableView.dataSource = self
        self.aTableView.delegate = self
        self.aTableView.reloadData()
    }
    
    
    @IBAction func onClickSignUpButton(_ sender:UIButton) {


        let signUpVC = AppStoryboard.Main.viewController(SignUpViewController.self)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func onClickLoginButton(_ sender:UIButton) {
        let validation = self.validateParams(email: email, password: password)
        if !validation.success{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: validation.message)
            return
        }
        self.loginAwsUSer()


    }
    
    
    @IBAction func onClickBackButton(_ sender:UIButton) {
        self.navigationController?.pop(true)

    }
    
    
    @IBAction func onClickForgotButton(_ sender:UIButton) {

        let forgotVC = AppStoryboard.Main.viewController(ForgotPasswordViewController.self)
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
//    func congnitoPoolUserLogIn(email:String,password:String){
//            let pool = AppDelegate.defaultUserPool()
//        pool.clearAll()
//            let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: email, password: password)
//            self.passwordAuthenticationCompletion?.set(result: authDetails)
//            print("AuthDetails>>>\(String(describing: passwordAuthenticationCompletion))")
//
//
//                let user = pool.getUser((email))
//
//       // print("UserSession>>>>>>>\(user.getSession())")
//            user.getSession(email, password:password, validationData: .none).continueWith { (response) -> Any? in
//                if response.error != nil {
//                           DispatchQueue.main.async {
//
//                            print("Error>>>>>>\(response.error)")
//                        }
//                }else{
//                    DispatchQueue.main.async {
//
//                    print("Successfully>>>>>>\(response)")
//                    }
//                }
//                return nil
//            }
//
//        }
    
    
    
   func loginAwsUSer(){
    if !AppSettings.isConnectedToNetwork{
        NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
        return
    }
    AWSMobileClient.default().signOut()
    AppSettings.shared.showLoader(withStatus: "Loading..")
    AWSMobileClient.default().signIn(username: email, password: password) { (signInResult, error) in
        DispatchQueue.main.async {
            AppSettings.shared.hideLoader()
        if let error = error  {
            if let Error = error as? AWSMobileClientError {
                let message = CommonClass.sharedInstance.awsBackendMessageHandel(error: Error)
                print_debug("\(message)")

                switch message {
                case "User is not confirmed.":
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: message) {
                        self.navigateToOtpVerifyScreen()
                    }
                case "User does not exist.":
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: "There is no account registered with this email. Would you like to create a new account.")
                default:
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: message)

                }

            }
        } else if let signInResult = signInResult {
            print("\(signInResult)")

            switch (signInResult.signInState) {
            case .signedIn:
                print_debug("User is signed in.")
                self.getCurrentToken()
            case .smsMFA:
                print_debug("SMS message sent to \(signInResult.codeDetails!.destination!)")
            default:
                print_debug("Sign In needs info which is not et supported.")
            }
        }
    }
 }
}
    
   
    
    
    
    
    func getCurrentToken(){
        AWSMobileClient.default().getTokens { (tokens, error) in
            DispatchQueue.main.async {

            if let error = error {
                if let Error = error as? AWSMobileClientError {
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: "\(Error)")
                }
            } else if let tokens = tokens {
                if let sessionToken = tokens.accessToken?.tokenString{
                    AppSettings.shared.sessionToken = sessionToken
                    self.registerTokenToServer()
                }


            }
        }
    }
}
    
    
    func registerTokenToServer(){
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            return
        }

        AppSettings.shared.showLoader(withStatus: "Loading..")
        LogInService.sharedInstance.registerTokenAfterLogin(email, sessionToken: AppSettings.shared.sessionToken) { (success, resUser, message) in
            if success{
                if let aUser = resUser{
                    self.user = aUser
                    AppSettings.shared.sessionToken = self.user.sessionToken

                    self.checkTwilloVerifyContact()
                }
            }else{
                AppSettings.shared.hideLoader()

                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)

            }

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
                let twilloContact = AppStoryboard.Contact.viewController(AddContactVerifyViewController.self)
                self.navigationController?.pushViewController(twilloContact, animated: true)
                
            }else if code == 400{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message) {
                    let twilloContact = AppStoryboard.Contact.viewController(AddContactVerifyViewController.self)
                    self.navigationController?.pushViewController(twilloContact, animated: true)
                }

            }else if code == 100{
                if let temp = otp{
                    self.navigateToTwilloContactVerifyScreen(otp: temp)
                }

            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }
    }
    
    
    func navigateToTwilloContactVerifyScreen(otp:String){
        let twilloOpt = AppStoryboard.Contact.viewController(ContactVerifyDetailViewController.self)
        twilloOpt.otp = otp
        self.navigationController?.pushViewController(twilloOpt, animated: true)
    }
    

    func navigateToOtpVerifyScreen(){
        let otpVerifyVC = AppStoryboard.Main.viewController(OTPVerificationViewController.self)
        otpVerifyVC.email = email
        otpVerifyVC.appAction = .login
        otpVerifyVC.password = self.password
        self.navigationController?.pushViewController(otpVerifyVC, animated: true)
        
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
            self.navigationController?.pushViewController(userRoleVC, animated: true)        }

        
    }
    
 
    
    
    func validateParams(email:String,password:String) -> (success:Bool,message:String) {
        if email == "" {
          return (success:false,message:"Enter your Email")
        }
        if !CommonClass.validateEmail(email){
            return (false,"Please enter a valid email")
        }
        
        if password == ""{
            return (success:false,message:"Password can't be empty")
        }
        
        let passwordValidation = CommonClass.validatePassword(password)
         if !passwordValidation{
             return (false,"Please enter a valid password")
         }
        
        
        return (true,"")

       
    }
    

}

extension LoginViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return self.loginHeaderCell(tableView: tableView, indexPath: indexPath)
        case 1:
            return self.loginUserCell(tableView: tableView, indexPath: indexPath)
        case 2:
            return self.submitButtonTableViewCell(tableView: tableView, indexPath: indexPath)
        case 3:
            return self.socialAuthTableViewCell(tableView: tableView, indexPath: indexPath)
        default:
            break
        }
        return UITableViewCell()
    }
    
    
    func loginHeaderCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginHeaderCell", for: indexPath) as! LoginHeaderCell
        cell.titleLabel.text = "Login"
        cell.titleDescription.text = "Enter your email address  and password access your account"

        return cell
        
    }
    
    func loginUserCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginUserCell", for: indexPath) as! LoginUserCell
        cell.emailTextField.keyboardType = .emailAddress
        cell.emailTextField.isSecureTextEntry = false
        cell.emailTextField.text = email
        cell.emailTextField.autocapitalizationType = .none

        cell.passwordTextField.keyboardType = .default
        cell.passwordTextField.isSecureTextEntry = true
        cell.passwordTextField.text = password
        cell.passwordTextField.autocapitalizationType = .none


        cell.emailTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        cell.emailTextField.delegate = self
        cell.passwordTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        cell.passwordTextField.delegate = self
        
        cell.forgotPasswordButton.addTarget(self, action: #selector(onClickForgotButton(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    func submitButtonTableViewCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitButtonTableViewCell", for: indexPath) as! SubmitButtonTableViewCell
        cell.notAccountSignUpButton.addTarget(self, action: #selector(onClickSignUpButton(_:)), for: .touchUpInside)
        cell.loginButton.addTarget(self, action: #selector(onClickLoginButton(_:)), for: .touchUpInside)
        cell.alreadyAccoutLoginButton.isHidden = true
        
        return cell
        
    }
    
    func socialAuthTableViewCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialAuthTableViewCell", for: indexPath) as! SocialAuthTableViewCell
        cell.facebookButton.addTarget(self, action: #selector(onClickFacebookButton(_:)), for: .touchUpInside)
        cell.gmailButton.addTarget(self, action: #selector(onClickGoogleButton(_:)), for: .touchUpInside)
        cell.amazonkButton.addTarget(self, action: #selector(onClickAmazonButton(_:)), for: .touchUpInside)

        return cell
        
    }
    
    
    @IBAction func onClickFacebookButton(_ sender:UIButton){
            AWSMobileClient.default().signOut()
            let hostedUIOptions = HostedUIOptions(scopes: ["openid", "email"], identityProvider: "Facebook")

            AWSMobileClient.default().showSignIn(navigationController: self.navigationController!, hostedUIOptions: hostedUIOptions) { (userState, error) in
                DispatchQueue.main.async {

                if let error = error as? AWSMobileClientError {
                    print(error.localizedDescription)
                }

                if let userState = userState {
                    print("Status: \(userState.rawValue)")
                }
            }
        }
//        NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)
    }
    
    @IBAction func onClickGoogleButton(_ sender:UIButton){
            AWSMobileClient.default().signOut()
            let hostedUIOptions = HostedUIOptions(scopes: ["email" , "openid"], identityProvider: "Google")

            AWSMobileClient.default().showSignIn(navigationController: self.navigationController!, hostedUIOptions: hostedUIOptions) { (userState, error) in
                DispatchQueue.main.async {

                if let error = error as? AWSMobileClientError {
                    print(error.localizedDescription)
                }

                if let userState = userState {
                    print("Status: \(userState.rawValue)")
                }
            }
        }
//        NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)
    }
    
    @IBAction func onClickAmazonButton(_ sender:UIButton){
         NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)
     }
    
    
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let indexPath = textField.tableViewIndexPath(self.aTableView) as IndexPath?{
            if let cell = aTableView.cellForRow(at: indexPath) as? LoginUserCell{
                if  textField == cell.emailTextField{
                        email = textField.text!
                        
                    }else if textField == cell.passwordTextField {
                        password = textField.text!

                }
            }
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let indexPath = textField.tableViewIndexPath(self.aTableView) as IndexPath?{
            if let cell = aTableView.cellForRow(at: indexPath) as? LoginUserCell{
                if  textField == cell.emailTextField{
                        email = textField.text!
                        
                    }else if textField == cell.passwordTextField {
                        password = textField.text!

                }
            }
            
        }
    }
    
    @objc  func textDidChanged(_ textField: UITextField) -> Void {
        if let indexPath = textField.tableViewIndexPath(self.aTableView) as IndexPath?{
            if let cell = aTableView.cellForRow(at: indexPath) as? LoginUserCell{
                if  textField == cell.emailTextField{
                        email = textField.text!
                        
                    }else if textField == cell.passwordTextField {
                        password = textField.text!

                }
            }
            
        }
    }
}


extension LoginViewController: AWSCognitoIdentityPasswordAuthentication {

    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
        DispatchQueue.main.async {
//            if (self.usernameInput?.text == nil) {
//                self.usernameInput?.text = authenticationInput.lastKnownUsername
//            }
        }
    }
    
    public func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if error != nil {
                let alertController = UIAlertController(title: "Cannot Login",
                                                        message: (error! as NSError).userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                alertController.addAction(retryAction)
                
                self.present(alertController, animated: true, completion:  nil)
            } else {
                self.dismiss(animated: true, completion: {
                    //self.usernameInput?.text = nil
                    //self.passwordInput?.text = nil
                })
            }
        }
    }
    
}

//extension LoginViewController:AWSCognitoAuthDelegate{
//    func getViewController() -> UIViewController {
//                return self;
//
//    }
    
//    func getCurrentToken(){
//
//            self.auth.getSession  { (session:AWSCognitoAuthUserSession?, error:Error?) in
//                if(error != nil) {
//                    self.session = nil
//                    NKToastHelper.sharedInstance.showErrorAlert(self, message: ((error! as NSError).userInfo["error"] as? String)!)
//                }else {
//                    self.session = session
//                }
//            }
//        }
    
    
    
//}

