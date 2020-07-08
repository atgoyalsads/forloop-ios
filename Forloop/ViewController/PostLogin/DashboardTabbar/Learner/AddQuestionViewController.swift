//
//  AddQuestionViewController.swift
//  Forloop
//
//  Created by Tecorb on 27/02/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

protocol AddQuestionViewControllerDelegate {
   func addQuestionViewController(viewController:UIViewController,question:String,success:Bool)
}

class AddQuestionViewController: UIViewController {
    @IBOutlet weak var aTextView:RSKPlaceholderTextView!
    @IBOutlet weak var submitButton:UIButton!
    
    var question  = ""
    var delegate: AddQuestionViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.aTextView.placeholder = "Write question"
        self.view.backgroundColor = appColor.backgroundAppColor
        self.setStatusBar(backgroundColor: appColor.backgroundAppColor)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.makeAppColorNav()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.makeTransparent()

    }
    
    override func viewDidLayoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(submitButton, borderColor: .clear, borderWidth: 0)
    }
    
    @IBAction func onClickBackButton(_ sender:UIButton){
        self.navigationController?.pop(true)
        
    }
    
    @IBAction func onClickSubmitButton(_ sender:UIButton){
        if aTextView.text.isEmpty{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Please add your question")
            return
        }
        
        self.delegate?.addQuestionViewController(viewController: self, question: aTextView.text!, success: true)
    }
    

    func setStatusBar(backgroundColor: UIColor) {
           if #available(iOS 13, *)
           {
               let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
               statusBar.backgroundColor = backgroundColor
               UIApplication.shared.keyWindow?.addSubview(statusBar)
           } else {
              // ADD THE STATUS BAR AND SET A CUSTOM COLOR
              let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
              if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                 statusBar.backgroundColor = backgroundColor
              }
              UIApplication.shared.statusBarStyle = .lightContent
           }
       }
     

}
