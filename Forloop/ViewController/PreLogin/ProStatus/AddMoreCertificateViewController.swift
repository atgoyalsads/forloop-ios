//
//  AddMoreCertificateViewController.swift
//  Forloop
//
//  Created by Tecorb on 06/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit

protocol AddMoreCertificateViewControllerDelegate{
    func addMoreCertificateViewController(viewController:UIViewController,imageArray:[UIImage],success:Bool,textArray:[String])
}

class AddMoreCertificateViewController: UIViewController {
    @IBOutlet weak var aCollectionView:UICollectionView!
    @IBOutlet weak var submitButton:UIButton!
    
    var imageArray = [UIImage]()
    var previousImage:UIImage?
    var imagePickerController : UIImagePickerController!
    var delegate:AddMoreCertificateViewControllerDelegate?
    var params = Array<Dictionary<String,String>>()
    var textArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        self.registerCells()

        // Do any additional setup after loading the view.
    }
    
    func registerCells() {
        let AddCertificatesCollectionViewCellNib = UINib(nibName: "AddCertificatesCollectionViewCell", bundle: nil)
        self.aCollectionView.register(AddCertificatesCollectionViewCellNib, forCellWithReuseIdentifier: "AddCertificatesCollectionViewCell")
        let moreCertificateNib = UINib(nibName: "MoreCertificateCollectionViewCell", bundle: nil)
        self.aCollectionView.register(moreCertificateNib, forCellWithReuseIdentifier: "MoreCertificateCollectionViewCell")

        self.aCollectionView.backgroundColor  = .clear
        self.aCollectionView.dataSource = self
        self.aCollectionView.delegate = self
        
        let flowLayOut = UICollectionViewFlowLayout()
        flowLayOut.minimumInteritemSpacing = 0
        flowLayOut.minimumLineSpacing = 0
        flowLayOut.scrollDirection = .vertical
        self.aCollectionView.collectionViewLayout = flowLayOut
        self.aCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//                self.navigationController?.navigationBar.isHidden = true
//
//    }
//
    
    override func viewDidLayoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(self.submitButton, borderColor: .clear, borderWidth: 0)
    }
    
   @IBAction func onClickBackButton(_ sender:Any){
        self.navigationController?.pop(true)
    self.delegate?.addMoreCertificateViewController(viewController: self, imageArray: self.imageArray, success: true, textArray: self.textArray)

    }
    
    
    @IBAction func onClickSubmitButton(_ sender:UIButton){
        self.navigationController?.pop(true)
        self.delegate?.addMoreCertificateViewController(viewController: self, imageArray: self.imageArray, success: true, textArray: self.textArray)
     }

}

extension AddMoreCertificateViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        self.imageArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.imageArray.count == 0{
            return self.cellForMoreCertificateCell(collectionView: collectionView, indexPath: indexPath)

        }else{
            if indexPath.item + 1 == self.imageArray.count + 1{
               return self.cellForMoreCertificateCell(collectionView: collectionView, indexPath: indexPath)
            }else{
               return self.cellForCertificateImageCell(collectionView: collectionView, indexPath: indexPath)
            }
        }

    }
    
    
    func cellForCertificateImageCell(collectionView:UICollectionView,indexPath:IndexPath) -> UICollectionViewCell{
            let cell = aCollectionView.dequeueReusableCell(withReuseIdentifier: "AddCertificatesCollectionViewCell", for: indexPath) as! AddCertificatesCollectionViewCell
        let image = self.imageArray[indexPath.item]
        cell.certificateImage.image = image
        cell.cancelButton.addTarget(self, action: #selector(onClickCancelButton(_:)), for: .touchUpInside)
        cell.cancelButton.isHidden = false
        cell.certificateImage.isHidden = false
        cell.addImageButton.isUserInteractionEnabled = false
        cell.addImageButton.isHidden = false
        cell.certificateTextField.isUserInteractionEnabled = true
        cell.certificateTextField.text = self.textArray[indexPath.item]
        cell.certificateImage.image = self.imageArray[indexPath.item]
        cell.certificateTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        cell.certificateTextField.delegate = self

        return cell
        
    }
    
    func cellForMoreCertificateCell(collectionView:UICollectionView,indexPath:IndexPath) -> UICollectionViewCell{
            let cell = aCollectionView.dequeueReusableCell(withReuseIdentifier: "AddCertificatesCollectionViewCell", for: indexPath) as! AddCertificatesCollectionViewCell
        
        cell.certificateTextField.text = (indexPath.item == 0) ? "Add" :"Add More"
        cell.certificateTextField.isUserInteractionEnabled = false
        cell.cancelButton.isHidden = true
        cell.addImageButton.isUserInteractionEnabled = true
        cell.certificateImage.isHidden = true
        cell.addImageButton.addTarget(self, action: #selector(onClickAddImageButton(_:)), for: .touchUpInside)

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.aCollectionView.frame.width / 2 - 5
        let height = CGFloat(180)
        return CGSize(width: width , height: height)
    }
    
    

    
    @IBAction func onClickCancelButton(_ sender:UIButton){
        if let indexPath = sender.collectionViewIndexPath(self.aCollectionView) {
            self.imageArray.remove(at: indexPath.item)
            self.textArray.remove(at: indexPath.item)
            self.aCollectionView.reloadData()
            
            
        }
    }
        
        @IBAction func onClickAddImageButton(_ sender: UIButton){
            if let indexPath = sender.collectionViewIndexPath(self.aCollectionView) {
                if indexPath.item + 1 == self.imageArray.count + 1{
                      self.showAlertToChooseAttachmentOption()
                   }
              }
        }
    
}

extension AddMoreCertificateViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let indexPath = textField.collectionViewIndexPath(self.aCollectionView) as IndexPath? {
            if let cell = aCollectionView.cellForItem(at: indexPath) as? AddCertificatesCollectionViewCell{
                if  textField == cell.certificateTextField{
                    self.textArray[indexPath.item] = textField.text!
                    }
            }
            
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let indexPath = textField.collectionViewIndexPath(self.aCollectionView) as IndexPath? {
//            if let cell = aCollectionView.cellForItem(at: indexPath) as? AddCertificatesCollectionViewCell{
//                if  textField == cell.certificateTextField{
//                    self.textArray[indexPath.item] = textField.text!
//                    }
//            }
//
//        }
   // }
    
    @objc  func textDidChanged(_ textField: UITextField) -> Void {
        if let indexPath = textField.collectionViewIndexPath(self.aCollectionView) as IndexPath? {
            if let cell = aCollectionView.cellForItem(at: indexPath) as? AddCertificatesCollectionViewCell{
                if  textField == cell.certificateTextField{
                    self.textArray[indexPath.item] = textField.text!
                    }
            }
            
        }
    }
}



extension AddMoreCertificateViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
            self.imageArray.append(tempImage)
            self.textArray.append("")
        }else if let tempImage = info[.originalImage] as? UIImage{
            self.imageArray.append(tempImage)
            self.textArray.append("")

        }

        self.aCollectionView.reloadData()

        picker.dismiss(animated: true) {}
    }
}
