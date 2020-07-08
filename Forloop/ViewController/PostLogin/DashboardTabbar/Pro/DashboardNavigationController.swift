//
//  DashboardNavigationController.swift
//  Forloop
//
//  Created by Tecorb on 09/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class DashboardNavigationController: UINavigationController {

//    override init(rootViewController: UIViewController) {
//        super.init(rootViewController: rootViewController)
//    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        setNeedsStatusBarAppearanceUpdate()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isOpaque = false
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font:
            fonts.Roboto.medium.font(.large)]
        navigationBar.tintColor = .white
        setNeedsStatusBarAppearanceUpdate()
    }

    override var shouldAutorotate : Bool {
        return false
    }

    override var prefersStatusBarHidden : Bool {
        return false
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }

    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .none
    }

}

 
