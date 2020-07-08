//
//  FavouriteViewController.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 12/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import Tags

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var favouriteLabel: UILabel!
    @IBOutlet weak var navView: UIView!
    var tagArray = ["IOS","DEVELOPER","LEARN","IOS","DEVELOPER","LEARN"]
    var favouriteUsers = [User]()
    var page = 1
    var perPage = 10
    var isLoading = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = appColor.backgroundAppColor//UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navView.backgroundColor = .white
        self.tableview.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
        self.tableview.addSubview(refreshControl)
          self.loadFavouritesList(self.page, perPage: self.perPage)
        // Do any additional setup after loading the view.
    }
    
    func registerCells() {
        let favouriteTableViewCellnib = UINib(nibName: "FavouriteTableViewCell", bundle: nil)
        tableview.register(favouriteTableViewCellnib, forCellReuseIdentifier: "FavouriteTableViewCell")
        let noDataNib = UINib(nibName: "NoDataTableViewCell", bundle: nil)
        tableview.register(noDataNib, forCellReuseIdentifier: "NoDataTableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    @IBAction func backTapped(_ sender: Any) {
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
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
               if !AppSettings.isConnectedToNetwork{
                   refreshControl.endRefreshing()
                   return
               }
               self.page = 1
               self.isLoading = true
           
        LearnerService.sharedInstance.getAllFavouritesList(page: page, perPage: perPage) { (success, resFavourites, message) in
                   self.isLoading = false
                   self.favouriteUsers.removeAll()
                   refreshControl.endRefreshing()
                   if success{
                       if let someFavourites = resFavourites{
                           self.favouriteUsers.append(contentsOf: someFavourites)
                       }
                       self.tableview.reloadData()
                   }else{
                       NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
                       self.tableview.reloadData()
                   }
               }

           }
           

             
           
           func loadFavouritesList(_ page: Int,perPage:Int) -> Void {
                  if !AppSettings.isConnectedToNetwork{
                   NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
                      if self.page > 1{
                          self.page = self.page - 1
                      }
                   AppSettings.shared.hideLoader()
                      return
                  }
                  self.isLoading = true
            LearnerService.sharedInstance.getAllFavouritesList(page: page, perPage: perPage) { (success, resFavourites, message) in
                   AppSettings.shared.hideLoader()
                      self.isLoading = false
                      if let someFavourites = resFavourites{
                          if someFavourites.count == 0{
                              if self.page > 1{
                                  self.page = self.page - 1
                              }
                          }
                          self.favouriteUsers.append(contentsOf:someFavourites)
                      }else{
                          if self.page > 1{
                              self.page = self.page - 1
                          }
                      }
           
                      self.tableview.reloadData()
                  }
              }
    
    
    
    @IBAction func onClickFavouriteButton(_ sender:UIButton){
        if let indexPath = sender.tableViewIndexPath(self.tableview){
            let fav = self.favouriteUsers[indexPath.row]
            self.askToRemoveFavouriteUser(user: fav, atIndexPath:indexPath)
        }
    }
    
    
    func askToRemoveFavouriteUser(user : User,atIndexPath indexPath: IndexPath) {
        let alert = UIAlertController(title: warningMessage.title.rawValue, message: "Would you really want to remove this user from favourite list", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Delete", style: .destructive){(action) in
            alert.dismiss(animated: true, completion: nil)
            self.addFavoutire(user: user, indexPath: indexPath)
            
        }
        
        let cancelAction = UIAlertAction(title: "Nope", style: .default){(action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func addFavoutire(user:User,indexPath:IndexPath){
        if !AppSettings.isConnectedToNetwork{
             NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
             return
         }
        AppSettings.shared.showLoader(withStatus: "Loading..")
        
        LearnerService.sharedInstance.addProFavourites(proUserId: user.ID) { (success, message) in
            AppSettings.shared.hideLoader()
            if success{
                self.favouriteUsers.remove(at: indexPath.row)
                self.tableview.reloadData()
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }
    }
    
    
    func navigateToProfileScreen(user:User){
        let profileVC = AppStoryboard.Learner.viewController(ProfileViewController.self)
        profileVC.user =  user
//        profileVC.callCategory = self.callCategory
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

extension FavouriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.favouriteUsers.count == 0 ? 100 :UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouriteUsers.count == 0 ? 1 : self.favouriteUsers.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.favouriteUsers.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as! NoDataTableViewCell
            cell.labelText.text = isLoading ? "Loading.." : "No favourite user found"
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as! FavouriteTableViewCell
        cell.selectionStyle = .none
            let favourite = self.favouriteUsers[indexPath.row]
            cell.tagButton = favourite.skills.compactMap({ self.makeButton($0.skill) })
            cell.titleLabel.text = favourite.displayName
            cell.descriptionLabel.text = favourite.userDescription
            cell.ratingLabel.text = "\(favourite.rating)"
            cell.tutorImage.sd_setImage(with: URL(string:favourite.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "user_placeholder"))
            cell.favouriteButton.addTarget(self, action: #selector(onClickFavouriteButton(_:)), for: .touchUpInside)

        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.favouriteUsers.count == 0{return}
        let favUser = self.favouriteUsers[indexPath.row]
        self.getProUserDetail(userID: favUser.ID)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tableview{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if self.perPage > self.favouriteUsers.count{return}
                if !isLoading{
                    if AppSettings.isConnectedToNetwork{
                        isLoading = true
                        self.page+=1
                        self.loadFavouritesList(self.page, perPage: self.perPage)
                    }
                }
            }
        }
    }
    
}
