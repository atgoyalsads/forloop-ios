//
//  MainNavigationController.swift
//  TipNTap
//
//  Created by TecOrb on 22/01/18.
//  Copyright © 2018 Nakul Sharma. All rights reserved.
//

import UIKit



class MainNavigationController: UINavigationController {
    var forceToLogin = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isOpaque = false
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = appColor.backgroundAppColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: fonts.Roboto.medium.font(.xXLarge),NSAttributedString.Key.foregroundColor:UIColor.black]
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.makeAppColorNav()
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

