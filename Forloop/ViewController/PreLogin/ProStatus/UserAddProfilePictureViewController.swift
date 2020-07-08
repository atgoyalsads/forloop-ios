//
//  UserAddProfilePictureViewController.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 07/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//
import UIKit
import AWSCore
import AWSCognito
import AWSS3

class UserAddProfilePictureViewController: UIViewController {
    @IBOutlet weak var toGetStartedLabel: UILabel!
    @IBOutlet weak var informationUsedFor: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addProfileLabel: UILabel!
    @IBOutlet weak var addProfileButton: UIButton!
    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var buttonView: UIView!
    
    var screenShot : UIImage?
    var imagePickerController : UIImagePickerController!
    var user = User()
    var isSentToServer = false
    var ServerImageUrl = ""
    var isEdit:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User.loadSavedUser()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
           identityPoolId:"us-west-2:5d417312-5c5b-4331-8a72-da232fe416f5")

        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        self.view.backgroundColor = appColor.backgroundAppColor
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        if self.isEdit{
            self.setPreviousUserData()
        }
        // Do any additional setup after loading the view.
    }
    
    
    func setPreviousUserData(){
        self.userNameTextfield.text = self.user.displayName
        if !user.image.isEmpty{
            self.addProfileLabel.isHidden = true
        self.profileImageView.sd_setImage(with: URL(string:self.user.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "profile_icon"))
            self.screenShot = self.profileImageView.image

        }
    }
    
    override func viewWillLayoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(self.userNameTextfield, borderColor: .clear, borderWidth: 0)
        CommonClass.makeViewCircularWithRespectToHeight(self.buttonView, borderColor: .clear, borderWidth: 0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.user = User.loadSavedUser()
          self.navigationController?.navigationBar.isHidden =  true
      }
    
    @IBAction func addProfileTapped(_ sender: UIButton) {
        self.showAlertToChooseAttachmentOption()
        
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        self.isSentToServer = false
        guard let name = self.userNameTextfield.text else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter your display name")
            return
        }
        
        let validation  = self.validateParams(name: name, image: self.screenShot)
        if !validation.success{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: validation.message)
            return
        }

        let user = User.loadSavedUser()
        
        if user.displayName == name && self.profileImageView.image == nil{
            isSentToServer = true
        }
        if !self.ServerImageUrl.isEmpty && (user.image == self.ServerImageUrl){
            isSentToServer = true

        }
        
        if isSentToServer{
            self.afterLoginGetDetailStatus(user: user)
        }else{
            self.newUserAndImageAddedToServer(name: name)
        }
    }
    
    
    
    
    
    func newUserAndImageAddedToServer(name:String){
        
        
        let validation  = self.validateParams(name: name, image: self.screenShot)
        if !validation.success{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: validation.message)
            return
        }
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            return
        }
        
        if self.profileImageView.image != nil{
            AppSettings.shared.showLoader(withStatus: "Loading..")
            self.setUpImagerInAws { (success,imageURlString)  in
                self.ServerImageUrl = imageURlString
                if success{
                    DispatchQueue.main.async {
                        self.updateUserImageToServer(name: name, ImageUrlString: imageURlString)
                    }
                }else{
                    AppSettings.shared.hideLoader()
                }
            }
        }else{
            self.updateUserImageToServer(name: name, ImageUrlString: "")
            
        }

    }
    
    
    
    func updateUserImageToServer(name:String,ImageUrlString:String) {
        LogInService.sharedInstance.updateUserImage(name, ImageUrlString) { (success,resUser, message)  in
            AppSettings.shared.hideLoader()

                if success {
                   if let aUSer = resUser{
                    self.user = aUSer
                    self.afterLoginGetDetailStatus(user: aUSer)

                    }
                } else {
                    NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: message, completionBlock: nil)
                    return
                }
            }

    }
    
    
    func afterLoginGetDetailStatus(user:User){
        if self.isEdit{
            let awsSecondVc = AppStoryboard.Main.viewController(UserDetailViewController.self)
            awsSecondVc.isEdit = self.isEdit
             self.navigationController?.pushViewController(awsSecondVc, animated: true)
        }else{
               if !user.proUserStatus.isDetails{
                let awsSecondVc = AppStoryboard.Main.viewController(UserDetailViewController.self)
                self.navigationController?.pushViewController(awsSecondVc, animated: true)
              
            }else if !user.proUserStatus.isLinks{
                let awsSecondVc = AppStoryboard.Main.viewController(AWSLinkViewController.self)
                self.navigationController?.pushViewController(awsSecondVc, animated: true)
                
            }else if !user.proUserStatus.isPrice{
                    let awsSecondVc = AppStoryboard.Main.viewController(CertificateViewController.self)
                    self.navigationController?.pushViewController(awsSecondVc, animated: true)
                    
                }else if !user.proUserStatus.isSubcategories{
                
                let categoryVC = AppStoryboard.Main.viewController(SelectCategoriesViewController.self)
                self.navigationController?.pushViewController(categoryVC, animated: true)
                
            }
            else{
                AppSettings.shared.proceedToDashboard()

            }
        }

        
    }

    
    
    
    func validateParams(name:String,image:UIImage?) -> (success:Bool,message:String) {

//        if  image == nil{
//            return (success:false,message:"Select your image")
//        }
 
        if name == ""{
            return (success:false,message:"Please enter your display name")
        }
   
        return (true,"")

       
    }
    
    
    func moveToUserdetail() {
        let awsSecondVc = AppStoryboard.Main.viewController(UserDetailViewController.self)
        self.navigationController?.pushViewController(awsSecondVc, animated: true)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.pop(true)

    }
    
    @IBAction func onClickBackButton(_ sender: UIButton) {
        self.navigationController?.pop(true)

    }
    
    func refreshScreenShotButton() {
        if let img = self.screenShot{
            self.addProfileButton.isHidden = true
            self.addProfileLabel.isHidden = true
            self.profileImageView.image = img
        }else{
            self.addProfileButton.isHidden = true
            self.addProfileLabel.isHidden = true
            self.profileImageView.image = nil

        }
    }
    


}



extension UserAddProfilePictureViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
            self.screenShot = tempImage
            self.refreshScreenShotButton()
            self.ServerImageUrl = ""
        }else if let tempImage = info[.originalImage] as? UIImage{
            self.screenShot = tempImage
            self.refreshScreenShotButton()
            self.ServerImageUrl = ""
        }
        picker.dismiss(animated: true) {}
    }
}



extension UserAddProfilePictureViewController{
    func setUpImagerInAws(completion:@escaping (_ done: Bool,_ imageUrl:String)->Void) {
         guard let image = profileImageView.image else{return}
        
        if let data:Data = image.jpegData(compressionQuality: 0.5){
            DispatchQueue.main.async {
                let serverURl = "https://forloopapp-images.s3-us-west-2.amazonaws.com/"
                let transferUtility  =  AWSS3TransferUtility.default()
                 let bucketName = "forloopapp-images"
                 let expression = AWSS3TransferUtilityUploadExpression()
                let key  = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
                transferUtility.uploadData(data, bucket: bucketName, key: key, contentType: "image/jpeg", expression: expression).continueWith {(task) in
                    if let error = task.error{
                         print(error.localizedDescription)
                        completion(false,"")

                     }
                    if let resTask = task.result{
                     let imageUrlString = "\(serverURl)\(key)"
                     print("\(imageUrlString)")
                     completion(true,imageUrlString)
                    }

                    return nil
                 }
            }

        }
    }

}


