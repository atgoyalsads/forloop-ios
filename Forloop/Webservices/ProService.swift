//
//  ProService.swift
//  Forloop
//
//  Created by Tecorb on 12/03/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ProService{
    static let sharedInstance = ProService()
    fileprivate init() {}
    
    
    
    func getProUserListBySubCategory(subCategoryId:String,pageNumber:Int,perPage: Int,completionBlock:@escaping (_ success:Bool,_ users: [User]?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["subcategory_id":subCategoryId,"page":"\(pageNumber)", "per_page":"\(perPage)"]

        print_debug("hitting \(api.proUserListBySubCategory.url()) with and headers :\(head) and params \(params)")
        Alamofire.request(api.proUserListBySubCategory.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("subcategory users json is:\n\(json)")
                    let userParser = UserParser(json)
                    if userParser.errorCode == .sessionExpire{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                    }else if userParser.errorCode == .forceUpdate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showForceUpdateAlert()
                    }else if userParser.errorCode == .accountDeactivate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.accountDeactivateAndShowToLoginPage(message: userParser.message)
                    } else{
                        completionBlock((userParser.errorCode == .success),userParser.users,userParser.message)
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
  
    
    func searchFroUsers(keyword:String,pageNumber:Int,perPage: Int,completionBlock:@escaping (_ success:Bool,_ cards: Array<User>?,_ message:String) -> Void){
         let head =  AppSettings.shared.prepareHeader(withAuth: true)
         let params = ["page":"\(pageNumber)", "per_page":"\(perPage)","keyword":keyword]
         
         print_debug("hitting \(api.searchProUsers.url()) with and headers :\(head) and params :\(params)")
         Alamofire.request(api.searchProUsers.url(),method: .post,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
        
             switch response.result {
             case .success:
                 if let value = response.result.value {
                     let json = JSON(value)
                     print_debug("sub Category json is:\n\(json)")
                     let parser = UserParser(json)
                     if parser.errorCode == .sessionExpire{
                         AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                     }else if parser.errorCode == .forceUpdate{
                         AppSettings.shared.showForceUpdateAlert()
                     }else if parser.errorCode == .accountDeactivate{
                         AppSettings.shared.hideLoader()
                         AppSettings.shared.accountDeactivateAndShowToLoginPage(message: parser.message)
                     } else{
                         completionBlock((parser.errorCode == .success),parser.users,parser.message)
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
    
    
    
    func getProDetails(proUserId:String,completionBlock:@escaping (_ success:Bool,_ cards: User?,_ message:String) -> Void){
            let head =  AppSettings.shared.prepareHeader(withAuth: true)
            let params = ["proUserId":proUserId]
            
            print_debug("hitting \(api.proDetail.url()) with and headers :\(head) and params :\(params)")
            Alamofire.request(api.proDetail.url(),method: .post,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
           
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print_debug("sub Category json is:\n\(json)")
                        let parser = UserParser(json)
                        if parser.errorCode == .sessionExpire{
                            AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                        }else if parser.errorCode == .forceUpdate{
                            AppSettings.shared.showForceUpdateAlert()
                        }else if parser.errorCode == .accountDeactivate{
                            AppSettings.shared.hideLoader()
                            AppSettings.shared.accountDeactivateAndShowToLoginPage(message: parser.message)
                        } else{
                            completionBlock((parser.errorCode == .success),parser.user,parser.message)
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
    
    
    
    func proDashboard(keyword:String,requestOption:String,completionBlock:@escaping (_ success:Bool,_ home:HomeProModel? ,_ message:String) -> Void){
           let head =  AppSettings.shared.prepareHeader(withAuth: true)
           let params = ["keyword":keyword,"requestOption":requestOption]

           print_debug("hitting \(api.proDashboard.url()) with and headers :\(head) and params \(params)")
           Alamofire.request(api.proDashboard.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
               switch response.result {
               case .success:
                   if let value = response.result.value {
                       let json = JSON(value)
                       print_debug("subcategory users json is:\n\(json)")
                       let userParser = HomeProModelParser(json)
                       if userParser.errorCode == .sessionExpire{
                           AppSettings.shared.hideLoader()
                           AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                       }else if userParser.errorCode == .forceUpdate{
                           AppSettings.shared.hideLoader()
                           AppSettings.shared.showForceUpdateAlert()
                       }else if userParser.errorCode == .accountDeactivate{
                           AppSettings.shared.hideLoader()
                           AppSettings.shared.accountDeactivateAndShowToLoginPage(message: userParser.message)
                       } else{
                           completionBlock((userParser.errorCode == .success),userParser.homePro,userParser.message)
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
    
    
    func getProRatingPagination(ProID:String,page:Int,perPage:Int,completionBlock:@escaping (_ success:Bool,_ users: [RatingsModel]?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["proUserId":"\(ProID)","page":"\(page)", "per_page":"\(perPage)"]

        print_debug("hitting \(api.proRatingPagination.url()) with and headers :\(head) and params \(params)")
        Alamofire.request(api.proRatingPagination.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("pro ratingPagination users json is:\n\(json)")
                    let parser = UserParser(json)
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
                        completionBlock((parser.errorCode == .success),parser.ratings,parser.message)
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
