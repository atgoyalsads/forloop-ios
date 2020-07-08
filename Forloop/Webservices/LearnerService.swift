//
//  LearnerService.swift
//  Forloop
//
//  Created by Tecorb on 10/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class LearnerService{
    static let sharedInstance = LearnerService()
    fileprivate init() {}
    
       func addProFavourites(proUserId:String,completionBlock:@escaping (_ success:Bool,_ message:String) -> Void){
                let head =  AppSettings.shared.prepareHeader(withAuth: true)
                let params = ["favouriteUserId":proUserId]
                
                print_debug("hitting \(api.addFavourite.url()) with and headers :\(head) and params :\(params)")
                Alamofire.request(api.addFavourite.url(),method: .post,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
               
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
                                completionBlock((parser.errorCode == .success),parser.message)
                            }
                        }else{
                            completionBlock(false,response.result.error?.localizedDescription ?? "Some thing went wrong")
                        }
                    case .failure(let error):
                        let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
                        print_debug(message)
                        completionBlock(false,error.localizedDescription)
                    }
                }
            }
    
    
    
    func getAllFavouritesList(page:Int,perPage:Int,completionBlock:@escaping (_ success:Bool,_ users: [User]?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["page":"\(page)", "per_page":"\(perPage)"]

        print_debug("hitting \(api.favouritesList.url()) with and headers :\(head) and params \(params)")
        Alamofire.request(api.favouritesList.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("favourite list users json is:\n\(json)")
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
                        completionBlock((parser.errorCode == .success),parser.favouritesList,parser.message)
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

    
    func setCallingRating(callId:String,rating:String,review:String,questions:[Dictionary<String,Any>],tip:String,questionAnswer:Bool,notLinked:String,newFeatures:String,completionBlock:@escaping (_ success:Bool,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        var params = Dictionary<String,Any>()
        params.updateValue(callId, forKey: "callId")
        params.updateValue(rating, forKey: "rating")
        params.updateValue(review, forKey: "review")
        if !questions.isEmpty{
            params.updateValue(questions, forKey: "questions")
        }
        params.updateValue(questionAnswer, forKey: "questionAddressed")
        params.updateValue(notLinked, forKey: "notLiked")
        params.updateValue(newFeatures, forKey: "newFeatures")
        params.updateValue(tip.removingWhitespaces(), forKey: "tip")

        

        print_debug("hitting \(api.callRating.url()) with and headers :\(head) and params \(params)")
        Alamofire.request(api.callRating.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("favourite list users json is:\n\(json)")
                    let parser = UserParser(json)
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
                        completionBlock((parser.errorCode == .success),parser.message)
                    }
                }else{
                    completionBlock(false,response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
            case .failure(let error):
                let message:String = AppSettings.shared.getFullError(errorString: error.localizedDescription, andresponse: response.data)
                print_debug(message)
                completionBlock(false,error.localizedDescription)
            }
        }
    }
    
    
       
    func loadSeekerCategoList(page:Int,perPage:Int,completionBlock:@escaping (_ success:Bool,_ users: [CategoryModel]?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["page":"\(page)", "per_page":"\(perPage)"]

        print_debug("hitting \(api.dashboardSeekerCatagory.url()) with and headers :\(head) and params \(params)")
        Alamofire.request(api.dashboardSeekerCatagory.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("category list users json is:\n\(json)")
                    let parser = HomeParser(json)
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
                        completionBlock((parser.errorCode == .success),parser.categories,parser.message)
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
    
    
    func loadSeekerSubCategoList(categoryID:String,page:Int,perPage:Int,completionBlock:@escaping (_ success:Bool,_ users: [SubCategoryModel]?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["category_id":categoryID,"page":"\(page)", "per_page":"\(perPage)"]

        print_debug("hitting \(api.dashboardSeekerSubCatagory.url()) with and headers :\(head) and params \(params)")
        Alamofire.request(api.dashboardSeekerSubCatagory.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("sub ca list users json is:\n\(json)")
                    let parser = HomeParser(json)
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
                        completionBlock((parser.errorCode == .success),parser.subCategories,parser.message)
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
    
    func loadTopUSerList(page:Int,perPage:Int,completionBlock:@escaping (_ success:Bool,_ users: [User]?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["page":"\(page)", "per_page":"\(perPage)"]

        print_debug("hitting \(api.dashboardSeekerTop.url()) with and headers :\(head) and params \(params)")
        Alamofire.request(api.dashboardSeekerTop.url(),method: .post,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("category list users json is:\n\(json)")
                    let parser = HomeParser(json)
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
                        completionBlock((parser.errorCode == .success),parser.topUsers,parser.message)
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
