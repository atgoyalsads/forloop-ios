//
//  SelectSubCategoriesViewController.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 10/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit

protocol SelectSubCategoriesViewControllerDeledate {
    func selectSubCategoriesViewController(viewController:UIViewController,selectCategories:[CategoryModel],success:Bool)
}

class SelectSubCategoriesViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var selectSubCategoriesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton:UIButton!
    var selectCategory = CategoryModel()
    var subCategories = [CategoryModel]()
        var page = 1
        var perPage = 5
    //    var totalPage = 0
       var isLoading = false
    var delegate:SelectSubCategoriesViewControllerDeledate?
    var selectSubCategoryArray = [CategoryModel]()
    var arrSelectedIndex = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backView.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
      // self.loadSubCategoriesFromServer(self.page, perPage: self.perPage)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.backView.clipsToBounds = true
        self.backView.layer.cornerRadius = 20
    }
    
    override func viewDidLayoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(self.submitButton, borderColor: .clear, borderWidth: 0)
    }
    
    func registerCells() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = flowLayout
        let SelectCategoriesCollectionViewCellNib = UINib(nibName: "SelectCategoriesCollectionViewCell", bundle: nil)
        self.collectionView.register(SelectCategoriesCollectionViewCellNib, forCellWithReuseIdentifier: "SelectCategoriesCollectionViewCell")
        self.collectionView.backgroundColor  = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
    }
    
    
    
//       func loadSubCategoriesFromServer(_ page: Int,perPage:Int) -> Void {
//        AppSettings.shared.showLoader(withStatus: "Loading....")
//
//           if !AppSettings.isConnectedToNetwork{
//            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
//               if self.page > 1{
//                   self.page = self.page - 1
//               }
//            AppSettings.shared.hideLoader()
//               return
//           }
//           self.isLoading = true
//        LogInService.sharedInstance.getSubCategoriesFromServer(categoryID: self.selectCategory.id, pageNumber: self.page, perPage: self.perPage){ (success, resCategory, responseMessage) in
//            AppSettings.shared.hideLoader()
//
//               self.isLoading = false
//               if let someCategory = resCategory{
//                   if someCategory.count == 0{
//                       if self.page > 1{
//                           self.page = self.page - 1
//                       }
//                   }
//                   self.subCategories.append(contentsOf:someCategory)
//               }else{
//                   if self.page > 1{
//                       self.page = self.page - 1
//                   }
//               }
//
//               self.collectionView.reloadData()
//           }
//       }
    
    @IBAction func categoryButtonTapped(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        guard let touchedView = touch.view else{return}
        if touchedView == self.view{
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func onClickSubmitButton(_ sender:UIButton){
        if self.selectSubCategoryArray.isEmpty{return}
        self.updateSubCategoryArray()

    }
    
    
    func updateSubCategoryArray(){
        AppSettings.shared.showLoader(withStatus: "Loading..")
        let IdArray = selectSubCategoryArray.compactMap({ $0.id })
        LogInService.sharedInstance.UpdateSubCategoriesToServer(subcategoriesArray: IdArray) { (success, resModel, message) in
            AppSettings.shared.hideLoader()
            if success{
                
                self.delegate?.selectSubCategoriesViewController(viewController: self, selectCategories: self.selectSubCategoryArray, success: true)

            }
        }

    }
    

}

extension SelectSubCategoriesViewController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
            
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subCategories.count
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCategoriesCollectionViewCell", for: indexPath) as! SelectCategoriesCollectionViewCell
        let subCategory = self.subCategories[indexPath.item]
        cell.categoryButton.setTitle(subCategory.title, for: .normal)

        
        cell.categoryButton.addTarget(self, action: #selector(self.categoryButtonTapped(_:)), for: .touchUpInside)
        
        if arrSelectedIndex.contains(indexPath) { // You need to check wether selected index array contain current index if yes then change the color
            cell.categoryButton.backgroundColor = appColor.appBlueColor
            cell.categoryButton.setTitleColor(appColor.white, for: .normal)
        }
        else {
            cell.categoryButton.backgroundColor = appColor.white
            cell.categoryButton.setTitleColor(appColor.black, for: .normal)

        }
        cell.categoryButton.isUserInteractionEnabled = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((self.view.frame.width*1)/3) - 20
        let height = CGFloat(60)
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if self.subCategories.count == 0{return}
        
        let strData = self.subCategories[indexPath.item]
        
        if arrSelectedIndex.contains(indexPath) {
            arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
            self.selectSubCategoryArray = selectSubCategoryArray.filter { $0.id != strData.id}
        }
        else {
            arrSelectedIndex.append(indexPath)
            selectSubCategoryArray.append(strData)
        }
        
        collectionView.reloadItems(at: [indexPath])

       // collectionView.reloadData()

        
    }

        
}
