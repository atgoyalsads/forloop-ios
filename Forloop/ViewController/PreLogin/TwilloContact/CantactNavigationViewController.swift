//
//  CantactNavigationViewController.swift
//  Forloop
//
//  Created by Tecorb on 11/03/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit



class CantactNavigationViewController: UINavigationController {
    var forceToLogin = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isOpaque = false
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = UIColor.clear
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: fonts.Roboto.medium.font(.xXLarge),NSAttributedString.Key.foregroundColor:UIColor.black]
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.makeTransparent()
    }

    override var shouldAutorotate : Bool {
        return false
    }

    override var prefersStatusBarHidden : Bool {
        return false
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .none
    }
    

}


class TwilloVerifyNavigationViewController: UINavigationController {
    var forceToLogin = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isOpaque = false
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = UIColor.clear
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: fonts.Roboto.medium.font(.xXLarge),NSAttributedString.Key.foregroundColor:UIColor.black]
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.makeTransparent()
    }

    override var shouldAutorotate : Bool {
        return false
    }

    override var prefersStatusBarHidden : Bool {
        return false
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .none
    }
    

}

