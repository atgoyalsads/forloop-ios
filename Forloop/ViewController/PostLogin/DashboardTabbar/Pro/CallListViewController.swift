//
//  CallListViewController.swift
//  Forloop
//
//  Created by Tecorb on 09/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import SDWebImage

class CallListViewController: UIViewController{

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var recentCallsLabel: UILabel!
    @IBOutlet weak var callListLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var user = User()
    var callHistory = [CallHistoryModel]()
    var page = 1
    var perPage = 10
    var isLoading = false
    var isSeachActive = false
    var keywordSearch = ""
//    var receiverUSer = User()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = appColor.backgroundAppColor//UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User.loadSavedUser()
        self.searchbar.placeholder = "Search"
        self.searchbar.delegate = self
        self.view.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
        self.tableview.addSubview(refreshControl)
//        self.loadCallHistoryData(self.page, perPage: self.perPage)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.page = 1
        self.callHistory.removeAll()
        self.tableview.reloadData()
        self.loadCallHistoryData(self.page, perPage: self.perPage)
    }
    
    func registerCells() {
        let callListTableViewCellNib = UINib(nibName: "CallListTableViewCell", bundle: nil)
        self.tableview.register(callListTableViewCellNib, forCellReuseIdentifier: "CallListTableViewCell")
        let noDataNib = UINib(nibName: "NoDataTableViewCell", bundle: nil)
        tableview.register(noDataNib, forCellReuseIdentifier: "NoDataTableViewCell")
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
            if !AppSettings.isConnectedToNetwork{
                refreshControl.endRefreshing()
                return
            }
            self.page = 1
            self.isLoading = true

        CallListService.sharedInstance.getAllCallHistory(page: page, perPage: perPage, searchKeyword: keywordSearch) { (success, resHistory, message) in
                self.isLoading = false
                self.callHistory.removeAll()
                refreshControl.endRefreshing()
                if success{
                    if let someHistory = resHistory{
                        self.callHistory.append(contentsOf: someHistory)
                    }
                    self.tableview.reloadData()
                }else{
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
                    self.tableview.reloadData()
                }
            }

        }
        

          
        
        func loadCallHistoryData(_ page: Int,perPage:Int) -> Void {
               if !AppSettings.isConnectedToNetwork{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
                   if self.page > 1{
                       self.page = self.page - 1
                   }
                AppSettings.shared.hideLoader()
                   return
               }
               self.isLoading = true
            CallListService.sharedInstance.getAllCallHistory(page: page, perPage: perPage, searchKeyword: keywordSearch) { (success, resHistory, message) in
                AppSettings.shared.hideLoader()
                   self.isLoading = false
                   if let someHistory = resHistory{
                       if someHistory.count == 0{
                           if self.page > 1{
                               self.page = self.page - 1
                           }
                       }
                       self.callHistory.append(contentsOf:someHistory)
                     
                   }else{
                       if self.page > 1{
                           self.page = self.page - 1
                       }
                   }
        
                   self.tableview.reloadData()
               }
           }
    
}

extension CallListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.callHistory.count == 0 ? 1 : self.callHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.callHistory.count == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as! NoDataTableViewCell
            cell.labelText.text = isLoading ? "Loading.." : "No history found"
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallListTableViewCell", for: indexPath) as! CallListTableViewCell
            cell.selectionStyle = .none
            let history = self.callHistory[indexPath.row]
            cell.callerNameLabel.text = history.user.displayName
            cell.callDurationLabel.text = "\(history.durationMinutes) minutes"
            cell.costLabel.text = String(format: "%.2f", history.totalPrice)
            cell.callDateLabel.text = CommonClass.formattedDateWithString(history.createdAt, format: "dd-MMMM-yyyy")//getDateFromDateString(history.createdAt, format: "dd-MMMM-yyyy")//history.createdAt
            cell.callerImage.sd_setImage(with: URL(string:history.user.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "user_placeholder"))
            cell.ratingLabel.text = String(format: "%.1f", history.rating)
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if self.user.selectedRole == SelectUserRole.learner.rawValue {
            if self.callHistory.count == 0 {return}
             let call = self.callHistory[indexPath.row]
            let callDetailScreen = AppStoryboard.Learner.viewController(LearnerCallDetailViewController.self)
            callDetailScreen.call = call
            self.navigationController?.pushViewController(callDetailScreen, animated: true)

        } else {
            if self.callHistory.count == 0 {return}
            let call = self.callHistory[indexPath.row]
            self.navigateToCallDetail(call: call)
        }
    }
    
    func navigateToCallDetail(call:CallHistoryModel){
        
       let callDetailVC = AppStoryboard.Dashboard.viewController(CallDetailViewController.self)
        callDetailVC.call = call
        self.navigationController?.pushViewController(callDetailVC, animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tableview{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if self.perPage > self.callHistory.count{return}
                if !isLoading{
                    if AppSettings.isConnectedToNetwork{
                        isLoading = true
                        self.page+=1
                        self.loadCallHistoryData(self.page, perPage: self.perPage)
                    }
                }
            }
        }
    }
}

extension CallListViewController: UISearchBarDelegate{
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
        
        self.callHistory.removeAll()
        keywordSearch = searchBar.text!
        self.tableview.reloadData()
        self.loadCallHistoryData(self.page, perPage: self.perPage)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        AppSettings.shared.clearAllPendingRequests()
        self.page = 1
        self.isLoading = true
        isSeachActive = true
        keywordSearch = searchBar.text!
        self.callHistory.removeAll()
        self.tableview.reloadData()
        self.loadCallHistoryData(self.page, perPage: self.perPage)
    }
}
