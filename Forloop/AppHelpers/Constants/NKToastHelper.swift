//
//  NKToastHelper.swift
//  RideApp
//
//  Created by Nakul Sharma on 31/05/19.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

/*============== SHOW MESSAGE ==================*/
enum ToastPosition {
    case top,center,bottom
}

class NKToastHelper {
    let duration : TimeInterval = 1.5
    static let sharedInstance = NKToastHelper()
    fileprivate init() {}

    func showSuccessAlert(_ viewController: UIViewController?, message: String,completionBlock :(() -> Void)? = nil){
        self.showAlertWithViewController(viewController, title: warningMessage.title, message: message) {
            completionBlock?()
        }
    }
    
    func showAlert(_ viewController: UIViewController?,title:warningMessage, message: String,completionBlock :(() -> Void)? = nil){
        self.showAlertWithViewController(viewController, title: title, message: message) {
            completionBlock?()
        }
    }

    func showErrorAlert(_ viewController: UIViewController?, message: String, completionBlock :(() -> Void)? = nil){
        self.showAlertWithViewController(viewController, title: warningMessage.title, message: message) {
            completionBlock?()
        }
    }


    //complitionBlock : ((_ done: Bool) ->Void)? = nil

    private func showAlertWithViewController(_ viewController: UIViewController?, title: warningMessage, message: String,completionBlock :(() -> Void)? = nil){
        var toastShowingVC :UIViewController!

        if let vc = viewController{
            toastShowingVC = vc
        }else{
            toastShowingVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
        }
        let alert = UIAlertController(title: title.rawValue, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
            guard let handler = completionBlock else{
                alert.dismiss(animated: false, completion: nil)
                return
            }
            handler()
            alert.dismiss(animated: false, completion: nil)
        }

        alert.addAction(okayAction)
        alert.view.tintColor = .black
        toastShowingVC.present(alert, animated: true, completion: nil)
    }

/*
    private func showAlertWithViewController(_ viewController: UIViewController?, title: warningMessage, message: String,completionBlock :(() -> Void)? = nil, onCancelled cancellationBlock :(() -> Void)? = nil){
        var toastShowingVC :UIViewController!

        if let vc = viewController{
            toastShowingVC = vc
        }else{
            toastShowingVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
        }
        let alert = UIAlertController(title: title.rawValue, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel) { (action) in
            guard let handler = completionBlock else{
                alert.dismiss(animated: false, completion: nil)
                return
            }
            handler()
            alert.dismiss(animated: false, completion: nil)
        }

        alert.addAction(okayAction)

        if let cancellationHandler = cancellationBlock{
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (cancelAction) in
                cancellationHandler()
                alert.dismiss(animated: false, completion: nil)
            }
            alert.addAction(cancelAction)
        }


        toastShowingVC.present(alert, animated: true, completion: nil)
    }
 */

    func showErrorToast(message:String,completionBlock:@escaping () -> Void){

    }
    
    func showAlertWithReset(viewController: UIViewController?,message:String,title:String, complitionBlock : ((_ done: Bool) ->Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okayAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
            guard let handler = complitionBlock else{
                alert.dismiss(animated: false, completion: nil)
                return
            }
            handler(true)
            alert.dismiss(animated: false, completion: nil)
        }
        alert.addAction(okayAction)
        var vc: UIViewController
        if let pvc = viewController{
            vc = pvc
        }else{
            vc = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController)!
        }
        vc.present(alert, animated: true, completion: nil)
    }

}
