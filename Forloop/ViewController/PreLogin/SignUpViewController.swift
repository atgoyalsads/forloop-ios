//
//  SignUpViewController.swift
//  Forloop
//
//  Created by Tecorb on 04/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognitoIdentityProvider
import AWSMobileClient
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn





class SignUpViewController: UIViewController {
    @IBOutlet weak var aTableView:UITableView!
    
    var height:[CGFloat] = [90,400,190,220]
    var email="";var password="";var confirmPassword="";
    var user = User()
    var isToggle:Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
           identityPoolId:"us-west-2:5d417312-5c5b-4331-8a72-da232fe416f5")

        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        self.view.backgroundColor = appColor.backgroundAppColor
        
        self.view.backgroundColor = appColor.backgroundAppColor
        self.aTableView.backgroundColor = .clear
        self.registerCells()
        googleSignSetup()
        setNeedsStatusBarAppearanceUpdate()
        

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func onClickBackButton(_ sender:Any) {
        self.navigationController?.pop(true)
    }
    
    
    
    
    func registerCells() {
        let socailAuthlNib = UINib(nibName: "SocialAuthTableViewCell", bundle: nil)
        self.aTableView.register(socailAuthlNib, forCellReuseIdentifier: "SocialAuthTableViewCell")
        let submitNib = UINib(nibName: "SubmitButtonTableViewCell", bundle: nil)
        self.aTableView.register(submitNib, forCellReuseIdentifier: "SubmitButtonTableViewCell")
        let signUpUserNib = UINib(nibName: "SignUpUserTableViewCell", bundle: nil)
        self.aTableView.register(signUpUserNib, forCellReuseIdentifier: "SignUpUserTableViewCell")
        let headerNib = UINib(nibName: "LoginHeaderCell", bundle: nil)
        self.aTableView.register(headerNib, forCellReuseIdentifier: "LoginHeaderCell")

        self.aTableView.dataSource = self
        self.aTableView.delegate = self
        self.aTableView.reloadData()
    }
    
    @IBAction func onClickLoginButton(_ sender:UIButton) {
        self.navigationController?.pop(true)

    }
    
    @IBAction func onClickselectCondition(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        self.isToggle = sender.isSelected

    }
    
    @IBAction func onClickSignUpButton(_ sender:UIButton) {
        let validation = self.validateParams(email: email, password: password, confirmPassword: confirmPassword)
        if !validation.success{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: validation.message, completionBlock: nil)
            return
        }
        if self.isToggle{
            self.newRegisterWithAws()
        }else{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "You should agree to the QANSD User Aggrement, Privacy Policy, and Cookie Policy")

        }

    }

    
    
    func newRegisterWithAws(){
        var params = Dictionary<String,String>()
        params.updateValue(email, forKey: "email")
//        params.updateValue("", forKey: "name")


        AppSettings.shared.showLoader(withStatus: "Loading..")
        AWSMobileClient.default().signUp(username: email,password: password,userAttributes: params) { (signUpResult, error) in
            
            DispatchQueue.main.async {
                AppSettings.shared.hideLoader()
            if let signUpResult = signUpResult {

                switch(signUpResult.signUpConfirmationState) {
                case .confirmed:
                    print_debug("User is signed up and confirmed.")
                case .unconfirmed:
                        self.navigateToOtpScreen()
                
                case .unknown:
                    print_debug("Unexpected case")
                }
            } else if let error = error {
                if let Error = error as? AWSMobileClientError {
                    let message = CommonClass.sharedInstance.awsBackendMessageHandel(error: Error)
                    print_debug("\(message)")
                    if message == "User already exists" {
                        NKToastHelper.sharedInstance.showErrorAlert(self, message: "Another account is already registered with this email.")

                    }else{
                        NKToastHelper.sharedInstance.showErrorAlert(self, message: message)

                    }
                }
            }
          }
        }
    }
    
    
//    func getIdentityID(){
//        AWSMobileClient.default().initialize { (userState, error) in
//                    if let userState = userState {
//                        print("UserState (AccountView): \(userState.rawValue)")
//                    } else if let error = error {
//                        print("error: \(error.localizedDescription)")
//                    }
//                }
//
////                // Retrieve your Amazon Cognito ID
//        AWSMobileClient.default().getIdentityId().continueWith { task in
//                            if let error = task.error {
//                                print("error: \(error.localizedDescription) \((error as NSError).userInfo)")
//                                print(error)
//                            }
//                            if let result = task.result {
//                                print("identity id: \(result)")
//                            }
//                            return nil
//                        }
//
//    }
    
    func socialAuthWithAws(type:String){
        AWSMobileClient.default().signOut()
        
        var token = ""
        if type == "google"{
            if (GIDSignIn.sharedInstance().currentUser != nil) {
                 token = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
                // Use accessToken in your URL Requests Header
            }

        }else if type == "facebook"{
         token = AccessToken.current!.tokenString
        }
        //if token.isEmpty{return}
        let id = "us-west-2:5d417312-5c5b-4331-8a72-da232fe416f5"//AWSMobileClient.default().identityId
        AWSMobileClient.default().federatedSignIn(providerName: IdentityProvider.google.rawValue, token: token,federatedSignInOptions: FederatedSignInOptions(cognitoIdentityId: id)) { (userState, error) in
            DispatchQueue.main.async {

            if let error = error as? AWSMobileClientError {
                print(error.localizedDescription)
            }
            if let userState = userState {
                print("Status: \(userState.rawValue)")
                print("\(AWSMobileClient.default().username)")
            }
          }
        }

    }
    
    
    
    
    
    
    func navigateToOtpScreen(){
        let otpVC = AppStoryboard.Main.viewController(OTPVerificationViewController.self)
        otpVC.email = self.email
        otpVC.appAction = .signUp
        otpVC.password = self.password
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
        
    
    func validateParams(email:String,password:String,confirmPassword:String) -> (success:Bool,message:String) {
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
        if confirmPassword == ""{
            return (success:false,message:"Confirm password can't be empty")
        }
        if password != confirmPassword {
            return (success:false,message:"Please enter matching passwords")

        }
        
        
        return (true,"")

       
    }
    
    

}

extension SignUpViewController:UITableViewDataSource,UITableViewDelegate{
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
        cell.titleLabel.text = "Sign Up"
        cell.titleDescription.text = "Enter your details to complete the registration"
        return cell
        
    }
    
    func loginUserCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpUserTableViewCell", for: indexPath) as! SignUpUserTableViewCell
        cell.selectConditionButton.addTarget(self, action: #selector(onClickselectCondition(_:)), for: .touchUpInside)
        
        cell.emailTextField.keyboardType = .emailAddress
        cell.emailTextField.isSecureTextEntry = false
        cell.emailTextField.text = email
        cell.emailTextField.autocapitalizationType = .none

        cell.passwordTextField.keyboardType = .default
        cell.passwordTextField.isSecureTextEntry = true
        cell.passwordTextField.text = password
        cell.passwordTextField.autocapitalizationType = .none
        
        cell.confirmPasswordTextField.keyboardType = .default
        cell.confirmPasswordTextField.isSecureTextEntry = true
        cell.confirmPasswordTextField.text = password
        cell.confirmPasswordTextField.autocapitalizationType = .none

        cell.emailTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        cell.emailTextField.delegate = self
        cell.passwordTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        cell.passwordTextField.delegate = self
        
        cell.confirmPasswordTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        cell.confirmPasswordTextField.delegate = self
        
        return cell
        
    }
    
    
    func submitButtonTableViewCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitButtonTableViewCell", for: indexPath) as! SubmitButtonTableViewCell
        cell.loginButton.setTitle("SIGN UP", for: .normal)
        cell.alreadyAccoutLoginButton.addTarget(self, action: #selector(onClickLoginButton(_:)), for: .touchUpInside)
        cell.loginButton.addTarget(self, action: #selector(onClickSignUpButton(_:)), for: .touchUpInside)
        cell.notAccountSignUpButton.isHidden = true
        return cell
        
    }
    
    func socialAuthTableViewCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialAuthTableViewCell", for: indexPath) as! SocialAuthTableViewCell
        cell.facebookButton.addTarget(self, action: #selector(onClickFacebookButton(_:)), for: .touchUpInside)
        cell.gmailButton.addTarget(self, action: #selector(onClickGoogleButton(_:)), for: .touchUpInside)
        cell.amazonkButton.addTarget(self, action: #selector(onClickAmazonButton(_:)), for: .touchUpInside)
        cell.showLabel.text = "Sign Up using existing accounts with"
        return cell
        
    }
    
    
    
    @IBAction func onClickFacebookButton(_ sender:UIButton){
        self.loginWithFacebook()
//        
//                AWSMobileClient.default().signOut()
//                let hostedUIOptions = HostedUIOptions(scopes: ["openid", "email"], identityProvider: "Facebook")
//
//                AWSMobileClient.default().showSignIn(navigationController: self.navigationController!, hostedUIOptions: hostedUIOptions) { (userState, error) in
//                    DispatchQueue.main.async {
//
//                    if let error = error as? AWSMobileClientError {
//                        print(error.localizedDescription)
//                    }
//                    if let userState = userState {
//                        print("Status: \(userState.rawValue)")
//                    }
//                }
//            }


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
       // GIDSignIn.sharedInstance().signIn()
    }
    
    
    func getAccessData(){
                        let request = AWSCognitoIdentityProviderAdminAddUserToGroupRequest()
                        request?.groupName = "us-west-2_7BKdwAKgn_Google"
                        request?.userPoolId = "us-west-2_7BKdwAKgn"
                        request?.username = AWSMobileClient.default().username
                        AWSCognitoIdentityProvider.default().adminAddUser(toGroup: request!).continueWith { (task) -> Any? in
                            DispatchQueue.main.async {
                                if let error = task.error {
                                    print("\(error.localizedDescription)")
                                }
                                print(">>>>>>\(String(describing: task.result))")
        
                            }
                        }
        
    }
    
    @IBAction func onClickAmazonButton(_ sender:UIButton){

//         NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)
            let hostedUIOptions = HostedUIOptions(scopes: ["profile" , "postalCode"], identityProvider: "Amazon")

            AWSMobileClient.default().showSignIn(navigationController: self.navigationController!) { (userState, error) in
                DispatchQueue.main.async {

                if let error = error as? AWSMobileClientError {
                    print(error.localizedDescription)
                }

                if let userState = userState {
                    print("Status: \(userState.rawValue)")
                }
            }
        }
     }

    
}


extension SignUpViewController:SelectUserRoleViewControllerDelegate{
    func selectUser(_ viewController: SelectUserRoleViewController, didSelectIndex: Int, didSuccess success: Bool) {
        viewController.dismiss(animated: true, completion: nil)
        if success{
            let addProfileVC = AppStoryboard.Main.viewController(UserAddProfilePictureViewController.self)
            self.navigationController?.pushViewController(addProfileVC, animated: true)
        }
    }
    
    
}



extension SignUpViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let indexPath = textField.tableViewIndexPath(self.aTableView) as IndexPath?{
            if let cell = aTableView.cellForRow(at: indexPath) as? SignUpUserTableViewCell{
                if  textField == cell.emailTextField{
                        email = textField.text!
                        
                    }else if textField == cell.passwordTextField {
                        password = textField.text!

                }else if textField == cell.confirmPasswordTextField{
                    confirmPassword = textField.text!
                }
            }
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let indexPath = textField.tableViewIndexPath(self.aTableView) as IndexPath?{
            if let cell = aTableView.cellForRow(at: indexPath) as? SignUpUserTableViewCell{
                if  textField == cell.emailTextField{
                        email = textField.text!
                        
                    }else if textField == cell.passwordTextField {
                        password = textField.text!

                }else if textField == cell.confirmPasswordTextField{
                    confirmPassword = textField.text!
                }
            }
            
        }
    }
    
    @objc  func textDidChanged(_ textField: UITextField) -> Void {
        if let indexPath = textField.tableViewIndexPath(self.aTableView) as IndexPath?{
            if let cell = aTableView.cellForRow(at: indexPath) as? SignUpUserTableViewCell{
                if  textField == cell.emailTextField{
                        email = textField.text!
                        
                    }else if textField == cell.passwordTextField {
                        password = textField.text!

                }else if textField == cell.confirmPasswordTextField{
                    confirmPassword = textField.text!
                }
            }
            
        }
    }
}



extension SignUpViewController: GIDSignInDelegate{
    
    func googleSignSetup(){
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance().clientID = kGoogleClientId
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            var profileImageUrl = ""
            guard let userId = user.userID as String? else{
                NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Didn't get your userId,Please review your profile!", completionBlock: {})
                return
            }
            guard let name = user.profile.name as String? else{
                NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Didn't get your name,Please review your profile!", completionBlock: {})
                return
            }
            guard let email = user.profile.email as String? else{
                NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Didn't get your email,Please review your profile!", completionBlock: {})
                return
            }
            if let profilePicUrl = user.profile.imageURL(withDimension: 400).absoluteString as String?{
                profileImageUrl = profilePicUrl
            }
            
            //AppSettings.shared.showError(withStatus: "Fetching..")
            //self.socialLoginWith(email, providerID: userId, providerType: .google, userName: name)
            self.socialAuthWithAws(type: "google")
        } else {
            print_debug("\(error.localizedDescription)")
        }

    }

     public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {

    }


    func loginWithFacebook(){
         if !AppSettings.isConnectedToNetwork{
             NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.networkIsNotConnected.rawValue, completionBlock: {})
             return
         }

     let login = LoginManager()
    // login.loginBehavior = LoginBehavior
     login.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
         if error != nil{
             print_debug("Error ======>  \(error.debugDescription)")
         }else if (result?.isCancelled )!{
         }else{
             //CommonClass.showLoader(withStatus: "Fetching")
             GraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, picture.type(large), email, name, id, gender"]).start(completionHandler: { (connection, response, error) in
                 AppSettings.shared.hideLoader()

                 if error != nil{
                     print_debug("Error ======>  \(error.debugDescription)")
                 }else{
                     if let result = response as AnyObject?{
                        
                         var profileImageUrl = "" ;

                         guard let userId = result.value(forKeyPath: "id") as! String? else{
                             NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Didn't get your userId,Please review your profile!", completionBlock: {})
                             return
                         }

                         guard let firstName = result.value(forKeyPath:"first_name") as? String else{
                             NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Didn't get your name,Please review your profile!", completionBlock: {})
                             return
                         }
                         guard let lastName = result.value(forKeyPath:"last_name") as? String else{
                             NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Didn't get your name,Please review your profile!", completionBlock: {})
                             return
                         }
//                         guard let email = result.value(forKeyPath:"email") as? String else{
//                             NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Didn't get your email,Please review your profile!", completionBlock: {})
//                             return
//                         }
//                         if let profilePicUrl = result.value(forKeyPath:"picture.data.url") as? String{
//                             profileImageUrl = profilePicUrl
//                         }
                        
                        self.socialAuthWithAws(type: "facebook")
                         //self.socialLoginWith(email, providerID: userId, providerType: .facebook, userName: "\(firstName) \(lastName)")

                     }
                 }
             })
         }
       }
     }
}







