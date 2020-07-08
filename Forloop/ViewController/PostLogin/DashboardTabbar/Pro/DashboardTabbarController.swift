//
//  DashboardTabbarController.swift
//  Forloop
//
//  Created by Tecorb on 09/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class DashboardTabbarController:UITabBarController,UITabBarControllerDelegate {
    var user : User!

    var homeTabButton : UITabBarItem!
    var callListTabButton : UITabBarItem!
    var chatListTabButton : UITabBarItem!
    var accountTabButton : UITabBarItem!

    var statusBarView : UIView!
    let titles = ["Home","Chat List","Call List","Account"]
    var selectedIndexTabBar:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self)
        self.user = User.loadSavedUser()

        self.tabBar.barTintColor = appColor.tabbarBackgroundColor
        self.tabBar.backgroundColor = appColor.tabbarBackgroundColor
        self.tabBar.tintColor = UIColor.black
//        self.tabBar.clipsToBounds = true
//        self.tabBar.selectionIndicatorImage = UIImage().makeImageWithColorAndSize(UIColor.clear, size: CGSize(width:tabBar.frame.width/5, height: tabBar.frame.height))

        homeTabButton = UITabBarItem()
//        homeTabButton.title = "Home"
        callListTabButton = UITabBarItem()
//        searchTabButton.title = "Search"
        chatListTabButton = UITabBarItem()
//        postTabButton.title = "Post"
        accountTabButton = UITabBarItem()
//        requestTabButton.title = "Notification"
        setUpTabBarElements()
        var homeVC = UIViewController()
        if self.user.selectedRole == SelectUserRole.learner.rawValue {
            homeVC = AppStoryboard.Learner.viewController(LearnerHomeViewController.self)
            homeVC.tabBarItem = homeTabButton
        } else {
            homeVC = AppStoryboard.Dashboard.viewController(HomeViewController.self)
            homeVC.tabBarItem = homeTabButton
        }

        let callListVC = AppStoryboard.Dashboard.viewController(CallListViewController.self)
        callListVC.tabBarItem = callListTabButton

        let chatListVC = AppStoryboard.Dashboard.viewController(ChatListViewController.self)
        chatListVC.tabBarItem = chatListTabButton

        let accountVC = AppStoryboard.Dashboard.viewController(AccountViewController.self)
        accountVC.tabBarItem = accountTabButton

        let vcs = [homeVC,chatListVC,callListVC,accountVC]

        self.viewControllers = vcs
        self.selectedIndexTabBar = 0
        self.selectedViewController = vcs[0]
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        setNeedsStatusBarAppearanceUpdate()
        self.delegate = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    
    

    override func viewWillLayoutSubviews() {

        var newTabBarFrame = tabBar.frame
        let newTabBarHeight: CGFloat = newTabBarFrame.size.height - 5//UIDevice.isIphoneX ? 146 : 64
        newTabBarFrame.size.height = newTabBarHeight
        newTabBarFrame.origin.y = self.view.frame.size.height - newTabBarHeight
        tabBar.frame = newTabBarFrame
    }
    
    

    override func viewDidLayoutSubviews() {

    }

    func setupViews(){
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }
    


    func setUpTabBarElements() {
        let selAttDict = [NSAttributedString.Key.foregroundColor:appColor.appBlueColor]
        let normalAttDict = [NSAttributedString.Key.foregroundColor:appColor.black]
        
//
        homeTabButton.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        callListTabButton.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        chatListTabButton.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        accountTabButton.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);

        self.homeTabButton.image = tabImages.homeNormal
        self.homeTabButton.selectedImage = tabImages.homeSelected
        self.homeTabButton.setTitleTextAttributes(selAttDict, for: .selected)
        self.homeTabButton.setTitleTextAttributes(normalAttDict, for: .normal)

        self.callListTabButton.image = tabImages.searchsNormal
        self.callListTabButton.selectedImage = tabImages.searchSelected
        self.callListTabButton.setTitleTextAttributes(selAttDict, for: .selected)
        self.callListTabButton.setTitleTextAttributes(normalAttDict, for: .normal)

        self.chatListTabButton.image = tabImages.postNormal
        self.chatListTabButton.selectedImage = tabImages.postSelected
        self.chatListTabButton.setTitleTextAttributes(selAttDict, for: .selected)
        self.chatListTabButton.setTitleTextAttributes(normalAttDict, for: .normal)

        self.accountTabButton.image = tabImages.notificationtNormal
        self.accountTabButton.selectedImage = tabImages.notificationSelected
        self.accountTabButton.setTitleTextAttributes(selAttDict, for: .selected)
        self.accountTabButton.setTitleTextAttributes(normalAttDict, for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let item = viewController.tabBarItem
        if item == homeTabButton{
            self.selectedIndexTabBar = 0
            //self.title = "Home"


        }else if item == callListTabButton{
            self.selectedIndexTabBar = 1
            //self.title = "Call List"



        }else if item == chatListTabButton{
            self.selectedIndexTabBar = 2
           //self.title = "Chat List"



        }else{
            self.selectedIndexTabBar = 3
           //self.title = "Account"
        }

    }

}


struct tabImages {
    static let homeSelected = UIImage(named:"Home_sel")?.withRenderingMode(.alwaysOriginal)
    static let homeNormal = UIImage(named:"home_unsel")?.withRenderingMode(.alwaysOriginal)

    static let searchSelected = UIImage(named:"call_sel")?.withRenderingMode(.alwaysOriginal)
    static let searchsNormal = UIImage(named:"call_unsel")?.withRenderingMode(.alwaysOriginal)

    static let postSelected = UIImage(named:"chat_sel")?.withRenderingMode(.alwaysOriginal)
    static let postNormal = UIImage(named:"chat_unsel")?.withRenderingMode(.alwaysOriginal)

    static let notificationSelected = UIImage(named:"account_sel")?.withRenderingMode(.alwaysOriginal)
    static let notificationtNormal = UIImage(named:"account_unsel")?.withRenderingMode(.alwaysOriginal)
}



