//
//  LearnerHomeViewController.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 13/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import SwiftyJSON

class LearnerHomeViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var navView: UIView!
//    var homeData = HomeModel()
    var user = User()
    var callCategory = ""
    var categories = [CategoryModel]()
    var subCategories = [SubCategoryModel]()
    var topUsers = [User]()
    var page = 1
    var subCatpage = 1
    var perPage = 3
    var isLoading = false
    var selectCategory = CategoryModel()
    var paginationIndex = 0
    var paginationPage = 1
    var toppage = 1
    var topPerPage = 6

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = appColor.backgroundAppColor//UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        //refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User.loadSavedUser()
        self.searchBar.placeholder = "Search"
        self.searchBar.delegate = self
        self.view.backgroundColor = appColor.backgroundAppColor
        self.navView.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
        self.setAllApiFromServer()
        if !self.user.proUserStatus.isDisplayName || !self.user.proUserStatus.isDetails {
            self.askForSubmitLearnerDetails()
        }
        setNeedsStatusBarAppearanceUpdate()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    
//    func loadLocalJson(){
//      if let path = Bundle.main.path(forResource: "Home", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                let jsonObj = try JSON(data: data)
//                let homeParser = HomeParser(jsonObj)
//                print("jsonData:\(homeParser.home)")
//                self.homeData = homeParser.home
//                self.tableview.reloadData()
//            } catch let error {
//                print("parse error: \(error.localizedDescription)")
//            }
//        } else {
//            print("Invalid filename/path.")
//        }
//
//    }
    
    

    
    
    func registerCells() {
        let helloTableViewCellNib = UINib(nibName: "HelloTableViewCell", bundle: nil)
        tableview.register(helloTableViewCellNib, forCellReuseIdentifier: "HelloTableViewCell")
        let profileTableViewCellNib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableview.register(profileTableViewCellNib, forCellReuseIdentifier: "ProfileTableViewCell")
        let categoryTableViewCellNib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        tableview.register(categoryTableViewCellNib, forCellReuseIdentifier: "CategoryTableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    @IBAction func notificationTapped(_ sender: Any) {
        NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)

    }
    
    @IBAction func onClikSearchButton(_ sender: Any) {
        let searchVC = AppStoryboard.Learner.viewController(SearchUserViewController.self)
        self.navigationController?.pushViewController(searchVC, animated: true)

    }
    
    @IBAction func onClickSeeAllClickData(_ sender: UIButton) {
        if let indexPath = sender.tableViewIndexPath(self.tableview) {
            if indexPath.section == 0{
                let CategoryVC = AppStoryboard.Learner.viewController(LearnerCategoryListViewController.self)
                self.navigationController?.pushViewController(CategoryVC, animated: true)
            }else if indexPath.section == 2{
                let listUserVC = AppStoryboard.Learner.viewController(LearnerSubCategoryUserListViewController.self)
                listUserVC.isTopUsers = false
                listUserVC.navTittle = self.subCategories[indexPath.row].title
                listUserVC.subCategoryID = self.subCategories[indexPath.row].id

                self.navigationController?.pushViewController(listUserVC, animated: true)
            }else if indexPath.section == 3{
                //let users = self.topUsers
                let listUserVC = AppStoryboard.Learner.viewController(LearnerSubCategoryUserListViewController.self)
                listUserVC.isTopUsers = true
//                listUserVC.topsUsers = users
                listUserVC.navTittle = "Top Pro"
                self.navigationController?.pushViewController(listUserVC, animated: true)
            }

        }

    }
    
    
    func askForSubmitLearnerDetails() {
        
        let alert = UIAlertController(title: warningMessage.title.rawValue, message: "Please complete your profile", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Accept", style: .default){(action) in
            alert.dismiss(animated: true, completion: nil)
            self.afterLoginGetDetailStatus()
        }
        let cancelAction = UIAlertAction(title: "Decline", style: .cancel){(action) in
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    
    
        func afterLoginGetDetailStatus(){
            if !self.user.proUserStatus.isDisplayName{
                let addProfileVC = AppStoryboard.Learner.viewController(LearnerDisplayNameViewController.self)
                self.navigationController?.pushViewController(addProfileVC, animated: true)
                
            }else if !self.user.proUserStatus.isDetails{
                let awsSecondVc = AppStoryboard.Learner.viewController(LearnerEditProfileViewController.self)
                self.navigationController?.pushViewController(awsSecondVc, animated: true)
                
            }
            else{
    //            let awsSecondVc = AppStoryboard.Main.viewController(CertificateViewController.self)
    //            self.navigationController?.pushViewController(awsSecondVc, animated: true)

                //AppSettings.shared.proceedToDashboard()
                
            }
            
        }

    

    
    
 
}

extension LearnerHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        case 1:
            return 120
        case 2:
            return 220
        case 3:
            return 360
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return self.subCategories.count//self.homeData.subcategories.count
        case 3:
            return 1
        default:
            return 1
        }
    }
//
//    func numberofRowInsectionSubCategory(indexPath:IndexPath) -> Int{
//        var row = self.subCategories.count
//        if self.subCategories[indexPath.row].user.count == 0{
//            row = row-1
//        }
//        return row
//    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HelloTableViewCell", for: indexPath) as! HelloTableViewCell
            cell.selectionStyle = .none
            cell.helloLabel.text = "Hello \(user.displayName)!"
            cell.seeAllButton.addTarget(self, action: #selector(onClickSeeAllClickData(_:)), for: .touchUpInside)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setCategoryData(categories: self.categories)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            let subCategory = self.subCategories[indexPath.row]//self.homeData.subcategories[indexPath.row]
            cell.fieldNameLabel.text = subCategory.title.uppercased()
            cell.setProfile = true
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setSubCategoryData(user: subCategory.user)
            cell.seeAllButton.setTitle("SEE ALL", for: .normal)
            cell.tableViewIndex = indexPath.row
            cell.seeAllButton.addTarget(self, action: #selector(onClickSeeAllClickData(_:)), for: .touchUpInside)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            cell.fieldNameLabel.text = "Top Pro"
            cell.setProfile = false
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setTopProUserData(user: self.topUsers)
            cell.seeAllButton.setTitle("SEE ALL", for: .normal)

            cell.seeAllButton.addTarget(self, action: #selector(onClickSeeAllClickData(_:)), for: .touchUpInside)

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HelloTableViewCell", for: indexPath) as! HelloTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }

    
}

extension LearnerHomeViewController:UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            self.view.endEditing(true)
        NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)
    }
    
}

extension LearnerHomeViewController:ProfileTableViewCellDelegate{
    func profileTableViewCellPagination(success: Bool, tableViewIndex: Int, isTopUSer: Bool) {
        if success{
            if isTopUSer{
                if self.topUsers.count == 0{return}
                if self.topPerPage > self.topUsers.count{return}
                if self.perPage > self.subCategories.count{return}
                if AppSettings.isConnectedToNetwork{
                        toppage += 1
                 self.loadTopUsersList(self.toppage, perPage: self.topPerPage)
                }

            }else{
                if self.subCategories.count == 0{return}
                if self.perPage > self.subCategories.count{return}
                if AppSettings.isConnectedToNetwork{
                    if self.paginationIndex == tableViewIndex{
                        paginationPage += 1
                    }else{
                       paginationPage = 2
                        self.paginationIndex = tableViewIndex

                    }
                    self.getAllUsersFromSubCategory(self.paginationPage, perPage: self.perPage, subCategoryID: self.subCategories[paginationIndex].id)
                }
            }

            
        }
    }
    
    
    func getAllUsersFromSubCategory(_ page: Int,perPage:Int,subCategoryID:String) -> Void {
           if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
               if self.page > 1{
                   self.page = self.page - 1
               }
            AppSettings.shared.hideLoader()
               return
           }
           self.isLoading = true
        ProService.sharedInstance.getProUserListBySubCategory(subCategoryId: subCategoryID, pageNumber: page, perPage: perPage) { (success, resUser, message) in
               self.isLoading = false
               if let someUser = resUser{
                   if someUser.count == 0{
                       if self.page > 1{
                           self.page = self.page - 1
                       }
                   }
                self.subCategories[self.paginationIndex].user.append(contentsOf: someUser)
                   //self.userSubCategories.append(contentsOf:someUser)
               }else{
                   if self.page > 1{
                       self.page = self.page - 1
                   }
               }
    
               self.tableview.reloadData()
           }
       }

    
    func profileTableViewCellIndex(selectIndexPath: IndexPath, success: Bool, setProfile: Bool, user: User, tableIndex: Int) {
                if success{
            if  self.subCategories.count == 0 {return}
            if !user.ID.isEmpty{
               // self.callCategory = self.subCategories[tableIndex].title.uppercased()
                self.getProUserDetail(userID: user.ID)
            }
         }
    }



    func navigateToProfileScreen(user:User){
        let profileVC = AppStoryboard.Learner.viewController(ProfileViewController.self)
        profileVC.user =  user
        profileVC.callCategory = self.callCategory
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    
    func getProUserDetail(userID:String){
        if !AppSettings.isConnectedToNetwork{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
                return
            }
        AppSettings.shared.showLoader(withStatus: "Loading..")
        ProService.sharedInstance.getProDetails(proUserId: userID) { (success, resUser, message) in
            AppSettings.shared.hideLoader()
            if success{
                if let aUSer = resUser{
                    
                    self.navigateToProfileScreen(user: aUSer)

                }
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }

        
    }
    
    
}


extension LearnerHomeViewController{
    
    

    func setAllApiFromServer(){
        self.loadTopUsersList(self.toppage, perPage: self.perPage)
        self.loadSubCategoryList(self.subCatpage, perPage: self.perPage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.loadCategoryList(self.page, perPage: self.perPage)
            self.setNeedsStatusBarAppearanceUpdate()

        }
    }
    
    
            func loadCategoryList(_ page: Int,perPage:Int) -> Void {
           if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
               if self.page > 2{
                   self.page = self.page - 1
               }
            AppSettings.shared.hideLoader()
               return
           }
           self.isLoading = true
                AppSettings.shared.showLoader(withStatus: "Loading..")
            LearnerService.sharedInstance.loadSeekerCategoList(page: self.page, perPage: 20) { (success, resCategoyList, message) in
            AppSettings.shared.hideLoader()
               self.isLoading = false
               if let someCategory = resCategoyList{
                   if someCategory.count == 0{
                       if self.page > 2{
                           self.page = self.page - 2
                       }
                   }
                   self.categories.append(contentsOf:someCategory)
               }else{
                   if self.page > 2{
                       self.page = self.page - 1
                   }
               }
    
               self.tableview.reloadData()
           }
       }
    
    
    
        func loadSubCategoryList(_ page: Int,perPage:Int) -> Void {
           if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
               if self.subCatpage > 1{
                   self.subCatpage = self.subCatpage - 1
               }
            AppSettings.shared.hideLoader()
               return
           }
           self.isLoading = true
          LearnerService.sharedInstance.loadSeekerSubCategoList(categoryID: self.selectCategory.id,page: self.subCatpage, perPage: self.perPage) { (success, resSubCategoyList, message) in
//            AppSettings.shared.hideLoader()
               self.isLoading = false
               if let someSubCategory = resSubCategoyList{
                   if someSubCategory.count == 0{
                       if self.subCatpage > 1{
                           self.subCatpage = self.subCatpage - 1
                       }
                   }
                   self.subCategories.append(contentsOf:someSubCategory)
               }else{
                   if self.subCatpage > 1{
                       self.subCatpage = self.subCatpage - 1
                   }
               }
    
               self.tableview.reloadData()
           }
       }
    
        func loadTopUsersList(_ page: Int,perPage:Int) -> Void {
           if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
               if self.toppage > 1{
                   self.toppage = self.toppage - 1
               }
            AppSettings.shared.hideLoader()
               return
           }
           self.isLoading = true
//            AppSettings.shared.showLoader(withStatus: "Loading..")
            LearnerService.sharedInstance.loadTopUSerList(page: self.toppage, perPage: self.topPerPage) { (success, topUsers, message) in
//            AppSettings.shared.hideLoader()
               self.isLoading = false
               if let sometopUsers = topUsers{
                   if sometopUsers.count == 0{
                       if self.toppage > 1{
                           self.toppage = self.toppage - 1
                       }
                   }
                   self.topUsers.append(contentsOf:sometopUsers)
               }else{
                   if self.toppage > 1{
                       self.toppage = self.toppage - 1
                   }
               }
    
               self.tableview.reloadData()
           }
       }
    
    func loadSubCategoryListByCategoryID(_ page: Int,perPage:Int,categoryID:String) -> Void {
            if !AppSettings.isConnectedToNetwork{
                 NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
                 return
             }
            AppSettings.shared.showLoader(withStatus: "Loading..")
          LearnerService.sharedInstance.loadSeekerSubCategoList(categoryID: categoryID,page: self.subCatpage, perPage: self.perPage) { (success, resSubCategoyList, message) in
            AppSettings.shared.hideLoader()
               self.subCategories.removeAll()
               if let someSubCategory = resSubCategoyList{
                   self.subCategories.append(contentsOf:someSubCategory)
               }
               self.tableview.reloadData()
           }
       }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         if scrollView == tableview{
             if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height-2)
             {
                 if self.perPage > self.subCategories.count{return}
                 if !isLoading{
                     if AppSettings.isConnectedToNetwork{
                         isLoading = true
                         self.subCatpage+=1
                        self.loadSubCategoryList(self.page, perPage: self.perPage)
                     }
                 }
             }
         }
     }
    
    
}

extension LearnerHomeViewController:CategoryTableViewCellDelegate{
    func categoryTableViewCell(indexPath: IndexPath, category: CategoryModel) {
        self.selectCategory = category
        self.loadSubCategoryListByCategoryID(self.subCatpage, perPage: self.perPage, categoryID: self.selectCategory.id)
    }
    
    
}
