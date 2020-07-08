//
//  CallListService.swift
//  Forloop
//
//  Created by Tecorb on 07/03/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class CallListService{
    static let sharedInstance = CallListService()
    fileprivate init() {}
        
    
    func getAllCallHistory(page:Int,perPage:Int,searchKeyword:String,completionBlock:@escaping (_ success:Bool,_ users: [CallHistoryModel]?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["page":"\(page)", "per_page":"\(perPage)","keyword":searchKeyword]

        print_debug("hitting \(api.getCallHistory.url()) with and headers :\(head) and params \(params)")
        Alamofire.request(api.getCallHistory.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
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
                        completionBlock((parser.errorCode == .success),parser.histories,parser.message)
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
    
    
    func callInitiate(receiverId:String,completionBlock:@escaping (_ success:Bool,_ userCall: CallHistoryModel?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["receiverId":receiverId]

        print_debug("hitting \(api.callInitiated.url()) with and headers :\(head) and params \(params)")
        Alamofire.request(api.callInitiated.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
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
    
    
    func getCallStatus(callID:String,status:String,completionBlock:@escaping (_ success:Bool,_ userCall: CallHistoryModel?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["callId":callID]
        var url = ""
        switch status {
        case CallStatus.ringing.rawValue:
            url = api.callConnected.url()
        case CallStatus.picked.rawValue:
            url = api.callPicked.url()
        case CallStatus.completed.rawValue:
            url = api.callEnded.url()
        default:
            break
        }

        print_debug("hitting \(url) with and headers :\(head) and params \(params)")
        Alamofire.request(url,method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("call \(status) users json is:\n\(json)")
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
  
    
    
    func getCallDetails(callID:String,completionBlock:@escaping (_ success:Bool,_ userCall: CallHistoryModel?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["callId":callID]

        print_debug("hitting \(api.callDetails.url()) with and headers :\(head) and params \(params)")
        Alamofire.request(api.callDetails.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("call detail json is:\n\(json)")
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
    
    
}
