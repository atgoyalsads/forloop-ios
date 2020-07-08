//
//  CertificateViewController.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 09/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognito
import AWSS3

class CertificateViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    var heightOfRows:[CGFloat] = [350,190,170,160]

    var imagePickerController : UIImagePickerController!
    var exprienceTextField:UITextField!
    var certificatePicker = UIPickerView()
    var exprienceArray = [String]()
    var addExprience = "";var desc="";var chargeAmount="";
    var imagesArray = [UIImage]()
    var imageUrlArray = [String]()
    var selectPriceUnit = ""
    var isSentToNextScreen:Bool = false
    var textArray = [String]()
    var isEdit:Bool = false



    override func viewDidLoad() {
        super.viewDidLoad()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
           identityPoolId:"us-west-2:5d417312-5c5b-4331-8a72-da232fe416f5")

        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        self.view.backgroundColor = appColor.backgroundAppColor
        self.tableview.backgroundColor = .clear
        self.registerCells()
        if self.isEdit{
            self.setPreviousCertificateData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func setPreviousCertificateData(){
        let user = User.loadSavedUser()
        self.imagesArray = user.certificates.map{(UIImage(url: URL(string: $0.link)) ?? UIImage())}
        self.textArray = user.certificates.map{$0.certificate}
        self.chargeAmount = String(format: "%.0f", user.pricePerHours)
        self.desc = user.userDescription
        self.tableview.reloadData()
    }
            
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden =  true
    }
            
    func registerCells() {
        let getStartedCellNib = UINib(nibName: "GetStartedTableViewCell", bundle: nil)
        self.tableview.register(getStartedCellNib, forCellReuseIdentifier: "GetStartedTableViewCell")
        let DescriptionTextViewTableViewCellnib = UINib(nibName: "DescriptionTextViewTableViewCell", bundle: nil)
        self.tableview.register(DescriptionTextViewTableViewCellnib, forCellReuseIdentifier: "DescriptionTextViewTableViewCell")
        let AddCertificateTableViewCellnib = UINib(nibName: "AddCertificateTableViewCell", bundle: nil)
               self.tableview.register(AddCertificateTableViewCellnib, forCellReuseIdentifier: "AddCertificateTableViewCell")
        let ExperienceAndChargeTableViewCellnib = UINib(nibName: "ExperienceAndChargeTableViewCell", bundle: nil)
               self.tableview.register(ExperienceAndChargeTableViewCellnib, forCellReuseIdentifier: "ExperienceAndChargeTableViewCell")
        let nextCellnib = UINib(nibName: "NextPreviousButtonTableViewCell", bundle: nil)
        self.tableview.register(nextCellnib, forCellReuseIdentifier: "NextPreviousButtonTableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
    }
                
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.pop(true)
    }
                
    @IBAction func nextTapped(_ sender: Any) {
        

        let validation = self.validateParams(desciption: self.desc, exprience: self.addExprience, chargeAmount: self.chargeAmount)
        if !validation.success{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: validation.message)
            return
        }
        self.navigateToSelectPriceScreen()

    }
    
    
    
    
    
    func updateUserCertificate(){
        if self.imagesArray.count == 0{

            self.updateUserCertificateDetails(desc: self.desc, exprience: self.addExprience, certificateArray: [])
    }else{
            self.uploadNewCertificatesToServer()
        }
    
    }
    
    func uploadNewCertificatesToServer(){
        AppSettings.shared.showLoader(withStatus: "Uploading..")
        self.uploadCertificatesToAwsBucket { (success) in
//            DispatchQueue.main.async {
//            AppSettings.shared.hideLoader()
//            }
            if success{
            DispatchQueue.main.async {
               
                if ((self.imageUrlArray.isEmpty) && (self.imageUrlArray.count == self.textArray.count) && self.textArray.isEmpty){return}
                
                var array = [Dictionary<String,String>]()

                for i in (0..<self.imageUrlArray.count){
                    var param = Dictionary<String,String>()
                    param.updateValue(self.imageUrlArray[i], forKey: "link")
                    param.updateValue(self.textArray[i], forKey: "title")
                    array.append(param)
                }
                
                self.updateUserCertificateDetails(desc: self.desc, exprience: self.addExprience, certificateArray: array)
               }
            }else{
                DispatchQueue.main.async {
                    AppSettings.shared.hideLoader()
                }
            }
        }

    }
    
    
    
    func updateUserCertificateDetails(desc:String,exprience:String,certificateArray:[Dictionary<String,String>]){

        
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            return
        }
        
        AppSettings.shared.showLoader(withStatus: "Loading..")

        LogInService.sharedInstance.updateUserCertificateImage(description: self.desc, exprience: self.addExprience, chargeAmount: self.chargeAmount, certificateArray:certificateArray) { (success,resUser,message)  in
            AppSettings.shared.hideLoader()
            if success{
                if let aUser = resUser{
                    self.afterLoginGetDetailStatus(user: aUser)
                }

            }else{
                NKToastHelper.sharedInstance.showSuccessAlert(self, message: message)
            }
        }
    }
    
    
    func afterLoginGetDetailStatus(user:User){
        if self.isEdit{
            let categoryVC = AppStoryboard.Main.viewController(SelectCategoriesViewController.self)
            categoryVC.isEdit = self.isEdit
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }else{
             if !user.proUserStatus.isSubcategories{
                let categoryVC = AppStoryboard.Main.viewController(SelectCategoriesViewController.self)
                self.navigationController?.pushViewController(categoryVC, animated: true)
            }else{
                AppSettings.shared.proceedToDashboard()
            }
            
        }

     }
    
    
    
    func validateParams(desciption:String,exprience:String,chargeAmount:String) -> (success:Bool,message:String) {
        if desciption == "" {
          return (success:false,message:"Please tell us something about yourself")
        }
        if chargeAmount == ""{
            return (success:false,message:"Please enter your charge amount")
        }


        
        return (true,"")

       
    }
}

extension CertificateViewController: UITableViewDataSource, UITableViewDelegate {
            
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
                
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
                
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
            case 0:
                return heightOfRows[section]
            case 1:
                return heightOfRows[section]
            case 2:
                return heightOfRows[section]
            case 3:
                return heightOfRows[section]
            default:
                return 200
            }
    }
                
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let section = indexPath.section
        switch section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTextViewTableViewCell") as! DescriptionTextViewTableViewCell
                cell.descTextview.delegate = self
                cell.descTextview.placeholder = "*Please tell us something about yourself"
                cell.descTextview.text = self.desc
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddCertificateTableViewCell") as! AddCertificateTableViewCell
                cell.backgroundColor = appColor.backgroundAppColor
                cell.collectionView.backgroundColor = appColor.backgroundAppColor
                cell.collectionView.reloadData()
                cell.selectionStyle = .none
                cell.delegate = self
                cell.getCartificateImageArray(images: self.imagesArray, nameArray: self.textArray)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceAndChargeTableViewCell") as! ExperienceAndChargeTableViewCell
                cell.chargeTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
                cell.chargeTextField.delegate = self
                cell.chargeTextField.placeholder = "*Enter Charge"
                cell.chargeTextField.text = self.chargeAmount
                cell.chargeTextField.keyboardType = .decimalPad
                cell.selectionStyle = .none
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NextPreviousButtonTableViewCell") as! NextPreviousButtonTableViewCell
                cell.backButton.addTarget(self, action: #selector(backTapped(_:)), for:.touchUpInside)
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


extension CertificateViewController:AddCertificateTableViewCellDelegate{
    func AddCertificate(selectIndexPath: IndexPath, success: Bool, isPresentImage: Bool) {
        
            if success{
                if !isPresentImage{
                    self.navigateToMoreCertificateScreen()

                }else{
                    self.navigateToMoreCertificateScreen()
                }

            
        }
    }
    
    func deleteCertificate(selectIndexPath: IndexPath, success: Bool) {
        if success{
            if self.imagesArray.count != 0 {
                self.imagesArray.remove(at: selectIndexPath.item)
                self.textArray.remove(at: selectIndexPath.item)
                self.tableview.reloadData()
            }
        }
        
    }
    

    
    func navigateToMoreCertificateScreen(){
        let moreCertificateVC = AppStoryboard.Main.viewController(AddMoreCertificateViewController.self)
        moreCertificateVC.imageArray = self.imagesArray
        moreCertificateVC.textArray = self.textArray
        moreCertificateVC.delegate = self
        self.navigationController?.pushViewController(moreCertificateVC, animated: true)
    }
    
    
}




extension CertificateViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func showAlertToChooseAttachmentOption(){
        let actionSheet = UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(cancelAction)
        let openGalleryAction: UIAlertAction = UIAlertAction(title: "Choose from Gallery", style: .default)
        { action -> Void in
            actionSheet.dismiss(animated: true, completion: nil)
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                self.imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary;
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.modalPresentationStyle = UIModalPresentationStyle.currentContext
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(openGalleryAction)
        
        let openCameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default)
        { action -> Void in
            actionSheet.dismiss(animated: true, completion: nil)
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                self.imagePickerController.sourceType = UIImagePickerController.SourceType.camera;
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.modalPresentationStyle = UIModalPresentationStyle.currentContext
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(openCameraAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let tempImage = info[.editedImage] as? UIImage{

                self.imagesArray.append(tempImage)

        }else if let tempImage = info[.originalImage] as? UIImage{

                self.imagesArray.append(tempImage)

        }
        self.tableview.reloadData()

        picker.dismiss(animated: true) {}
    }
}


extension CertificateViewController{
    func setUpEventPicker() {
        self.certificatePicker = UIPickerView()
        
        for i in 0..<10{
            self.exprienceArray.append("\(i)" + " " + "year")
 
        }
        self.certificatePicker.backgroundColor = UIColor.lightText
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action:#selector(onClickEventDone(_:)))
        doneButton.tintColor = UIColor.white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: #selector(onClickCancel(_:)))
        cancelButton.tintColor = UIColor.white
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.barStyle = UIBarStyle.default
        toolbar.barTintColor = appColor.appBlueColor
        toolbar.tintColor = UIColor.white
        self.exprienceTextField.inputView = self.certificatePicker
        self.exprienceTextField.inputAccessoryView = toolbar;
        self.certificatePicker.dataSource = self
        self.certificatePicker.delegate = self
        
    }
    
    
    @IBAction func onClickEventDone(_ sender: UIBarButtonItem){
        self.addExprience = exprienceArray[certificatePicker.selectedRow(inComponent: 0)]
        exprienceTextField.text = addExprience.capitalized
        exprienceTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    @IBAction func onClickCancel(_ sender: UIBarButtonItem){

       self.view.endEditing(true)
    }
}


extension CertificateViewController: UIPickerViewDataSource,UIPickerViewDelegate{
 
 // Mark:- SetUp Year Picker
 
 
func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
 func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 60.0
    }
    
 func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
  return exprienceArray.count
 }

 
 func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
  return exprienceArray[row]
 }
    
 func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
  addExprience = exprienceArray[row]
    }
 }



extension CertificateViewController: UITextFieldDelegate,UITextViewDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let indexPath = textField.tableViewIndexPath(self.tableview) as IndexPath?{
            if let cell = tableview.cellForRow(at: indexPath) as? ExperienceAndChargeTableViewCell{
                    if textField == cell.chargeTextField {
                        chargeAmount = textField.text!
                        //self.navigateToSelectPriceScreen()

                }
            }
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let indexPath = textField.tableViewIndexPath(self.tableview) as IndexPath?{
            if let cell = tableview.cellForRow(at: indexPath) as? ExperienceAndChargeTableViewCell{
                    if textField == cell.chargeTextField {
                        chargeAmount = textField.text!

                }
            }
            
        }
    }

    @objc  func textDidChanged(_ textField: UITextField) -> Void {
        if let indexPath = textField.tableViewIndexPath(self.tableview) as IndexPath?{
            if let cell = tableview.cellForRow(at: indexPath) as? ExperienceAndChargeTableViewCell{
                    if textField == cell.chargeTextField {
                        chargeAmount = textField.text!
                        //self.navigateToSelectPriceScreen()

                }
            }
            
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
         if let indexPath = textView.tableViewIndexPath(self.tableview) as IndexPath?{
            if let cell = tableview.cellForRow(at: indexPath) as? DescriptionTextViewTableViewCell{
                if   textView == cell.descTextview{
                        desc = textView.text!
                    
                    }
            }
            
        }

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
         if let indexPath = textView.tableViewIndexPath(self.tableview) as IndexPath?{
            if let cell = tableview.cellForRow(at: indexPath) as? DescriptionTextViewTableViewCell{
                if   textView == cell.descTextview{
                        desc = textView.text!
                    
                    }
            }
            
        }

    }
    
    func textViewDidChange(_ textView: UITextView) {
         if let indexPath = textView.tableViewIndexPath(self.tableview) as IndexPath?{
            if let cell = tableview.cellForRow(at: indexPath) as? DescriptionTextViewTableViewCell{
                if   textView == cell.descTextview{
                        desc = textView.text!
                    
                    }
            }
            
        }

    }
    
}




extension CertificateViewController{    
    func uploadCertificatesToAwsBucket(completion:@escaping (_ done: Bool)->Void){
    
        if self.imagesArray.count == 0 {
            completion(true)
        }
        
        let group = DispatchGroup()

        for (_, image) in imagesArray.enumerated() {
            
            group.enter()
            
            if let data:Data = image.jpegData(compressionQuality: 0.2) {
                         let serverURl = "https://forloopapp-images.s3-us-west-2.amazonaws.com/"
                         let transferUtility  =  AWSS3TransferUtility.default()
                          let bucketName = "forloopapp-images"
                          let expression = AWSS3TransferUtilityMultiPartUploadExpression()//AWSS3TransferUtilityUploadExpression()
                         let key  = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
                transferUtility.uploadUsingMultiPart(data: data, bucket: bucketName, key: key, contentType: "image/jpeg", expression: expression) { (task, error) in
                            group.leave()

                              if let error = error{
                                AppSettings.shared.hideLoader()
                                  print(error.localizedDescription)

                                  completion(false)
                              }
                            let imageUrlString = "\(serverURl)\(key)"
                             print("\(imageUrlString)")
                            self.imageUrlArray.append(imageUrlString)
                            if self.imageUrlArray.count == self.imagesArray.count{
                                completion(true)
                            }
                          }
                  }
  
        }
        
    }
    
}


extension CertificateViewController:SelectPriceUnitViewControllerDelegate{
    func selectPricePerUnit(_ viewController: SelectPriceUnitViewController, didSelectIndex: Int, didSuccess success: Bool) {
        viewController.dismiss(animated: true, completion: nil)
        if success{
//            if didSelectIndex == 0{
//                self.selectPriceUnit = "price per minutes"
//            }else if didSelectIndex == 1{
//                self.selectPriceUnit = "price per half hours"
//
//            }else{
//                self.selectPriceUnit = "price per hours"
//
//            }

            
            self.updateUserCertificate()
            //self.tableview.reloadData()
        }
    }
    
    func navigateToSelectPriceScreen() {
        let priceVC = AppStoryboard.Main.viewController(SelectPriceUnitViewController.self)
        priceVC.delegate = self
        priceVC.selectPrice = self.chargeAmount
        priceVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let nav = UINavigationController(rootViewController: priceVC)
        nav.navigationBar.isHidden = true
        nav.modalPresentationStyle = .overCurrentContext
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true, completion: nil)
    }
    
    
}

extension CertificateViewController:AddMoreCertificateViewControllerDelegate{
    func addMoreCertificateViewController(viewController: UIViewController, imageArray: [UIImage], success: Bool, textArray: [String]) {
            if success{
             self.imagesArray = imageArray
             self.textArray = textArray
             self.tableview.reloadData()
             
         }
    }

    
    
}


extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}



extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }

        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}


