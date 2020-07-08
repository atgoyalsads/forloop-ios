//
//  UIViewControllerExtension.swift
//  RideApp
//
//  Created by Nakul Sharma on 31/05/19.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

extension UINavigationController {
    func pop(_ animated: Bool) {
        _ = self.popViewController(animated: animated)
    }

    func popToRoot(_ animated: Bool) {
        _ = self.popToRootViewController(animated: animated)
    }

    func makeTransparent(){
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = UIColor.clear
        self.navigationBar.tintColor = UIColor.clear
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: fonts.Roboto.bold.font(.large)]
    }
    
    func makeAppColorNav(){
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = appColor.backgroundAppColor
        self.navigationBar.tintColor = appColor.backgroundAppColor
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: fonts.Roboto.bold.font(.large)]
    }

    
    func clearShadowLine(){
        self.navigationBar.shadowImage = UIImage()
    }
}

extension UIViewController {

    class var storyboardID : String {
        return "\(self)"
    }
    static func instantiate(fromAppStoryboard appStoryboard : AppStoryboard) -> Self {
        return appStoryboard.viewController(self)
    }

    func addLeftNavBarButton(_ image: UIImage? = nil){
        
    }
}


enum AppStoryboard : String {

    case Main, Dashboard, Learner, Payment,Contact

    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T : UIViewController>(_ viewControllerClass : T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }

    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}


extension UIViewController{
    func isModal() -> Bool {
        if let navigationController = self.navigationController{
            if navigationController.viewControllers.first != self{
                return false
            }
        }

        if self.presentingViewController != nil {
            return true
        }

        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }

        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}


extension UIViewController {
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }

    private func topViewController(currentViewController: UIViewController) -> UIViewController {
        if let tabBarController = currentViewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(currentViewController: selectedViewController)
        } else if let navigationController = currentViewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(currentViewController: visibleViewController)
        } else if let presentedViewController = currentViewController.presentedViewController {
            return self.topViewController(currentViewController: presentedViewController)
        } else {
            return currentViewController
        }
    }
}

//extension UINavigationController:UIGestureRecognizerDelegate{
//    func setPopSlide(){
//    self.interactivePopGestureRecognizer?.delegate = nil
//    self.interactivePopGestureRecognizer?.isEnabled = true
//    }
//    func removePopSlide() {
//        self.interactivePopGestureRecognizer?.delegate = self
//        self.interactivePopGestureRecognizer?.isEnabled = true
//    }
//    
//}
