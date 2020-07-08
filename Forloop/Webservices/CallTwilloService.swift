//
//  MakeCallTwillo.swift
//  Forloop
//
//  Created by Tecorb on 12/02/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class CallTwilloService{
    static let sharedInstance = CallTwilloService()
    fileprivate init() {}
    
    
    
    func checkContactForTwillo( completionBlock:@escaping ( _ code:Int,  _ token: String?, _ message: String) -> Void){
         let head = AppSettings.shared.prepareHeader(withAuth: true)
         print_debug("hitting \(api.checkTwilloVerifyContact.url()) with and headers :\(head)")
         Alamofire.request(api.checkTwilloVerifyContact.url(),method: .get , encoding: JSONEncoding.default,headers:head).responseJSON { response in
             switch response.result {
             case .success:
                 if let value = response.result.value {
                     let json = JSON(value)
                     print_debug("check verify twillo contact json is:\n\(json)")
                     let parser = ForgotPasswordParser(json: json)
                    completionBlock(parser.code,parser.verificationCode,parser.responseMessage)
                 }else{
                     completionBlock(0,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                 }
             case .failure(let error):
                 let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
                 print_debug(message)
                 completionBlock(0,nil,error.localizedDescription)
             }
         }
     }
    

    func updateContactForTwillo(countryCode:String,contact:String, completionBlock:@escaping ( _ code:Int,  _ token: String?, _ message: String) -> Void){
         let head = AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["countryCode":countryCode,"contact":contact]

         print_debug("hitting \(api.updateTwilloVerifyContact.url()) with and headers :\(head) and params: \(params)")
         Alamofire.request(api.updateTwilloVerifyContact.url(),method: .post ,parameters: params, encoding: JSONEncoding.default,headers:head).responseJSON { response in
             switch response.result {
             case .success:
                 if let value = response.result.value {
                     let json = JSON(value)
                     print_debug("check verify twillo contact json is:\n\(json)")
                     let parser = ForgotPasswordParser(json: json)
                    completionBlock(parser.code,parser.verificationCode,parser.responseMessage)
                 }else{
                     completionBlock(0,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                 }
             case .failure(let error):
                 let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
                 print_debug(message)
                 completionBlock(0,nil,error.localizedDescription)
             }
         }
     }
    
    

    
    func getTwilloAccessToken(identity:String,completionBlock:@escaping (_ success:Bool,_ token:String,_ message:String) -> Void){
         let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["identity":identity]
         print_debug("hitting \(api.getTwilloAccessToken.url()) with headers :\(head) and params :\(params)")
         Alamofire.request(api.getTwilloAccessToken.url(),method: .post,parameters: params,encoding: JSONEncoding.default ,headers:head).responseJSON { response in
             switch response.result {
             case .success:
                 if let value = response.result.value {
                     let json = JSON(value)
                     print_debug("Access Token json is:\n\(json)")
                     let parser = TwilloModelParser(json)
                     if parser.errorCode == .sessionExpire{
                         AppSettings.shared.hideLoader()
                         AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                     }else if parser.errorCode == .forceUpdate{
                         AppSettings.shared.hideLoader()
                         AppSettings.shared.showForceUpdateAlert()
                     }else if parser.errorCode == .accountDeactivate{
                         AppSettings.shared.hideLoader()
                         AppSettings.shared.accountDeactivateAndShowToLoginPage(message: parser.message)
                     } else{
                         completionBlock((parser.errorCode == .success),parser.token,parser.message)
                     }
                 }else{
                     completionBlock(false,"",response.result.error?.localizedDescription ?? "Some thing went wrong")
                 }
             case .failure(let error):
                 let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
                 print_debug(message)
                 completionBlock(false,"",error.localizedDescription)
             }
         }
     }
    
    func placeCall(proId:String,callCategory:String,completionBlock:@escaping (_ success:Bool,_ userCall: CallHistoryModel?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["proId":proId,"callCategory":callCategory]

        print_debug("hitting \(api.placeCall.url()) with and headers :\(head) anf params: \(params)")
        Alamofire.request(api.placeCall.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("call historyList users json is:\n\(json)")
                    let parser = CallHistoryParser(json)
                    if parser.errorCode == .sessionExpire{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                    }else if parser.errorCode == .forceUpdate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showForceUpdateAlert()
                    } else if parser.errorCode == .accountDeactivate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.accountDeactivateAndShowToLoginPage(message: parser.message)
                    }else{
                        completionBlock((parser.errorCode == .success),parser.call,parser.message)
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
    
    
        func getCapibilityToken(clientName:String,completionBlock:@escaping (_ success:Bool,_ token: String,_ message:String) -> Void){
            let head =  AppSettings.shared.prepareHeader(withAuth: true)
            let params = ["clientName":clientName]
    
            print_debug("hitting \(api.getCapibilityToken.url()) with and headers :\(head) anf params: \(params)")
            Alamofire.request(api.getCapibilityToken.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print_debug("Capibility token is:\n\(json)")
                        let parser = TwilloModelParser(json)
                        if parser.errorCode == .sessionExpire{
                            AppSettings.shared.hideLoader()
                            AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                        }else if parser.errorCode == .forceUpdate{
                            AppSettings.shared.hideLoader()
                            AppSettings.shared.showForceUpdateAlert()
                        }else if parser.errorCode == .accountDeactivate{
                            AppSettings.shared.hideLoader()
                            AppSettings.shared.accountDeactivateAndShowToLoginPage(message: parser.message)
                        } else{
                            completionBlock((parser.errorCode == .success),parser.token,parser.message)
                        }
                    }else{
                        completionBlock(false,"",response.result.error?.localizedDescription ?? "Some thing went wrong")
                    }
                case .failure(let error):
                    let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
                    print_debug(message)
                    completionBlock(false,"",error.localizedDescription)
                }
            }
        }
    
    
    
    func newGenerateAccessToken(identity:String,completionBlock:@escaping (_ message:Any,_ success:Bool) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let url = "\(api.newAccessToken.url())?identity=\(identity)"

        print_debug("hitting \(url) with and headers :\(head)")
        Alamofire.request(url,method: .get, encoding: JSONEncoding.default, headers:head).responseString { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    print_debug("newAccessToken>>>>>>\(value)")
                    completionBlock(value, true)
                }else{
                    completionBlock("", false)
                }
            case .failure(let error):
                let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
                print_debug(message)
                completionBlock("", false)
            }
        }
    }
    

  
    
}
