//
//  PaymentService.swift
//  Fuel Delivery
//
//  Created by Parikshit on 09/10/19.
//  Copyright © 2019 Nakul Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Stripe

class PaymentService {
    static let sharedInstance = PaymentService()
    fileprivate init() {}
    private func makeFullMobileNumber(cc:String,mobileNumber:String) -> String{
        var fullMobile = ""
        if mobileNumber.contains("+"){
            fullMobile = mobileNumber
        }else{
            fullMobile = cc+mobileNumber
        }
        return fullMobile
    }
    
    
    
    
    
    func getCardsForUser(selectRole:String,completionBlock:@escaping (_ success:Bool,_ cards: Array<Payment>?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["selectedRole":"pro"]
        
        print_debug("hitting \(api.getCards.url()) with and headers :\(head) and params: \(params)")
        Alamofire.request(api.getCards.url(),method: .post,parameters: params, encoding:JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("cards json is:\n\(json)")
                    let cardParser = PaymentParser(json)
                    if cardParser.errorCode == .sessionExpire{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                    }else if cardParser.errorCode == .forceUpdate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showForceUpdateAlert()
                    }else if cardParser.errorCode == .accountDeactivate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.accountDeactivateAndShowToLoginPage(message: cardParser.responseMessage)
                    } else{
                        completionBlock((cardParser.errorCode == .success),cardParser.cards,cardParser.responseMessage)
                    }
                }else{
                    completionBlock(false,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
            case .failure(let error):
                let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
                print_debug(message)
                completionBlock(false,nil,error.localizedDescription)
            }
        }
    }
    
    func removeCard(_ cardID:String,completionBlock:@escaping (_ success:Bool,_ message: String) -> Void){
        
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["card_id":cardID]
        print_debug("hitting \(api.removeCard.url()) and headers :\(head)")
        
        Alamofire.request(api.removeCard.url(),method: .post, parameters: params,headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("remove card json is:\n\(json)")
                    let cardParser = PaymentParser(json)
                    if cardParser.errorCode == .sessionExpire{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                    }else if cardParser.errorCode == .forceUpdate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showForceUpdateAlert()
                    }else if cardParser.errorCode == .accountDeactivate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.accountDeactivateAndShowToLoginPage(message: cardParser.responseMessage)
                    }else{
                        completionBlock(cardParser.errorCode == .success,cardParser.responseMessage)
                    }
                }else{
                    completionBlock(false,"Oops! Something went wrong")
                }
            case .failure(let error):
                let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
                print_debug(message)
                completionBlock(false,"Oops!\r\n\(error.localizedDescription)")
            }
        }
    }
    
    
    func defaultCard(_ cardID:String,completionBlock:@escaping (_ success:Bool, _ card: Payment?,_ message: String) -> Void){
        
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["card_id":cardID]
        print_debug("hitting \(api.defaultCard.url()) and headers :\(head)")
        
        Alamofire.request(api.defaultCard.url(),method: .post, parameters: params,headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("default card json is:\n\(json)")
                    let cardParser = PaymentParser(json)
                    if cardParser.errorCode == .sessionExpire{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                    }else if cardParser.errorCode == .forceUpdate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showForceUpdateAlert()
                    }else if cardParser.errorCode == .accountDeactivate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.accountDeactivateAndShowToLoginPage(message: cardParser.responseMessage)
                    }else{
                        completionBlock(cardParser.errorCode == .success, cardParser.card, cardParser.responseMessage)
                    }
                }else{
                    completionBlock(false,nil,"Oops! Something went wrong")
                }
            case .failure(let error):
                let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
                print_debug(message)
                completionBlock(false,nil,"Oops!\r\n\(error.localizedDescription)")
            }
        }
    }
    
    
    func addCard(_ sourceToken : String, completionBlock:@escaping (_ success:Bool,_ card: Payment?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["stripe_token": sourceToken]
        print_debug("hitting \(api.addCard.url()) with and headers :\(head) and params: \(params)")
        
        Alamofire.request(api.addCard.url(),method: .post, parameters: params, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("deafult account json is:\n\(json)")
                    let cardParser = PaymentParser(json)
                    if cardParser.errorCode == .sessionExpire{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                    }else if cardParser.errorCode == .forceUpdate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showForceUpdateAlert()
                    }else if cardParser.errorCode == .accountDeactivate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.accountDeactivateAndShowToLoginPage(message: cardParser.responseMessage)
                    }else{
                        completionBlock(cardParser.errorCode == .success, cardParser.card, cardParser.responseMessage)
                    }
                }else{
                    completionBlock(false,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
            case .failure(let error):
                let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
                print_debug(message)
                completionBlock(false,nil,error.localizedDescription)
            }
        }
    }
    
    //    func payForRide(userID: String, cardID: String, stripeToken: String, rideID: String, amount: Double, completionBlock:@escaping(_ success:Bool,_ payment:Payment?, _ message: String) -> Void){
    //        let netAmount = Int(amount*100)
    //        let params = ["user_id":userID, "card_id":cardID, "ride_id":rideID, "amount":netAmount, "stripe_token":stripeToken] as [String : Any]
    //        let head =  AppSettings.shared.prepareHeader(withAuth: true)
    //        Alamofire.request(api.payRide.url(),method: .post ,parameters: params,headers:head).responseJSON { (response) in
    //            switch response.result {
    //            case .success:
    //                if let value = response.result.value {
    //                    let json = JSON(value)
    //                    print_debug(json)
    //                    let parser = PaymentParser(json: json)
    //                    if parser.errorCode == .forceUpdate{
    //                        AppSettings.shared.hideLoader()
    //                        AppSettings.shared.showForceUpdateAlert()
    //                    }else if parser.errorCode == .sessionExpire{
    //                        AppSettings.shared.hideLoader()
    //                        AppSettings.shared.showSessionExpireAndProceedToLandingPage()
    //                    }else{
    //                        completionBlock((parser.errorCode == .success), parser.payment, parser.message)
    //                    }
    //                }else{
    //                    completionBlock(false,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
    //                }
    //            case .failure(let error):
    //                let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
    //                print_debug(message)
    //                completionBlock(false,nil,error.localizedDescription)
    //            }
    //        }
    //
    //    }
    
    
    
}
