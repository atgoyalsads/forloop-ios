//
//  AddCertificateTableViewCell.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 09/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit

protocol AddCertificateTableViewCellDelegate {
    func AddCertificate(selectIndexPath:IndexPath,success:Bool,isPresentImage:Bool)
    func deleteCertificate(selectIndexPath:IndexPath,success:Bool)
    
}
class AddCertificateTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: AddCertificateTableViewCellDelegate?
    
   var certificateArray = [UIImage]()
   var textArray = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCells()
        // Initialization code
    }
    
    func registerCells() {
        let AddCertificatesCollectionViewCellNib = UINib(nibName: "AddCertificatesCollectionViewCell", bundle: nil)
        self.collectionView.register(AddCertificatesCollectionViewCellNib, forCellWithReuseIdentifier: "AddCertificatesCollectionViewCell")
        
        let moreCertificateNib = UINib(nibName: "MoreCertificateCollectionViewCell", bundle: nil)
        self.collectionView.register(moreCertificateNib, forCellWithReuseIdentifier: "MoreCertificateCollectionViewCell")
        let flowLayOut = UICollectionViewFlowLayout()
        flowLayOut.minimumInteritemSpacing = 0
        flowLayOut.minimumLineSpacing = 0
        flowLayOut.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = flowLayOut
        self.collectionView.showsHorizontalScrollIndicator = true
        self.collectionView.backgroundColor  = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }

    func getCartificateImageArray(images:[UIImage],nameArray:[String]) {
        self.certificateArray = images
        self.textArray = nameArray
        self.collectionView.reloadData()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension AddCertificateTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = self.collectionView.frame.width
        if self.certificateArray.count == 0{
         width = self.collectionView.frame.width
        }else{
         width = self.collectionView.frame.width / 2 - 5
        }
        let height = CGFloat(180)
        return CGSize(width: width , height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.certificateArray.count == 0{
            return 1

        }else{
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return certificateArray.count == 0 ? 1 : certificateArray.count
        }else{
         return 1
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.certificateArray.count == 0{
            return self.cellForMoreCertificateCell(collectionView: collectionView, indexPath: indexPath)

        }else{
            if indexPath.section == 0{
                return self.cellForCertificateImageCell(collectionView: collectionView, indexPath: indexPath)

            }else{
                return self.cellForMoreCertificateCell(collectionView: collectionView, indexPath: indexPath)
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.AddCertificate(selectIndexPath: indexPath, success: true, isPresentImage: false)

    }
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.certificateArray.count == 0{
//            return certificateArray.count + 2
//
//        }else{
//            return certificateArray.count + 1
//
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//            if self.certificateArray.count == 0{
//                return self.cellForMoreCertificateCell(collectionView: collectionView, indexPath: indexPath)
//
//            }else{
//                if indexPath.item + 1 == self.certificateArray.count + 1{
//                   return self.cellForMoreCertificateCell(collectionView: collectionView, indexPath: indexPath)
//                }else{
//                   return self.cellForCertificateImageCell(collectionView: collectionView, indexPath: indexPath)
//                }
//            }
//
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.delegate?.AddCertificate(selectIndexPath: indexPath, success: true)
//    }
    
    
    
    func cellForCertificateImageCell(collectionView:UICollectionView,indexPath:IndexPath) -> UICollectionViewCell{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCertificatesCollectionViewCell", for: indexPath) as! AddCertificatesCollectionViewCell
        let image = self.certificateArray[indexPath.item]
        cell.certificateImage.image = image
        //cell.certificateName.text = "Certificate \(indexPath.item+1)"
        cell.cancelButton.addTarget(self, action: #selector(onClickCancelButton(_:)), for: .touchUpInside)
        cell.cancelButton.isHidden = false
        cell.addImageButton.isUserInteractionEnabled = false
        cell.certificateImage.isHidden = false
        cell.certificateTextField.text = self.textArray[indexPath.item]
        cell.certificateTextField.isUserInteractionEnabled = false

        return cell
        
    }
    
    func cellForMoreCertificateCell(collectionView:UICollectionView,indexPath:IndexPath) -> UICollectionViewCell{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCertificatesCollectionViewCell", for: indexPath) as! AddCertificatesCollectionViewCell
        if self.certificateArray.count == 0{
            if indexPath.item == 0{
                cell.certificateTextField.text = "Add Certificate"
                cell.certificateTextField.isUserInteractionEnabled = true

            }else{
                cell.certificateTextField.text = "Add Certificate"
                cell.certificateTextField.isUserInteractionEnabled = false

            }
        }else{
            cell.certificateTextField.text = "Add Certificate"
            cell.certificateTextField.isUserInteractionEnabled = false

        }

        cell.cancelButton.isHidden = true
        cell.addImageButton.isUserInteractionEnabled = true
        cell.certificateImage.isHidden = true
        cell.addImageButton.addTarget(self, action: #selector(onClickAddImageButton(_:)), for: .touchUpInside)
        cell.certificateTextField.isUserInteractionEnabled = false

        return cell
        
    }
    
    
    @IBAction func onClickCancelButton(_ sender:UIButton){
        if let indexPath = sender.collectionViewIndexPath(self.collectionView) {
            self.certificateArray.remove(at: indexPath.item)
            self.delegate?.deleteCertificate(selectIndexPath: indexPath, success: true)
            self.collectionView.reloadData()
            
            
        }
    }
        
        @IBAction func onClickAddImageButton(_ sender: UIButton){
            if let indexPath = sender.collectionViewIndexPath(self.collectionView) {
                self.delegate?.AddCertificate(selectIndexPath: indexPath, success: true, isPresentImage: false)

//                if sender.isUserInteractionEnabled == true{
//                    self.delegate?.AddCertificate(selectIndexPath: indexPath, success: true, isPresentImage: false)
//
//                }else{
//                    self.delegate?.AddCertificate(selectIndexPath: indexPath, success: true, isPresentImage: true)
//                    self.collectionView.reloadData()
//
//                }
//
              }
        }
    
}
