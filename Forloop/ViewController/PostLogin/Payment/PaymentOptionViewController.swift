//
//  PaymentOptionViewController.swift
//  Fuel Delivery
//
//  Created by Parikshit on 01/10/19.
//  Copyright © 2019 Nakul Sharma. All rights reserved.
//

import UIKit
import Stripe
import MGSwipeTableCell

protocol PaymentOptionViewControllerDelegate {
    func selectCardPayment(viewController: PaymentOptionViewController, didAddedCard card: Payment)
}

class PaymentOptionViewController: UIViewController {
    @IBOutlet weak var aTableView:UITableView!
    @IBOutlet weak var addCardButton:UIButton!
    var delegate: PaymentOptionViewControllerDelegate?
    var selectedIndex = -1
    var user = User()


    var cards = Array<Payment>()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = appColor.brown
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User.loadSavedUser()
        self.title = ""
        self.view.backgroundColor = .groupTableViewBackground
        self.aTableView.backgroundColor = .groupTableViewBackground

        //self.aTableView.addSubview(refreshControl)
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentOptionViewController.userDidAddNewCardHandler(_:)), name: .USER_DID_ADD_NEW_CARD_NOTIFICATION, object: nil)
        self.registerCells()
        //self.getUserCards(selectRole:self.user.selectedRole.lowercased() == SelectUserRole.pro.rawValue.lowercased() ? SelectUserRole.pro.rawValue.lowercased() :  SelectUserRole.learner.rawValue.lowercased())
        
        // Do any additional setup after loading the view.
    }
    
    func registerCells() {
        let paymentOptionNib = UINib(nibName: "PaymentsOptionsTableViewCell", bundle: nil)
        aTableView.register(paymentOptionNib, forCellReuseIdentifier: "PaymentsOptionsTableViewCell")
        let noDataNib = UINib(nibName: "NoDataTableViewCell", bundle: nil)
        aTableView.register(noDataNib, forCellReuseIdentifier: "NoDataTableViewCell")
        let selectPaymentOptionNib = UINib(nibName: "SelectPaymentCellTableViewCell", bundle: nil)
        aTableView.register(selectPaymentOptionNib, forCellReuseIdentifier: "SelectPaymentCellTableViewCell")
        aTableView.dataSource = self
        aTableView.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
    CommonClass.makeViewCircularWithCornerRadius(addCardButton, borderColor: .clear, borderWidth: 0, cornerRadius: addCardButton.frame.size.height/2)
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if !AppSettings.isConnectedToNetwork{
            refreshControl.endRefreshing()
            return
        }
        self.refreshControl.endRefreshing()
        self.getUserCards(selectRole:self.user.selectedRole.lowercased() == SelectUserRole.pro.rawValue.lowercased() ? SelectUserRole.pro.rawValue.lowercased() :  SelectUserRole.learner.rawValue.lowercased())
    }
    @objc func userDidAddNewCardHandler(_ notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String,Payment>{
            if let aCard = userInfo["card"]{
                let duplicateCards = self.cards.filter({ (card) -> Bool in
                    return aCard.id == card.id
                })
                
                if duplicateCards.count == 0{
                    for var card in self.cards{
                        card.isDefault = false
                    }
                    self.cards.append(aCard)
                    self.aTableView.reloadData()
                    self.navigationController?.pop(true)
                }else{
                    NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "The card you have entered is already exists") {
                        self.navigationController?.pop(true)
                    }
                }
            }
        }
    }
    
    func getUserCards(selectRole:String) -> Void {
        AppSettings.shared.showLoader(withStatus: "Loading..")
        PaymentService.sharedInstance.getCardsForUser(selectRole: selectRole) { (success,resCards,message)  in
            AppSettings.shared.hideLoader()
            if let someCards = resCards{
                self.cards.removeAll()
                self.cards.append(contentsOf: someCards)
                self.aTableView.reloadData()
            }
        }
    }
    
    @IBAction func onClickBackButton(_ sender:Any) {
        self.navigationController?.pop(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
   // override func viewDidAppear(_ animated: Bool) {
   //     self.navigationController?.navigationBar.isHidden = true

   // }
    
    @IBAction func onClickAddCardButton(_ sender:UIButton) {
        let addCardVC = AppStoryboard.Payment.viewController(AddCardViewController.self)
        self.navigationController?.pushViewController(addCardVC, animated: true)
    }
    
    @IBAction func onClickDefaultCardButton(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
//        let callVC = AppStoryboard.Learner.viewController(CallViewController.self)
//        self.navigationController?.pushViewController(callVC, animated: true)
        
    }
    
}


extension PaymentOptionViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        //return (section == 0) ? cards.count : 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 70
            if indexPath.row == selectedIndex{
                height = 320
            }else{
                height = 70

            }
        return height
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedIndex == indexPath.row{
                
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPaymentCellTableViewCell", for: indexPath) as! SelectPaymentCellTableViewCell
            cell.selectButton.addTarget(self, action: #selector(onClickDefaultCardButton(_:)), for: .touchUpInside)
                return cell
        }else{
                
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsOptionsTableViewCell", for: indexPath) as! PaymentsOptionsTableViewCell
            
                return cell
        }


    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if self.cards.count == 0{return}
                if self.selectedIndex == indexPath.row{
                    self.selectedIndex = -1
                }else{
                    self.selectedIndex = indexPath.row
                }

                tableView.reloadData()

    }
    
    
    
    
    func navigateToAddNewCard(){
        let addNewPaymentOptionVC = AppStoryboard.Payment.viewController(AddCardViewController.self)
        self.navigationController?.pushViewController(addNewPaymentOptionVC, animated: true)
    }
    

    
    @IBAction func onClickRemoveButton(_ sender: UIButton){
        if let indexPath = sender.tableViewIndexPath(self.aTableView) as IndexPath?{
            let card = cards[indexPath.row]
            self.askToDeleteCard(card: card, atIndexPath: indexPath)
        }
    }
    
    func askToDeleteCard(card : Payment,atIndexPath indexPath: IndexPath) {
        let alert = UIAlertController(title: warningMessage.title.rawValue, message: "Would you really want to delete this card?", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Delete", style: .destructive){(action) in
            alert.dismiss(animated: true, completion: nil)
            self.removeCard(card, indexPath: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Nope", style: .default){(action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func removeCard(_ mycard:Payment?,indexPath: IndexPath) -> Void {
        guard let card = mycard else {
            return
        }
        AppSettings.shared.showLoader(withStatus: "Please wait..")
        PaymentService.sharedInstance.removeCard(card.id) { (success, message) in
            AppSettings.shared.hideLoader()
            if success{
                self.cards.remove(at: indexPath.row)
                self.aTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: message)
        }
        
    }
    
    
    
    
    func askToMakeDefualtCard(card : Payment,atIndexPath indexPath: IndexPath) {
        let alert = UIAlertController(title: warningMessage.title.rawValue, message: "Would you really want to make  this card default?", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Yes", style: .default){(action) in
            alert.dismiss(animated: true, completion: nil)
            self.makeDefaultCard(card, indexPath: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Nope", style: .cancel){(action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func makeDefaultCard(_ mycard:Payment?,indexPath: IndexPath) -> Void {
        guard let card = mycard else {
            return
        }
        AppSettings.shared.showLoader(withStatus: "Please wait..")
        PaymentService.sharedInstance.defaultCard(card.id) { (success,resCard, message) in
            AppSettings.shared.hideLoader()
            if success{
                if let defaultcard = resCard{
                    let indexOfCard = self.cards.firstIndex(where: { (aCard) -> Bool in
                        return aCard.id == defaultcard.id
                    })
                    guard let index = indexOfCard else {return}
                    self.cards[index].isDefault = true
                    self.aTableView.reloadData()
                    self.delegate?.selectCardPayment(viewController: self, didAddedCard: defaultcard)
                    self.navigationController?.pop(true)
                }else{
                    NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: message)
                }
            }else{
                NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: message)
            }
        }
        
    }
    
    
}


extension PaymentOptionViewController: MGSwipeTableCellDelegate{
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        self.aTableView.reloadData()
        return true
    }
    
    func rightButtonsForTableCell(_ indexPath: IndexPath) -> [MGSwipeButton]{
        // let deleteColor = kApplicationRedColor
        let swipeDeleteNib = Bundle.main.loadNibNamed("SwipeDeleteView", owner: self, options: nil)
        let delete = swipeDeleteNib?[0] as! SwipeDeleteView
        delete.deleteImageView.image = #imageLiteral(resourceName: "Group 261")
        //delete.deleteLabel.text = "Delete Car".localizedString
        delete.backgroundColor = appColor.bgColor
        delete.callback = { (cell) -> Bool in
            let removeCard = self.cards[indexPath.row]
            self.askToDeleteCard(card: removeCard, atIndexPath: indexPath)
           // self.removeCarFromList(carID: removeCar.id, indexPath: indexPath)
            
            return true
        }
        let buttonArray = [delete]
        return buttonArray
    }
}
