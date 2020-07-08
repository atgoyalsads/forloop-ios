//
//  AddContactVerifyViewController.swift
//  Forloop
//
//  Created by Tecorb on 11/03/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import  CountryPickerView


class AddContactVerifyViewController: UIViewController{
    @IBOutlet weak var countryCodeLabel : UILabel!
    @IBOutlet weak var phoneNumberTextField : UITextField!
    @IBOutlet weak var phoneNumberView : UIView!
    @IBOutlet weak var countryPickerView: UIView!
    @IBOutlet weak var submitButton: UIButton!

//    @IBOutlet weak var showMobileLabel: UILabel!
//    @IBOutlet weak var countryImage: UIImageView!

    var cpv : CountryPickerView!
    var selectedCountry: Country!
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User.loadSavedUser()

        self.view.backgroundColor = appColor.backgroundAppColor
        self.countryPickerSetUp()
        self.navigationController?.navigationBar.isHidden = false
        
//        self.setupNavigationViews()
        self.decorateViews()
    }
    override func viewWillLayoutSubviews() {

        self.decorateViews()
    }

    func decorateViews(){
        CommonClass.makeViewCircularWithRespectToHeight(self.submitButton, borderColor: .clear, borderWidth: 0)
        CommonClass.makeViewCircularWithRespectToHeight(self.phoneNumberView, borderColor: .clear, borderWidth: 0)

        
    }


    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.navigationBar.isHidden = true
        
    }


    override func viewDidAppear(_ animated: Bool) {
       // self.setupNavigationViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onClickBackButton(_ sender: UIBarButtonItem){
        self.navigationController?.pop(true)
    }

    @IBAction func onClickCountryCodeButton(_ sender: UIButton){
        cpv.showCountriesList(from: self)
    }

    @IBAction func onClickSubmitButton(_ sender: UIButton){
        
        let countryCode = self.selectedCountry.phoneCode

        guard let phoneNumber = phoneNumberTextField.text else {
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Please enter mobile number", completionBlock: {})
            return
        }

        let validation = self.validateParams(countryCode: countryCode, phoneNumber: phoneNumber)
        if !validation.success{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: validation.message, completionBlock: {})
            return
        }
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.networkIsNotConnected.rawValue, completionBlock: {})
        }
        //self.checkTwilloVerifyContact()
        self.updateTwilloVerifyContact(countryCode: countryCode, contact: phoneNumber)
        

    }
    
    func updateTwilloVerifyContact(countryCode:String,contact:String){
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            return
        }

        AppSettings.shared.showLoader(withStatus: "Loading..")
        CallTwilloService.sharedInstance.updateContactForTwillo(countryCode: countryCode, contact: contact) { (code, otp, message) in

            AppSettings.shared.hideLoader()
            if code == 200{
                if let temp = otp{
                    self.navigateToContactVerifyScreen(otp: temp)
                }

            }else if code == 404{
                self.navigateToUSerSelectOption()
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }
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
    
    func navigateToContactVerifyScreen(otp:String){
        let twilloOpt = AppStoryboard.Contact.viewController(ContactVerifyDetailViewController.self)
        twilloOpt.otp = otp
        self.navigationController?.pushViewController(twilloOpt, animated: true)
    }
    




    func validateParams(countryCode:String,phoneNumber: String) -> (success:Bool,message:String){
        if countryCode.trimmingCharacters(in: .whitespaces).count == 0{
            return (false,"Please enter country code")
        }

        if phoneNumber.trimmingCharacters(in: .whitespaces).count == 0{
            return (false,"Please enter your mobile number")
        }

        let phoneValidation = CommonClass.validatePhoneNumber(phoneNumber.trimmingCharacters(in: .whitespaces))
        if !phoneValidation{
            return (false,"Please enter a valid mobile number")
        }

        if (phoneNumber.trimmingCharacters(in: .whitespaces).count < self.selectedCountry.minDigit){
            return (false,"Mobile number should not be less than" + " \(self.selectedCountry.minDigit) " + " in length")
        }

        if  (phoneNumber.trimmingCharacters(in: .whitespaces).count > self.selectedCountry.maxDigit){
            return (false,"Mobile number should not be more than" + " \(self.selectedCountry.maxDigit) " + " in length")
        }

        return (true,"")
    }


}


extension AddContactVerifyViewController: CountryPickerViewDataSource,CountryPickerViewDelegate{

    func countryPickerSetUp() {
        if cpv != nil{
            cpv.removeFromSuperview()
        }
        cpv = CountryPickerView(frame: self.countryPickerView.frame)
        self.countryPickerView.addSubview(cpv)
        cpv.countryDetailsLabel.font = fonts.Roboto.regular.font(.medium)
//        cpv.setCountryByPhoneCode("+251")
        cpv.showPhoneCodeInView = true
        cpv.showCountryCodeInView = true
        cpv.countryDetailsLabel.textColor = UIColor.clear

        //cpv.showCountryFlagInView = false
        cpv.dataSource = self
        cpv.delegate = self
        cpv.translatesAutoresizingMaskIntoConstraints = false
        let topConstraints = NSLayoutConstraint(item: cpv as Any, attribute: .top, relatedBy: .equal, toItem: self.countryPickerView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraints = NSLayoutConstraint(item: cpv as Any, attribute: .bottom, relatedBy: .equal, toItem: self.countryPickerView, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraints = NSLayoutConstraint(item: cpv as Any, attribute: .leading, relatedBy: .equal, toItem: self.countryPickerView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraints = NSLayoutConstraint(item: cpv as Any, attribute: .trailing, relatedBy: .equal, toItem: self.countryPickerView, attribute: .trailing, multiplier: 1, constant: 0)
        self.countryPickerView.addConstraints([topConstraints,leadingConstraints,trailingConstraints,bottomConstraints])
        self.selectedCountry = cpv.selectedCountry
        self.countryCodeLabel.text = self.selectedCountry.phoneCode
//        self.countryImage.image = self.selectedCountry.flag
    }
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return (AppSettings.shared.currentCountryCode.count != 0) ? "Current" : nil
    }

    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }

    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select Country"
    }

    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        return nil

        //        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: nil, action: nil)
        //        barButton.tintColor = appColor.blue
        //        return barButton
    }

    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .navigationBar
    }


    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.selectedCountry = country
        self.countryCodeLabel.text = self.selectedCountry.phoneCode
//        self.countryImage.image = self.selectedCountry.flag

        //self.phoneNumberTextField.becomeFirstResponder()
    }


    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        if let currentCountry = countryPickerView.getCountryByPhoneCode(AppSettings.shared.currentCountryCode){
            return [currentCountry]
        }else{
            return [countryPickerView.selectedCountry]
        }
    }

    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }


}

