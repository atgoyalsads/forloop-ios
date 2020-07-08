//
//  LearnerCategoryListViewController.swift
//  Forloop
//
//  Created by Tecorb on 27/03/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit

class LearnerCategoryListViewController: UIViewController{

    @IBOutlet weak var tableview: UITableView!
    var page = 1
    var perPage = 10
    var isLoading = false
    var categories = [CategoryModel]()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = appColor.backgroundAppColor//UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.tableview.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
        self.tableview.addSubview(refreshControl)
        self.loadCategoryList(self.page, perPage: self.perPage)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }
    
    func registerCells() {
        let callListTableViewCellNib = UINib(nibName: "LearnerCategoryTableViewCell", bundle: nil)
        self.tableview.register(callListTableViewCellNib, forCellReuseIdentifier: "LearnerCategoryTableViewCell")
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

            LearnerService.sharedInstance.loadSeekerCategoList(page: self.page, perPage: self.perPage) { (success, resCategoyList, message) in
                self.isLoading = false
                self.categories.removeAll()
                refreshControl.endRefreshing()
                if success{
                    if let someCategoyList = resCategoyList{
                        self.categories.append(contentsOf: someCategoyList)
                    }
                    self.tableview.reloadData()
                }else{
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
                    self.tableview.reloadData()
                }
            }

        }
        

          
        
    func loadCategoryList(_ page: Int,perPage:Int) -> Void {
        if !AppSettings.isConnectedToNetwork{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
            if self.page > 1{
                self.page = self.page - 1
            }
            AppSettings.shared.hideLoader()
                return
            }
            self.isLoading = true
            LearnerService.sharedInstance.loadSeekerCategoList(page: self.page, perPage: self.perPage) { (success, resCategoyList, message) in
            self.isLoading = false
            if let someCategory = resCategoyList{
                if someCategory.count == 0{
                    if self.page > 1{
                    self.page = self.page - 1
                }
             }
            self.categories.append(contentsOf:someCategory)
                }else{
                 if self.page > 1{
                    self.page = self.page - 1
                }
            }
        
                   self.tableview.reloadData()
               }
           }
    
    
    @IBAction func onClickBackButton(_ sender:UIButton){
        self.navigationController?.pop(true)
    }

    
}

extension LearnerCategoryListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count == 0 ? 1 : self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.categories.count == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as! NoDataTableViewCell
            cell.labelText.text = isLoading ? "Loading.." : "No category found"
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LearnerCategoryTableViewCell", for: indexPath) as! LearnerCategoryTableViewCell
            cell.selectionStyle = .none
            let category = self.categories[indexPath.row]
            cell.categoryLabel.text = category.title
            switch indexPath.item % 4 {
            case 0:
                cell.categoryimage.image = UIImage(named: "Group1")
            case 1:
                cell.categoryimage.image = UIImage(named: "Group2")
            case 2:
                cell.categoryimage.image = UIImage(named: "Group3")
            case 3:
                cell.categoryimage.image = UIImage(named: "Group4")
            default:
                cell.categoryimage.image = UIImage(named: "Group1")
            }

        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
                if self.perPage > self.categories.count{return}
                if !isLoading{
                    if AppSettings.isConnectedToNetwork{
                        isLoading = true
                        self.page+=1
                        self.loadCategoryList(self.page, perPage: self.perPage)
                    }
                }
            }
        }
    }
}

