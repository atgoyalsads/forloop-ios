//
//  AddCardViewController.swift
//  Fuel Delivery
//
//  Created by Parikshit on 01/10/19.
//  Copyright © 2019 Nakul Sharma. All rights reserved.
//



import UIKit
import Stripe


protocol AddCardViewControllerDelegate {
    func addCard(viewController: AddCardViewController, didAddedCard card: Payment)
}

class AddCardViewController : UIViewController {
    @IBOutlet weak var cardNumberTextField : BKCardNumberField!
    @IBOutlet weak var cardHolderNameTextField : UITextField!
    @IBOutlet weak var ccvTextField : UITextField!
    @IBOutlet weak var expTextField : BKCardExpiryField!
    @IBOutlet weak var containnerView : UIView!
    @IBOutlet weak var payButton : UIButton!
//    @IBOutlet weak var cardLabel:UILabel!
    //@IBOutlet weak var cardImage:UIImageView!

    var delegate: AddCardViewControllerDelegate?
    var shouldBackToBooking: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CardIOUtilities.preload()
        self.setupAllView()
        self.navigateToScanCard()
        cardNumberTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        cardNumberTextField.delegate = self
    }
    override func viewDidLayoutSubviews() {
        CommonClass.makeViewCircularWithCornerRadius(payButton, borderColor: .clear, borderWidth: 0, cornerRadius: payButton.frame.size.height/2)
        
//        payButton.dropShadow(shadowColor: appColor.payoutBlue, shadowRadius: 0, shadowOpacity: 1, shadowOffset: CGSize(width: 0, height: 5))
    }
    func setupAllView(){
        cardNumberTextField.showsCardLogo = false
        cardNumberTextField.cardNumberFormatter.groupSeparater = "-"
//        CommonClass.makeViewCircularWithCornerRadius(self.containnerView, borderColor: appColor.brown, borderWidth: 1, cornerRadius: 2)
//        CommonClass.makeViewCircularWithCornerRadius(self.cardNumberTextField, borderColor: UIColor.groupTableViewBackground, borderWidth: 1, cornerRadius: 1)
//        CommonClass.makeViewCircularWithCornerRadius(self.cardHolderNameTextField, borderColor: UIColor.groupTableViewBackground, borderWidth: 1, cornerRadius: 1)
//        self.cardHolderNameTextField.setLeftPaddingPoints(5)
//        CommonClass.makeViewCircularWithCornerRadius(self.ccvTextField, borderColor: appColor.brown, borderWidth: 1, cornerRadius: 1)
        self.ccvTextField.setLeftPaddingPoints(5)
        
       // CommonClass.makeViewCircularWithCornerRadius(self.expTextField, borderColor:appColor.brown, borderWidth: 1, cornerRadius: 1)
        self.expTextField.setLeftPaddingPoints(5)
        
        CommonClass.makeViewCircularWithCornerRadius(self.payButton, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 2)
    }
    
    @IBAction func onClickScanCard(_ sender: UIButton){
        self.navigateToScanCard()
    }
    
    func navigateToScanCard(){
        let scanCardVC = AppStoryboard.Payment.viewController(ScanCardViewController.self)
        scanCardVC.delegate = self
        let nav = AppSettings.shared.getNavigation(vc: scanCardVC)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    
    
    @IBAction func onClickBackButton(_ sender: UIBarButtonItem){
        if shouldBackToBooking{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.pop(true)
        }
    }
    
    @IBAction func onClickPayButton(_ sender: UIButton){
//                let callVC = AppStoryboard.Learner.viewController(CallViewController.self)
//                self.navigationController?.pushViewController(callVC, animated: true)
        return
        self.payButton.isEnabled = false
        self.view.endEditing(true)
        guard let cardNumber = self.cardNumberTextField.cardNumber  else {
            self.payButton.isEnabled = true
            return
        }
        if cardNumber.count < 14{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.validCardNumber.rawValue)
            self.payButton.isEnabled = true
            
            return
        }
        if cardHolderNameTextField.text == nil || cardHolderNameTextField.text?.count == 0{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.cardHolderName.rawValue)
            self.payButton.isEnabled = true
            
            return
        }
        guard let cardHolderName = self.cardHolderNameTextField.text?.trimmingCharacters(in: .whitespaces) else{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.cardHolderName.rawValue)
            
            self.payButton.isEnabled = true
            
            return
        }
        
        guard let cardNumberFormatter = self.cardNumberTextField.cardNumberFormatter else{
            self.payButton.isEnabled = true
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.cardDeclined.rawValue)
            return
        }
        
        guard let cardPattern = cardNumberFormatter.cardPatternInfo else {
            self.payButton.isEnabled = true
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "Please enter a valid card number")
            return
        }
        guard let brand = cardPattern.companyName else {
            self.payButton.isEnabled = true
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.cardDeclined.rawValue)
            return
        }
        
        if ccvTextField.text == nil || ccvTextField.text!.count < 3 || ccvTextField.text!.count > 4 {
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.enterCVV.rawValue)
            self.payButton.isEnabled = true
            
            return
        }
        guard let cvv = self.ccvTextField.text?.trimmingCharacters(in: .whitespaces) else{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.enterCVV.rawValue)
            self.payButton.isEnabled = true
            
            return
        }
        guard let expMonth = self.expTextField.dateComponents.month else{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.expMonth.rawValue)
            self.payButton.isEnabled = true
            
            return
        }
        guard let expYear = self.expTextField.dateComponents.year else{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.expYear.rawValue)
            self.payButton.isEnabled = true
            
            return
        }
        
        let inputValidation = self.validteCardInputs(cardNumber, cardHolderName: cardHolderName, brand: brand, expMonth: expMonth, expYear: expYear, CVV: cvv)
        if !inputValidation.success{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: inputValidation.message)
            self.payButton.isEnabled = true
            return
        }
        
        let success = self.validateCardParams(cardNumber, cardHolderName: cardHolderName, expMonth: UInt(expMonth ), expYear: UInt(expYear ), CVV: cvv)
        if !success{
            NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: warningMessage.cardDeclined.rawValue)
            self.payButton.isEnabled = true
            
            return
        }
        
        self.createTokenWith(cardNumber, cardHolderName: cardHolderName, expMonth: UInt(expMonth), expYear: UInt(expYear), CVV: cvv)
    }
    
    func createTokenWith(_ cardNumber:String,cardHolderName:String,expMonth: UInt,expYear:UInt,CVV:String){
        
        AppSettings.shared.showLoader(withStatus: "Creating..")
        let cardParams = STPCardParams()
        cardParams.number = cardNumber
        if cardHolderName.count != 0{
            cardParams.name = cardHolderName
        }
        cardParams.expMonth = expMonth
        cardParams.expYear = expYear
        cardParams.cvc = CVV
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (stpToken, error) in
            if error != nil{
                AppSettings.shared.hideLoader()
                NKToastHelper.sharedInstance.showErrorAlert(self, message:"\(String(describing: error!.localizedDescription))" )
                self.payButton.isEnabled = true
                return
            }else{
                guard let token = stpToken else{
                    AppSettings.shared.hideLoader()
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: warningMessage.cardDeclined.rawValue)
                    self.payButton.isEnabled = true
                    return
                }
                AppSettings.shared.updateLoader(withStatus: "Saving..")
                self.createCardFor(sourceToken: token.tokenId)
            }
        }
    }
    
    
    func validteCardInputs(_ cardNumber:String,cardHolderName:String,brand:String,expMonth: Int?,expYear:Int?,CVV:String) -> (success:Bool,message:String) {
        if cardNumber.count == 0{
            return(false,warningMessage.validCardNumber.rawValue)
        }
        
        if cardHolderName.count == 0{//Please enter the card holder's name
            return(false,warningMessage.cardHolderName.rawValue)
        }
        
        if let expMon = expMonth{
            if (expMon < 1) || (expMon > 12){return(false,warningMessage.validExpMonth.rawValue)}
        }else{
            return(false,warningMessage.expMonth.rawValue)
        }
        
        if let expY = expYear{
            if (expY < Date().year){return(false,warningMessage.validExpYear.rawValue)}
        }else{
            return(false,warningMessage.expYear.rawValue)
        }
        
        if !brand.lowercased().contains("maestro"){
            if (CVV.count < 3) || (CVV.count > 4){return(false,warningMessage.enterCVV.rawValue)}
        }
        return(true,"")
        
    }
    
    func validateCardParams(_ cardNumber:String,cardHolderName:String,expMonth: UInt,expYear:UInt,CVV:String) -> Bool {
        let cardParams = STPCardParams()
        cardParams.number = cardNumber
        if cardHolderName.count != 0{
            cardParams.name = cardHolderName
        }
        cardParams.expMonth = expMonth
        cardParams.expYear = expYear
        cardParams.cvc = CVV
        let validationState = STPCardValidator.validationState(forCard: cardParams)
        return (validationState != .invalid)
    }
    
    func createCardFor(sourceToken:String){
        PaymentService.sharedInstance.addCard(sourceToken) { (success, resCard,message)  in
            AppSettings.shared.hideLoader()
            if success{
                if let aCard = resCard{
                    NotificationCenter.default.post(name: .USER_DID_ADD_NEW_CARD_NOTIFICATION, object: nil, userInfo: ["card":aCard])
                    self.delegate?.addCard(viewController: self, didAddedCard: aCard)
                }else{
                    self.payButton.isEnabled = true
                    NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
                }
            }else{
                self.payButton.isEnabled = true
                NKToastHelper.sharedInstance.showErrorAlert(self, message: message)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AddCardViewController: ScanCardViewControllerDelegate{
    func cardDidScan(viewcontroller: ScanCardViewController, withCardInfo cardInfo: CardIOCreditCardInfo) {
        if let cardNumber = cardInfo.cardNumber{
            self.cardNumberTextField.cardNumber = cardNumber
        }else{
            self.cardNumberTextField.cardNumber = ""
        }
        if let ccv = cardInfo.cvv{
            self.ccvTextField.text = ccv
        }else{
            self.ccvTextField.text = ""
        }
        if let cardholderName = cardInfo.cardholderName{
            self.cardHolderNameTextField.text = cardholderName
        }else{
            self.cardHolderNameTextField.text = ""
        }
        
        if let expiryMonth = cardInfo.expiryMonth as UInt?{
            if expiryMonth > 0{
                self.expTextField.dateComponents.month = Int(expiryMonth)
            }else{
                self.expTextField.text = ""
            }
        }else{
            self.expTextField.text = ""
        }
        if let expiryYear = cardInfo.expiryYear as UInt?{
            if expiryYear > 0{
                self.expTextField.dateComponents.year = Int(expiryYear)
            }else{
                self.expTextField.text = ""
            }
        }else{
            self.expTextField.text = ""
        }
    }
    
    func cardDidScan(viewcontroller: ScanCardViewController, isUserChooseManual wantManual: Bool) {
        if wantManual{
            self.cardNumberTextField.cardNumber = ""
            self.ccvTextField.text = ""
            self.cardHolderNameTextField.text = ""
            self.expTextField.text = ""
        }
    }
    
}


extension AddCardViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let iTxtFiled = textField as? BKCardNumberField{
            if iTxtFiled == cardNumberTextField{
                if iTxtFiled.text!.isEmpty{
                    //self.cardImage.isHidden = true
                }else{
                    //self.cardImage.image = iTxtFiled.cardLogoImageView.image
                   // self.cardImage.isHidden = false

                }

            }
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let iTxtFiled = textField as? BKCardNumberField{
            if iTxtFiled == cardNumberTextField{
                if iTxtFiled.text!.isEmpty{
                   // self.cardImage.isHidden = true
                }else{
                    //self.cardImage.image = iTxtFiled.cardLogoImageView.image
                    //self.cardImage.isHidden = false
                    
                }
                
            }
        }
        
    }
    
    @objc  func textDidChanged(_ textField: UITextField) -> Void {
        if let iTxtFiled = textField as? BKCardNumberField{
            if iTxtFiled == cardNumberTextField{
                if iTxtFiled.text!.isEmpty{
                   // self.cardImage.isHidden = true
                }else{
                    //self.cardImage.image = iTxtFiled.cardLogoImageView.image
                   // self.cardImage.isHidden = false
                    
                }
                
            }
        }
        
    }

}



