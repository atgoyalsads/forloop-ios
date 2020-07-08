//
//  SettingViewController.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 11/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableview: UITableView!
    let heightOfSections: [CGFloat] = [50,70,70]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColor.backgroundAppColor
        self.registerCells()
        // Do any additional setup after loading the view.
    }
    
    func registerCells() {
        let notificationTableViewCellNib = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        self.tableview.register(notificationTableViewCellNib, forCellReuseIdentifier: "NotificationTableViewCell")
        let notificationOnOffTableViewCellNib = UINib(nibName: "NotificationOnOffTableViewCell", bundle: nil)
        self.tableview.register(notificationOnOffTableViewCellNib, forCellReuseIdentifier: "NotificationOnOffTableViewCell")
        let accountTableViewCellNib = UINib(nibName: "AccountTableViewCell", bundle: nil)
        self.tableview.register(accountTableViewCellNib, forCellReuseIdentifier: "AccountTableViewCell")
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.pop(true)
    }
    
    
    func askForDeactivate(message:String) {

        let alert = UIAlertController(title: warningMessage.title.rawValue, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Yes", style: .default){(action) in
            alert.dismiss(animated: true, completion: nil)
            self.deactivateAccount()
        }
        let cancelAction = UIAlertAction(title: "Nope", style: .cancel){(action) in
            alert.dismiss(animated: true, completion: nil)
        }

        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    
    
    func deactivateAccount(){
        if !AppSettings.isConnectedToNetwork{
          NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.networkIsNotConnected.rawValue)
             return
         }
        AppSettings.shared.showLoader(withStatus: "Deactivate..")
        LogInService.sharedInstance.deactivatedAccount { (success, resUser,message) in
            AppSettings.shared.hideLoader()
            if success{
                    AppSettings.shared.proceedToLoginModule()
            }else{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }
        
        
    }


}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return heightOfSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfSections[indexPath.section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
            cell.selectionStyle = .none
            cell.headerLabel.text = "Notification"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationOnOffTableViewCell", for: indexPath) as! NotificationOnOffTableViewCell
            cell.selectionStyle = .none
            switch indexPath.row {
            case 0:
                cell.notificationName.text = "In App Notification"
            case 1:
                cell.notificationName.text = "Marketing/promotional Emails"
            default:
                cell.notificationName.text = "In App Notification"
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as! AccountTableViewCell
            cell.selectionStyle = .none
            switch indexPath.row {
            case 0:
                cell.accountLabel.text = "Deactivate Account"
            case 1:
                cell.accountLabel.text = "Delete Account"
            default:
                cell.accountLabel.text = "Deactivate Account"
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
            cell.selectionStyle = .none
            cell.headerLabel.text = "Notification"
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            switch indexPath.row {
            case 0:
                self.askForDeactivate(message: "Are you sure you want to deactivate your account")
                
            case 1:
                NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.functionalityPending.rawValue)
                return
            default:
                break
            }
        }

    }
    
    
}
