//
//  AccountViewController.swift
//  Forloop
//
//  Created by Tecorb on 09/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import SDWebImage
import AWSCognitoIdentityProvider
import AWSMobileClient

class AccountViewController: UIViewController {
    @IBOutlet weak var aTableview:UITableView!
    
    var height:[CGFloat] = [160,70]
    var menuItems = ["Profile","Favourite","Payment Methods","Refer & Earn","Setting","Logout"]
    var user : User!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User.loadSavedUser()
        self.registerCells()
        self.view.backgroundColor = appColor.white
        self.aTableview.backgroundColor = appColor.white

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.user = User.loadSavedUser()
        self.aTableview.reloadData()

    }

    
    func registerCells() {
        let profileMenuNib = UINib(nibName: "ProfileLeftMenuCell", bundle: nil)
        self.aTableview.register(profileMenuNib, forCellReuseIdentifier: "ProfileLeftMenuCell")
        let profileNib = UINib(nibName: "UserAccountProfileCellTableViewCell", bundle: nil)
        self.aTableview.register(profileNib, forCellReuseIdentifier: "UserAccountProfileCellTableViewCell")
 

        self.aTableview.dataSource = self
        self.aTableview.delegate = self
        self.aTableview.reloadData()
    }
    
    
    func askForLogout() {

        let alert = UIAlertController(title: warningMessage.title.rawValue, message: "Do you really want to logout?", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Yes", style: .default){(action) in
            alert.dismiss(animated: true, completion: nil)
            self.logout()
        }
        let cancelAction = UIAlertAction(title: "Nope", style: .cancel){(action) in
            alert.dismiss(animated: true, completion: nil)
        }

        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    func logout(){
        AppSettings.shared.showLoader(withStatus: "Loading..")
        LogInService.sharedInstance.logOut() { (success, user, message) in
            AppSettings.shared.hideLoader()
            if success{
                AWSMobileClient.default().signOut()
                AppSettings.shared.isLoggedIn = false
                NKToastHelper.sharedInstance.showErrorAlert(nil, message: "You have logged out successfully")
                AppSettings.shared.proceedToLoginModule()
            }
        }

    }
    
    @IBAction func onClickSwitchProfileButton(_ sender:UIButton) {
        if  self.user.selectedRole == SelectUserRole.learner.rawValue{
            self.askForSwitchProfile(message: "Are you sure you want to switch on Pro Profile", switchUser: SelectUserRole.pro.rawValue)
        }else{
            self.askForSwitchProfile(message: "Are you sure you want to switch on Seeker Profile", switchUser: SelectUserRole.learner.rawValue)
        }
    }
    
    
    func askForSwitchProfile(message:String,switchUser:String) {

        let alert = UIAlertController(title: warningMessage.title.rawValue, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Yes", style: .default){(action) in
            alert.dismiss(animated: true, completion: nil)
            self.selectUserRole(role: switchUser)
        }
        let cancelAction = UIAlertAction(title: "Nope", style: .cancel){(action) in
            alert.dismiss(animated: true, completion: nil)
        }

        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    


}

extension AccountViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return self.cellForUserAccountProfile(tableView: tableView, indexPath: indexPath)
        }else{
            return self.cellForProfileLeftMenu(tableView: tableView, indexPath: indexPath)

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height[indexPath.section]
    }
    
    
    
    func cellForUserAccountProfile(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserAccountProfileCellTableViewCell", for: indexPath) as! UserAccountProfileCellTableViewCell
        cell.nameLabel.text = self.user.fname + " " + self.user.lname
        cell.descriptionLabel.text =  self.user.userDescription
        if self.user.selectedRole == SelectUserRole.learner.rawValue{
            cell.switchProfileButton.setTitle("  Switch to Pro Profile  ", for: .normal)
        }else{
            cell.switchProfileButton.setTitle("  Switch to Seeker Profile  ", for: .normal)

        }
        cell.switchProfileButton.addTarget(self, action: #selector(onClickSwitchProfileButton(_:)), for: .touchUpInside)
        cell.profileImage.sd_setImage(with: URL(string:self.user.image) ?? URL(string: BASE_URL)!, placeholderImage: UIImage(named: "profile_icon"))
        
        return cell
    }
    
    func selectUserRole(role:String){
        if !AppSettings.isConnectedToNetwork{
          NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
             return
         }
        AppSettings.shared.showLoader(withStatus: "Loading..")
        LogInService.sharedInstance.selectUserRole(role) { (success, resUser,message) in
            AppSettings.shared.hideLoader()
            if success{
                if let aUser = resUser{
                    self.user = aUser
                        AppSettings.shared.proceedToDashboard()

                }else{
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: message)

                }
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }
        
        
    }
    
    func navigateToAddProfileScreen(){
        if self.user.selectedRole == SelectUserRole.learner.rawValue {
            let profileVC = AppStoryboard.Learner.viewController(LearnerDisplayNameViewController.self)
            profileVC.isEdit = true
            self.navigationController?.pushViewController(profileVC, animated: true)
        }else{
            let profileVC = AppStoryboard.Main.viewController(UserAddProfilePictureViewController.self)
            profileVC.isEdit = true
            self.navigationController?.pushViewController(profileVC, animated: true)

        }

    }
    
    
    func cellForProfileLeftMenu(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileLeftMenuCell", for: indexPath) as! ProfileLeftMenuCell
        cell.nameLabel.text = self.menuItems[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{return}
        switch indexPath.row {
        case 0:
            self.navigateToAddProfileScreen()
//            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.functionalityPending.rawValue)
//            return
        case 1:
            //if !AppSettings.shared.isLearner {
                let favouriteVC = AppStoryboard.Learner.viewController(FavouriteViewController.self)
                self.navigationController?.pushViewController(favouriteVC, animated: true)
//            } else {
//                return
//            }
        case 2:
            let referVC = AppStoryboard.Payment.viewController(PaymentOptionViewController.self)
            self.navigationController?.pushViewController(referVC, animated: true)

        case 3:
            let referVC = AppStoryboard.Dashboard.viewController(ReferEarnViewController.self)
            self.navigationController?.pushViewController(referVC, animated: true)
        case 4:
            let settingVC = AppStoryboard.Dashboard.viewController(SettingViewController.self)
            self.navigationController?.pushViewController(settingVC, animated: true)
        case 5:
            self.askForLogout()
        default:
            break
        }
    }
    
    
}
