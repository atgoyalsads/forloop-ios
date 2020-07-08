//
//  LearnerEditProfileViewController.swift
//  Forloop
//
//  Created by Tecorb on 28/03/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import CountryPickerView


class LearnerEditProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var heightOfRows:[CGFloat] = [400,100,100,160]
    var firstName = ""
    var lastName = ""
    var zipCode = ""
    var phoneNumber = ""
    var countryCode = ""
    var DOB = ""
    var gender = "Male"

     var selectedCountry: Country!
    var datePicker : UIDatePicker!
    var dobTextField: UITextField!
    var genderPicker = UIPickerView()
    var genderTextField: UITextField!
    var genderArray = ["Male","Female"]
    var isSentToNextScreen:Bool = false
    var isEdit:Bool = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.tableView.backgroundColor = .clear
        self.registerCells()
        if self.isEdit{
            self.setPreviousUserData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden =  true
    }
    
    func registerCells() {
        let getStartedCellNib = UINib(nibName: "GetStartedTableViewCell", bundle: nil)
        self.tableView.register(getStartedCellNib, forCellReuseIdentifier: "GetStartedTableViewCell")
        let userDetailCellnib = UINib(nibName: "UserDetailTextfieldsTableViewCell", bundle: nil)
        self.tableView.register(userDetailCellnib, forCellReuseIdentifier: "UserDetailTextfieldsTableViewCell")
        let nextCellnib = UINib(nibName: "NextPreviousButtonTableViewCell", bundle: nil)
        self.tableView.register(nextCellnib, forCellReuseIdentifier: "NextPreviousButtonTableViewCell")
        let phoneNumberCellnib = UINib(nibName: "UserPhoneNumberTableViewCell", bundle: nil)
        self.tableView.register(phoneNumberCellnib, forCellReuseIdentifier: "UserPhoneNumberTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        let UserAllTableViewCellNib = UINib(nibName: "UserAllTableViewCell", bundle: nil)
        self.tableView.register(UserAllTableViewCellNib, forCellReuseIdentifier: "UserAllTableViewCell")
        
    }

    func setPreviousUserData(){
        let user = User.loadSavedUser()
        self.firstName = user.fname
        self.lastName = user.lname
        self.zipCode = user.zipcode
        self.phoneNumber = user.contact
        self.DOB = user.dob
        self.gender = user.gender
        self.tableView.reloadData()

    }
    
    
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.pop(true)
    }
    
    @IBAction func nextTapped(_ sender: Any) {

        let validate = self.validateParams()
        if validate.success {
            self.newDataUploadToServer()

        } else {
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: validate.message, completionBlock: nil)
            return
        }
    }
    
    
    func newDataUploadToServer(){
        
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            return
        }
        AppSettings.shared.showLoader(withStatus: "Loading..")
        let code = ""//self.selectedCountry.phoneCode
        LogInService.sharedInstance.updateUserDetails(fName: self.firstName, lName: self.lastName, zipcode: self.zipCode, phoneNumber: self.phoneNumber, countryCode: code, dob: self.DOB, gender: self.gender) { (success,resUser ,message)  in
            AppSettings.shared.hideLoader()
            if success {
                if let aUser = resUser{
                    self.afterLoginGetDetailStatus(user: aUser)
                }
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: message, completionBlock: nil)
            }
        }
    }
    
    
    
    func afterLoginGetDetailStatus(user:User){
                AppSettings.shared.proceedToDashboard()
        
    }
    
    
    func validateParams() -> (success:Bool,message:String) {
        if self.firstName == "" {
          return (success:false,message:"Please enter first name")
        }
        if self.lastName == ""{
            return (success:false,message:"Please enter last name")
        }
        if self.zipCode == "" {
            return (success:false,message:"Please enter zipcode")
        }
        if self.gender == "" {
            return (success:false,message:"Please enter gender")
        }
//        if countryCode.trimmingCharacters(in: .whitespaces).count == 0{
//            return (false,"Please enter country code")
//        }
//        if phoneNumber.trimmingCharacters(in: .whitespaces).count == 0{
//            return (false,"Please enter your mobile number")
//        }
//        let phoneValidation = CommonClass.validatePhoneNumber(phoneNumber.trimmingCharacters(in: .whitespaces))
//        if !phoneValidation{
//            return (false,"Please enter a valid mobile number")
//        }
//        if (phoneNumber.trimmingCharacters(in: .whitespaces).count < self.selectedCountry.minDigit){
//            return (false,"Mobile number should not be less than" + " \(self.selectedCountry.minDigit)" + " in length")
//        }
//        if  (phoneNumber.trimmingCharacters(in: .whitespaces).count > self.selectedCountry.maxDigit){
//            return (false,"Mobile number should not be more than" +  " \(self.selectedCountry.maxDigit)" + " in length")
//        }
        
        if self.DOB == "" {
            return (success:false,message:"Please enter Date of Birth")
        }
        return (true,"")
        
    }

}

extension LearnerEditProfileViewController: UITableViewDataSource, UITableViewDelegate,UserContactCellDelegate {
    func contact(contactCell cell: UserPhoneNumberTableViewCell, didSelectCountry selectedCountry: Country) {
        self.selectedCountry = selectedCountry
        self.countryCode = selectedCountry.phoneCode
        self.tableView.reloadData()

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightOfRows[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserAllTableViewCell") as! UserAllTableViewCell
                
                cell.firstNameTextField.placeholder = "First Name"
                cell.firstNameTextField.keyboardType = .default
                cell.firstNameTextField.autocapitalizationType = .none
                cell.firstNameTextField.text = firstName
                
                cell.lastNameTextField.placeholder = "Last Name"
                cell.lastNameTextField.keyboardType = .default
                cell.lastNameTextField.autocapitalizationType = .none
                cell.lastNameTextField.text = lastName
                
                cell.zipCodeTextField.placeholder = "Zipcode"
                cell.zipCodeTextField.keyboardType = .default
                cell.zipCodeTextField.autocapitalizationType = .none
                cell.zipCodeTextField.text = zipCode
                
                cell.genderTextField.placeholder = "Gender"
                cell.genderTextField.keyboardType = .default
                cell.genderTextField.autocapitalizationType = .none
                cell.genderTextField.text = self.gender
                self.genderTextField = cell.genderTextField
                self.genderTextField.inputView = self.genderPicker
                self.setUpOrganizationPicker()
                
                cell.firstNameTextField.delegate = self
                cell.firstNameTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
                cell.lastNameTextField.delegate = self
                cell.lastNameTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
                cell.zipCodeTextField.delegate = self
                cell.zipCodeTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
                cell.genderTextField.delegate = self
                cell.genderTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
                cell.selectionStyle = .none
                return cell

            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailTextfieldsTableViewCell") as! UserDetailTextfieldsTableViewCell
                cell.userDetailTextfield.placeholder = "Date Of Birth"
                cell.userDetailLabel.text = "*Date Of Birth"
                cell.selectionStyle = .none
                cell.userDetailTextfield.keyboardType = .numberPad
                cell.userDetailTextfield.isSecureTextEntry = false
                cell.userDetailTextfield.autocapitalizationType = .none
                cell.userDetailTextfield.text = self.DOB
                self.dobTextField = cell.userDetailTextfield
                self.dobTextField.inputView = self.datePicker
                self.startDatePickerView()
                return cell
            
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NextPreviousButtonTableViewCell") as! NextPreviousButtonTableViewCell
                cell.nextLabel.isHidden = true
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



extension LearnerEditProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if let indexPath = textField.tableViewIndexPath(self.tableView) as IndexPath? {
  
                if indexPath.row == 0{
                       if let cell = tableView.cellForRow(at: indexPath) as? UserAllTableViewCell{
                       if  textField == cell.firstNameTextField{
                           firstName = textField.text!
                                
                          }else if textField == cell.lastNameTextField {
                               lastName = textField.text!

                       }else if textField == cell.zipCodeTextField {
                                zipCode = textField.text!

                       }
                       else if textField == cell.genderTextField {
                                gender = textField.text!

                       }
                                
                                
                    }
                }else if indexPath.row == 1{
                        if let cell = tableView.cellForRow(at: indexPath) as? UserDetailTextfieldsTableViewCell{
                            if  textField == cell.userDetailTextfield{
                             DOB = textField.text!
                            }
                            }
                    }


            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
              if let indexPath = textField.tableViewIndexPath(self.tableView) as IndexPath? {
    
                  if indexPath.row == 0{
                         if let cell = tableView.cellForRow(at: indexPath) as? UserAllTableViewCell{
                         if  textField == cell.firstNameTextField{
                             firstName = textField.text!
                                  
                            }else if textField == cell.lastNameTextField {
                                 lastName = textField.text!

                         }else if textField == cell.zipCodeTextField {
                                  zipCode = textField.text!

                         }
                         else if textField == cell.genderTextField {
                                  gender = textField.text!

                         }
                                  
                                  
                      }
                  }else if indexPath.row == 1{
                          if let cell = tableView.cellForRow(at: indexPath) as? UserDetailTextfieldsTableViewCell{
                              if  textField == cell.userDetailTextfield{
                               DOB = textField.text!
                              }
                              }
                      }


              
          }
      }
    
    @objc  func textDidChanged(_ textField: UITextField) -> Void {
              if let indexPath = textField.tableViewIndexPath(self.tableView) as IndexPath? {
    
                  if indexPath.row == 0{
                         if let cell = tableView.cellForRow(at: indexPath) as? UserAllTableViewCell{
                         if  textField == cell.firstNameTextField{
                             firstName = textField.text!
                                  
                            }else if textField == cell.lastNameTextField {
                                 lastName = textField.text!

                         }else if textField == cell.zipCodeTextField {
                                  zipCode = textField.text!

                         }
                         else if textField == cell.genderTextField {
                                  gender = textField.text!

                         }
                                  
                                  
                      }
                  }else if indexPath.row == 1{
                          if let cell = tableView.cellForRow(at: indexPath) as? UserDetailTextfieldsTableViewCell{
                              if  textField == cell.userDetailTextfield{
                               DOB = textField.text!
                              }
                              }
                      }


              
          }
      }
    
}


extension LearnerEditProfileViewController{
 
 // Mark:- set up start date picker
 
     func startDatePickerView(){
       self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        
        var components = DateComponents()
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.year = -10
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        self.datePicker.datePickerMode = .date
        self.datePicker.backgroundColor = UIColor.lightText
     
//     let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action:#selector(onClickDone(_:)))
     let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onClickDone(_:)))
        doneButton.tintColor = appColor.white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
//     let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(onClickCancel(_:)))
     let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(onClickCancel(_:)))
     cancelButton.tintColor = appColor.white
     let toolbar = UIToolbar()
     toolbar.sizeToFit()
     let array = [cancelButton, spaceButton, doneButton]
     toolbar.setItems(array, animated: true)
     toolbar.barStyle = UIBarStyle.default
        toolbar.barTintColor = appColor.appBlueColor
     toolbar.tintColor = appColor.white
     self.dobTextField.inputView = self.datePicker
     self.dobTextField.inputAccessoryView = toolbar;

     
     }
    
    
    
    
     @IBAction func onClickDone(_ sender: UIBarButtonItem){
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        self.dobTextField.text = dateFormatter1.string(from: datePicker.date)
        self.DOB = dateFormatter1.string(from: datePicker.date)
        
        datePicker.resignFirstResponder()
        self.view.endEditing(true)
        
     }
    
    
     @IBAction func onClickCancel(_ sender: UIBarButtonItem){
        datePicker.resignFirstResponder()
        self.view.endEditing(true)
     }
}

extension LearnerEditProfileViewController: UIPickerViewDataSource,UIPickerViewDelegate{
          ////////// set up organitionPicker View
        
            func setUpOrganizationPicker() {
                self.genderPicker = UIPickerView()
                self.genderPicker.backgroundColor = UIColor.lightText

                let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onClickOrganitionDone(_:)))
                doneButton.tintColor = appColor.white
                let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
                let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(onClickCancel(_:)))
                cancelButton.tintColor = appColor.white
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
                let array = [cancelButton, spaceButton, doneButton]
                toolbar.setItems(array, animated: true)
                toolbar.barStyle = UIBarStyle.default
                toolbar.barTintColor = appColor.appBlueColor
                toolbar.tintColor = appColor.white
                self.genderTextField.inputView = self.genderPicker
                self.genderTextField.inputAccessoryView = toolbar;
                self.genderPicker.dataSource = self
                self.genderPicker.delegate = self
                
            }

        
            @IBAction func onClickOrganitionDone(_ sender: UIBarButtonItem){
                if self.genderArray.isEmpty {
                    self.genderTextField.resignFirstResponder()
                    self.view.endEditing(true)

                    return
                }
                self.gender = genderArray[genderPicker.selectedRow(inComponent: 0)]
                self.genderTextField.text = gender
                self.genderTextField.resignFirstResponder()
                self.view.endEditing(true)
                self.tableView.reloadData()
            }

        
        
        
        
        

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
              return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {

            return 60.0
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                
             return self.genderArray.count
 

            }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
                
                return self.genderArray[row]

            }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
                if self.genderArray.isEmpty {
                    return
                }
                    self.genderTextField.text = self.genderArray[row]
                    self.gender = self.genderArray[row]


  }
}
