//
//  SearchUserViewController.swift
//  Forloop
//
//  Created by Tecorb on 24/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import Tags

class SearchUserViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    
    var users = [User]()
    
    var page = 1
    var perPage = 15
    var isLoading = false
    var isSeachActive = false
    var keywordSearch = ""

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = appColor.backgroundAppColor//UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.placeholder = "Search"
        self.searchBar.delegate = self
        self.searchBar.becomeFirstResponder()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.tableview.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
        self.tableview.addSubview(refreshControl)
        self.loadUsersFromServer(self.page, perPage: self.perPage, keyword: "")

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
                self.navigationController?.navigationBar.isHidden = false

    }
    
    func registerCells() {
        let userImageTableViewCellNib = UINib(nibName: "SeekerTrainerTableViewCell", bundle: nil)
        tableview.register(userImageTableViewCellNib, forCellReuseIdentifier: "SeekerTrainerTableViewCell")
        let noDataNib = UINib(nibName: "NoDataTableViewCell", bundle: nil)
        tableview.register(noDataNib, forCellReuseIdentifier: "NoDataTableViewCell")

        tableview.dataSource = self
        tableview.delegate = self
    }
    
                    
    @IBAction func onClickBackButton(_ sender: Any) {
        self.navigationController?.pop(true)
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if !AppSettings.isConnectedToNetwork{
            refreshControl.endRefreshing()
            return
        }
        self.page = 1
        self.isLoading = true
        self.searchBar.text = ""

        ProService.sharedInstance.searchFroUsers(keyword: "", pageNumber: self.page, perPage: self.perPage) { (success, resUsers, responseMessage) in
            self.isLoading = false
            self.users.removeAll()
            refreshControl.endRefreshing()
            if success{
                if let someUsers = resUsers{
                    self.users.append(contentsOf: someUsers)
                }
                self.tableview.reloadData()
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: responseMessage)
                self.tableview.reloadData()
            }
        }

    }
    

      
    
    func loadUsersFromServer(_ page: Int,perPage:Int,keyword:String) -> Void {
//        if !isSeconndTimeLoading{
//            AppSettings.shared.showLoader(withStatus: "Loading..")
//        }
           if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
               if self.page > 1{
                   self.page = self.page - 1
               }
            AppSettings.shared.hideLoader()
               return
           }
           self.isLoading = true
        ProService.sharedInstance.searchFroUsers(keyword: keyword.lowercased(), pageNumber: self.page, perPage: self.perPage) { (success, resUsers, responseMessage) in
            AppSettings.shared.hideLoader()
               self.isLoading = false
               if let someUsers = resUsers{
                   if someUsers.count == 0{
                       if self.page > 1{
                           self.page = self.page - 1
                       }
                   }
                   self.users.append(contentsOf:someUsers)
               }else{
                   if self.page > 1{
                       self.page = self.page - 1
                   }
               }
    
               self.tableview.reloadData()
           }
       }
    

}


extension SearchUserViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count == 0 ? 1 : self.users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.users.count == 0 ? 120 : self.getparticularRowHeight(indexPath: indexPath)
    }
    
    func getparticularRowHeight(indexPath:IndexPath) ->CGFloat{
        var height:CGFloat = 120
        if self.users[indexPath.row].skills.count == 0 {
            height = 150
        }else{
           height = UITableView.automaticDimension
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.users.count == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as! NoDataTableViewCell
            cell.labelText.text = isLoading ? "Loading.." : "No users found"
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeekerTrainerTableViewCell", for: indexPath) as! SeekerTrainerTableViewCell
        let user = self.users[indexPath.row]
        cell.displayName.text = user.displayName
        cell.descriptionLabel.text = user.userDescription
        cell.chargeLabel.text = Rs + String(format: "%.1f", user.pricePerHours) + "/hour"
        cell.lessonsLabel.text = "\(user.callsDataHome.totalCalls) Calls"
        cell.tutorImage.sd_setImage(with: URL(string:user.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "profile_icon"))

        cell.tagButton = user.skills.compactMap({ self.makeButton($0.skill.uppercased()) })
        return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.users.count == 0{return}
        let aUser = self.users[indexPath.row]
        self.getProUserDetail(userID: aUser.ID)
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

    
    func navigateToProfileScreen(user:User){
        let profileVC = AppStoryboard.Learner.viewController(ProfileViewController.self)
        profileVC.user =  user
        self.navigationController?.pushViewController(profileVC, animated: true)
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
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
                    searchBar.resignFirstResponder()

    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tableview{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if self.perPage > self.users.count{return}
                if !isLoading{
                    if AppSettings.isConnectedToNetwork{
                        isLoading = true
                        self.page+=1
                        self.loadUsersFromServer(self.page, perPage: self.perPage, keyword: keywordSearch)
                    }
                }
            }
        }
    }

    
}

extension SearchUserViewController: UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSeachActive = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        AppSettings.shared.clearAllPendingRequests()
        self.page = 1
        isSeachActive = true
        self.isLoading = true
        
        self.users.removeAll()
        keywordSearch = searchBar.text!
        self.tableview.reloadData()
        self.loadUsersFromServer(self.page, perPage: self.perPage, keyword: searchBar.text!)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        AppSettings.shared.clearAllPendingRequests()
        self.page = 1
        self.isLoading = true
        isSeachActive = true
        keywordSearch = searchBar.text!
        self.users.removeAll()
        self.tableview.reloadData()
        self.loadUsersFromServer(self.page, perPage: self.perPage, keyword: searchBar.text!)
    }
}
