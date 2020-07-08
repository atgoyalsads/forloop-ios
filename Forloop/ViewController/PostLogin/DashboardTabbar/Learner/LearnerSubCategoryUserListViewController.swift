//
//  LearnerSubCategoryUserListViewController.swift
//  Forloop
//
//  Created by Tecorb on 10/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import Tags

class LearnerSubCategoryUserListViewController: UIViewController {
    @IBOutlet weak var aTableView:UITableView!
    var userSubCategories = [User]()
    var navTittle = ""
    var topsUsers = [User]()
    var isTopUsers:Bool = false
    var subCategoryID = ""
    var isNewDataLoading = false
    var page:Int = 1
    var perPage:Int = 10

    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = appColor.backgroundAppColor//UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navTittle.uppercased()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.aTableView.backgroundColor = appColor.backgroundAppColor
        self.aTableView.addSubview(refreshControl)

        self.registerCells()
        self.loadUserData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }
    
    func registerCells() {
         let SeekerTrainerTableViewCellNib = UINib(nibName: "SeekerTrainerTableViewCell", bundle: nil)
         aTableView.register(SeekerTrainerTableViewCellNib, forCellReuseIdentifier: "SeekerTrainerTableViewCell")
        let topProUsersTableViewCellNib = UINib(nibName: "TopProUsersTableViewCell", bundle: nil)
        aTableView.register(topProUsersTableViewCellNib, forCellReuseIdentifier: "TopProUsersTableViewCell")
        let noDataNib = UINib(nibName: "NoDataTableViewCell", bundle: nil)
        aTableView.register(noDataNib, forCellReuseIdentifier: "NoDataTableViewCell")
         aTableView.dataSource = self
         aTableView.delegate = self
        self.aTableView.reloadData()
     }
    
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if self.isTopUsers{
            self.handleRefreshTopUser()
        }else{
            self.handleRefreshSubCategory()
        }

    }
    
    func loadUserData(){
        if self.isTopUsers{
            self.loadTopUsersList(self.page, perPage: self.perPage)
        }else{
            self.getAllUsersFromSubCategory(self.page, perPage: self.perPage)
        }

    }
        

    
       @objc func handleRefreshTopUser() {

            if !AppSettings.isConnectedToNetwork{
                refreshControl.endRefreshing()
                return
            }
            self.page = 1
            self.isNewDataLoading = true
            self.topsUsers.removeAll()
            refreshControl.endRefreshing()
            self.aTableView.reloadData()

        
        LearnerService.sharedInstance.loadTopUSerList(page: self.page, perPage: self.perPage) { (success, topUsers, message) in
            if success{
                self.isNewDataLoading = false

                if let aUser = topUsers{
                    self.topsUsers.removeAll()
                    self.topsUsers = aUser
                    self.aTableView.reloadData()
                }
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }

    }
    
    
       @objc func handleRefreshSubCategory() {
            if !AppSettings.isConnectedToNetwork{
                refreshControl.endRefreshing()
                return
            }
            self.page = 1
            self.isNewDataLoading = true
            self.userSubCategories.removeAll()
            refreshControl.endRefreshing()
            self.aTableView.reloadData()

        
        ProService.sharedInstance.getProUserListBySubCategory(subCategoryId: subCategoryID, pageNumber: self.page, perPage: self.perPage) { (success, resUser, message) in
            if success{
                self.isNewDataLoading = false

                if let aUser = resUser{
                    self.userSubCategories.removeAll()
                    self.userSubCategories = aUser
                    self.aTableView.reloadData()
                }
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }

    }
    
    
     func getAllUsersFromSubCategory(_ page: Int,perPage:Int) -> Void {
            if !AppSettings.isConnectedToNetwork{
             NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
                if self.page > 1{
                    self.page = self.page - 1
                }
             AppSettings.shared.hideLoader()
                return
            }
            self.isNewDataLoading = true
        ProService.sharedInstance.getProUserListBySubCategory(subCategoryId: subCategoryID, pageNumber: self.page, perPage: self.perPage) { (success, resUser, message) in
                self.isNewDataLoading = false
                if let someUser = resUser{
                    if someUser.count == 0{
                        if self.page > 1{
                            self.page = self.page - 1
                        }
                    }
                    self.userSubCategories.append(contentsOf:someUser)
                }else{
                    if self.page > 1{
                        self.page = self.page - 1
                    }
                }
     
                self.aTableView.reloadData()
            }
        }
    
    
       func loadTopUsersList(_ page: Int,perPage:Int) -> Void {
           if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
               if self.page > 1{
                   self.page = self.page - 1
               }
            AppSettings.shared.hideLoader()
               return
           }
           self.isNewDataLoading = true
            LearnerService.sharedInstance.loadTopUSerList(page: self.page, perPage: self.perPage) { (success, topUsers, message) in
               self.isNewDataLoading = false
               if let sometopUsers = topUsers{
                   if sometopUsers.count == 0{
                       if self.page > 1{
                           self.page = self.page - 1
                       }
                   }
                   self.topsUsers.append(contentsOf:sometopUsers)
               }else{
                   if self.page > 1{
                       self.page = self.page - 1
                   }
               }
    
               self.aTableView.reloadData()
           }
       }
    
    
    @IBAction func onClickBAckButton(_ sender:Any){
        self.navigationController?.pop(true)
    }
    
    private func makeButton(_ text: String) -> TagButton {
        let button = TagButton()
        button.setTitle(text, for: .normal)
        //button.setImage(UIImage(named: "tick_unsel"), for: .normal)
        //button.setImage(UIImage(named: "tick_sel"), for: .selected)
        
        let options = ButtonOptions(
            layerColor: appColor.blue,//UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0),
            layerRadius: 5,
            layerWidth: 1,
            tagTitleColor: UIColor.blue,
            tagFont: fonts.Roboto.regular.font(.small),
            tagBackgroundColor: appColor.lightGray)//UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0))
        button.setEntity(options)
        return button
    }



}

extension LearnerSubCategoryUserListViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isTopUsers{
            return self.topsUsers.count == 0 ? 1 :self.topsUsers.count

        }else{
            return self.userSubCategories.count == 0 ? 1 : self.userSubCategories.count

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isTopUsers{
            return 150

        }else{
            return UITableView.automaticDimension

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isTopUsers{
            if self.topsUsers.count == 0{
                return self.cellForNoData(tableView: tableView, indexPath: indexPath)
            }else{
                return self.cellForTopProUsers(tableView: tableView, indexPath: indexPath)
            }
        }else{
            if self.userSubCategories.count == 0{
                return self.cellForNoData(tableView: tableView, indexPath: indexPath)
            }else{
                return self.cellForSeekerTrainer(tableView: tableView, indexPath: indexPath)
        }
    }
  }
    
    
    func cellForNoData(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as! NoDataTableViewCell
        cell.labelText.text = isNewDataLoading ? "Loading.." : "No data found\nPull down to refresh"
        return cell
    }

    func cellForTopProUsers(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopProUsersTableViewCell", for: indexPath) as! TopProUsersTableViewCell
        let user = self.topsUsers[indexPath.item]
         cell.topperImage.sd_setImage(with: URL(string:user.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "profile_icon"))
         cell.topperName.text = user.displayName
         cell.topperDescription.text = user.userDescription
        cell.lessonsLabel.text = "\(user.callsDataHome.totalCalls) Calls"


         switch indexPath.item % 4 {
         case 0:
             cell.backgroundImage.image = UIImage(named: "rect_one")
         case 1:
             cell.backgroundImage.image = UIImage(named: "rect_two")
         case 2:
             cell.backgroundImage.image = UIImage(named: "rect_three")
         case 3:
             cell.backgroundImage.image = UIImage(named: "rect_four")
         default:
             cell.backgroundImage.image = UIImage(named: "rect_one")
         }
         return cell
    }
    
    func cellForSeekerTrainer(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeekerTrainerTableViewCell", for: indexPath) as! SeekerTrainerTableViewCell
        let user = self.userSubCategories[indexPath.item]
        cell.displayName.text = user.displayName
        cell.descriptionLabel.text = user.userDescription
        cell.chargeLabel.text = Rs + String(format: "%.1f", user.pricePerHours) + "/hour"        
        cell.lessonsLabel.text = "\(user.callsDataHome.totalCalls) Calls"

        
        cell.tutorImage.sd_setImage(with: URL(string:user.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "profile_icon"))

        cell.tagButton = user.skills.compactMap({ self.makeButton($0.skill.uppercased()) })
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                if self.isTopUsers{
            if self.topsUsers.count == 0{return}
                    let user = self.topsUsers[indexPath.item]
                    if !user.ID.isEmpty{
                        self.getProUserDetail(userID: user.ID)
                    }
        }else{
           if self.userSubCategories.count == 0{return}
                 let user = self.userSubCategories[indexPath.item]
                    if !user.ID.isEmpty{
                        self.getProUserDetail(userID: user.ID)
                }

        }
    }
    
    func navigateToProfileScreen(user:User){
        let profileVC = AppStoryboard.Learner.viewController(ProfileViewController.self)
        profileVC.user =  user
        profileVC.callCategory = self.navTittle.uppercased()
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
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == aTableView{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if self.isTopUsers{
                    if self.perPage > self.topsUsers.count{return}
                    if !isNewDataLoading{
                        if AppSettings.isConnectedToNetwork{
                            isNewDataLoading = true
                            self.page+=1
                            self.loadTopUsersList(self.page, perPage: self.perPage)
                        }
                    }
                }else{
                    if self.perPage > self.topsUsers.count{return}
                    if !isNewDataLoading{
                        if AppSettings.isConnectedToNetwork{
                            isNewDataLoading = true
                            self.page+=1
                            self.getAllUsersFromSubCategory(self.page, perPage: self.perPage)
                    }
                }

            }
        }
    }
  
  }
}
