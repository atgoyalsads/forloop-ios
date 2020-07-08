//
//  LogInService.swift
//  FuelDelivery_Delivery
//
//  Created by Tecorb Techonologies on 16/09/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let kUserJSON = "UserJSON"

class LogInService {
    static let sharedInstance = LogInService()
    fileprivate init() {}
    
    
    func updateDeviceTokeOnServer(){

        var params = Dictionary<String,String>()
        let user = User.loadSavedUser()
        
        params.updateValue(user.ID, forKey: "user_id")
        if user.ID.trimmingCharacters(in: .whitespaces).count == 0{return}
        params.updateValue("ios", forKey: "device_type")
        if let deviceID = kUserDefaults.value(forKey: kDeviceToken) as? String {
            params.updateValue(deviceID, forKey: "device_token")
        }else{
            params.updateValue("--", forKey: "device_token")
        }
        var shouldUpdate :Bool = true
        for (_, value) in params{
            if value == "" || value == "--"{
                shouldUpdate = false
                break
            }
        }
        
        if !shouldUpdate{
            return
        }
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        print_debug("hitting \(api.updateDeviceToken.url()) with param \(params) and headers :\(head)")
        Alamofire.request(api.updateDeviceToken.url(),method: .post ,parameters: params, headers:head).responseJSON { response in
            print_debug("SuccessFull update device token")
            AppSettings.shared.hideLoader()
        }
    }
    
    
    func registerWith(_ user:Dictionary<String,String>,completionBlock:@escaping (_ success:Bool, _ user: User?, _ message: String) -> Void){
        
        var params = Dictionary<String,Any>()
        params.updateValue(user, forKey: "user")
        
        let head =  AppSettings.shared.prepareHeader(withAuth: false)
        print_debug("hitting \(api.signUp.url()) with param \(params) and headers :\(head)")
        Alamofire.request(api.signUp.url(),method: .post ,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("sign in json is:\n\(json)")
                    let userParser = UserParser(json)
                    if userParser.errorCode == .forceUpdate{
                        AppSettings.shared.showForceUpdateAlert()
                    }else{
                        if userParser.errorCode == .success{
                            userParser.user.saveUserJSON(json)
                            LogInService.sharedInstance.updateDeviceTokeOnServer()

                        }
                        completionBlock((userParser.errorCode == .success), userParser.user, userParser.message)
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
    


    func loginWith(_ userName:String,password:String,completionBlock:@escaping (_ success:Bool, _ user: User?, _ message: String) -> Void){
        
        var params = Dictionary<String,String>()
        params.updateValue(userName, forKey: "email")
        params.updateValue(password, forKey: "password")
        
        let head =  AppSettings.shared.prepareHeader(withAuth: false)
        print_debug("hitting \(api.login.url()) with param \(params) and headers :\(head)")
        Alamofire.request(api.login.url(),method: .post ,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("sign in json is:\n\(json)")
                    let userParser = UserParser(json)
                    if userParser.errorCode == .forceUpdate{
                        AppSettings.shared.showForceUpdateAlert()
                    }else{
                        if userParser.errorCode == .success{
                            AppSettings.shared.isLoggedIn = true
//                            AppSettings.shared.isRegistered = true
                            userParser.user.saveUserJSON(json)
                            LogInService.sharedInstance.updateDeviceTokeOnServer()

                        }
                        completionBlock((userParser.errorCode == .success), userParser.user, userParser.message)
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
    
    
    func logout(completionBlock:@escaping (_ success:Bool, _ message: String) -> Void){
        
        let head =  AppSettings.shared.prepareHeaderAfterLogin(withAuth: true)
        print_debug("hitting \(api.logout.url()) with headers :\(head)")
        AppSettings.shared.showLoader(withStatus: "Log Out..")
        Alamofire.request(api.logout.url(),method: .get , headers:head).responseJSON { response in
            AppSettings.shared.hideLoader()
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("sign in json is:\n\(json)")
                    let userParser = UserParser(json)
                    if userParser.errorCode == .forceUpdate{
                        AppSettings.shared.showForceUpdateAlert()
                    }else if userParser.errorCode == .accountDeactivate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.accountDeactivateAndShowToLoginPage(message: userParser.message)
                    }else{
                        if userParser.errorCode == .success{
                            AppSettings.shared.isLoggedIn = false
                            AppSettings.shared.isRegistered = false
                        }
                        completionBlock((userParser.errorCode == .success), userParser.message)
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
    
    
    func getCategoriesFromServer(pageNumber:Int,perPage: Int,completionBlock:@escaping (_ success:Bool,_ cards: Array<CategoryModel>?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["page":"\(pageNumber)", "per_page":"\(perPage)"]
        
        print_debug("hitting \(api.getCategories.url()) with and headers :\(head) and params :\(params)")
        Alamofire.request(api.getCategories.url(),method: .post,parameters: params, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("Category json is:\n\(json)")
                    let categoryParser = CategoryParser(json)
                    if categoryParser.errorCode == .sessionExpire{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                    }else if categoryParser.errorCode == .forceUpdate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showForceUpdateAlert()
                    } else{
                        completionBlock((categoryParser.errorCode == .success),categoryParser.categories,categoryParser.message)
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
   
    
    func getSubCategoriesFromServer(keyword:String,pageNumber:Int,perPage: Int,completionBlock:@escaping (_ success:Bool,_ cards: Array<CategoryModel>?,_ message:String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        let params = ["page":"\(pageNumber)", "per_page":"\(perPage)","keyword":keyword]
        
        print_debug("hitting \(api.getSubCategories.url()) with and headers :\(head) and params :\(params)")
        Alamofire.request(api.getSubCategories.url(),method: .post,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("sub Category json is:\n\(json)")
                    let categoryParser = CategoryParser(json)
                    if categoryParser.errorCode == .sessionExpire{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                    }else if categoryParser.errorCode == .forceUpdate{
                        AppSettings.shared.hideLoader()
                        AppSettings.shared.showForceUpdateAlert()
                    } else{
                        completionBlock((categoryParser.errorCode == .success),categoryParser.subCategories,categoryParser.message)
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
    
    
    
    func updateUserImage(_ name: String, _ userImage: String,completionBlock:@escaping (_ success:Bool, _ user:User?, _ message: String) -> Void){
        
        var params = Dictionary<String,Any>()
        if !userImage.isEmpty{
            params.updateValue(userImage, forKey: "image")
        }
        params.updateValue(name, forKey: "displayName")

        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        print_debug("hitting \(api.updatePic.url()) with param \(params) and headers :\(head)")
        AppSettings.shared.showLoader(withStatus: "Loading..")
        Alamofire.request(api.updatePic.url(),method: .post ,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
            AppSettings.shared.hideLoader()
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("Image And Name in json is:\n\(json)")
                    let userParser = UserParser(json)
                    if userParser.errorCode == .forceUpdate{
                        AppSettings.shared.showForceUpdateAlert()
                    } else {
                        if userParser.errorCode == .success{
                                userParser.user.saveUserJSON(json)
                            completionBlock((userParser.errorCode == .success) ,userParser.user  , userParser.message)
                        } else {
                            completionBlock(false,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                        }
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
    
    func updateUserDetails(fName: String,lName: String,zipcode: String,phoneNumber:String,countryCode:String ,dob:String,gender:String,completionBlock:@escaping (_ success:Bool, _ user: User? , _ message: String) -> Void){

        var params = Dictionary<String,Any>()
        params.updateValue(fName, forKey: "fname")
        params.updateValue(lName, forKey: "lname")
        params.updateValue(zipcode, forKey: "zipcode")
//        params.updateValue(phoneNumber, forKey: "contact")
//        params.updateValue(countryCode, forKey: "countryCode")
        params.updateValue(dob, forKey: "dob")
        params.updateValue(gender, forKey: "gender")

        
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        print_debug("hitting \(api.updateDetail.url()) with param \(params) and headers :\(head)")
        Alamofire.request(api.updateDetail.url(),method: .post ,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("Update Details in json is:\n\(json)")
                    let userParser = UserParser(json)
                    if userParser.errorCode == .forceUpdate{
                        AppSettings.shared.showForceUpdateAlert()
                    } else {
                        if userParser.errorCode == .success{
                            userParser.user.saveUserJSON(json)
                            completionBlock((userParser.errorCode == .success) ,userParser.user ,  userParser.message)
                        } else {
                           completionBlock(false,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                        }
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
    
    func updateUserLinks(_ blogger: String, _ insta: String, _ linkedIn: String, _ pinterest:String,completionBlock:@escaping (_ success:Bool, _ user:User?, _ message: String) -> Void){
        
        var params = Dictionary<String,Any>()

        params.updateValue(blogger, forKey: "linkBlogger")
        params.updateValue(pinterest, forKey: "linkPinterest")
        params.updateValue(insta, forKey: "linkInstagram")
        params.updateValue(linkedIn, forKey: "linkLinkedin")
        
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        print_debug("hitting \(api.updatelinks.url()) with param \(params) and headers :\(head)")
        Alamofire.request(api.updatelinks.url(),method: .post ,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("Update Links in json is:\n\(json)")
                    let userParser = UserParser(json)
                    if userParser.errorCode == .forceUpdate{
                        AppSettings.shared.showForceUpdateAlert()
                    } else {
                        if userParser.errorCode == .success{
                                userParser.user.saveUserJSON(json)
                            completionBlock((userParser.errorCode == .success) ,userParser.user, userParser.message)
                        } else {
                           completionBlock(false,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                        }
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
    
    
    
    func updateUserCertificateImage(description: String, exprience:String,chargeAmount:String, certificateArray:[Dictionary<String,String>],completionBlock:@escaping (_ success:Bool, _ user:User?, _ message: String) -> Void){
        
        var params = Dictionary<String,Any>()

        params.updateValue(description, forKey: "description")
        params.updateValue(chargeAmount, forKey: "pricePerHour")
        
        if (certificateArray as AnyObject).count != 0{
            params.updateValue(certificateArray, forKey: "certificates")
        }else{
            params.updateValue([], forKey: "certificates")
        }

        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        print_debug("hitting \(api.updateCertificate.url()) with param \(params) and headers :\(head)")
        Alamofire.request(api.updateCertificate.url(),method: .post ,parameters: params, encoding: JSONEncoding.default, headers:head).responseJSON { response in
//             print(response)
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("Image And Name in json is:\n\(json)")
                    let userParser = UserParser(json)
                    if userParser.errorCode == .forceUpdate{
                        AppSettings.shared.showForceUpdateAlert()
                    } else {
                        if userParser.errorCode == .success{
                            userParser.user.saveUserJSON(json)

                            completionBlock((userParser.errorCode == .success),userParser.user , userParser.message)
                        } else {
                           completionBlock(false,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                        }
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
    
    
    
    func getUserCompleteSessionData(completionBlock:@escaping (_ success:Bool, _ user: User?, _ message: String) -> Void){
        
        
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        print_debug("hitting \(api.userSesssionData.url()) with headers :\(head)")
        AppSettings.shared.showLoader(withStatus: "Loading..")
        Alamofire.request(api.userSesssionData.url(),method: .get ,encoding: JSONEncoding.default, headers:head).responseJSON { response in
            AppSettings.shared.hideLoader()
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("user session data in json is:\n\(json)")
                    let userParser = UserParser(json)
                    if userParser.errorCode == .forceUpdate{
                        AppSettings.shared.showForceUpdateAlert()
                    }else{
                        if userParser.errorCode == .success{
                            AppSettings.shared.isLoggedIn = true
                            AppSettings.shared.isRegistered = true
                            userParser.user.saveUserJSON(json)
                            LogInService.sharedInstance.updateDeviceTokeOnServer()

                        }
                        completionBlock((userParser.errorCode == .success), userParser.user, userParser.message)
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
    

    
    
    
    func selectUserRole(_ selectedRole: String,completionBlock:@escaping (_ success:Bool, _ user: User?, _ message: String) -> Void){
        
        
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        var params = Dictionary<String,Any>()
        params.updateValue(selectedRole, forKey: "selectedRole")
        print_debug("hitting \(api.selectUserRole.url()) with param \(params) and headers :\(head)")

        Alamofire.request(api.selectUserRole.url(),method: .post ,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
            AppSettings.shared.hideLoader()
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug("Select User in json is:\n\(json)")
                    let userParser = UserParser(json)
                    if userParser.errorCode == .forceUpdate{
                        AppSettings.shared.showForceUpdateAlert()
                    }else{
                        if userParser.errorCode == .success{
                            AppSettings.shared.isLoggedIn = true
                            AppSettings.shared.isRegistered = true
                            userParser.user.saveUserJSON(json)
                            LogInService.sharedInstance.updateDeviceTokeOnServer()

                        }
                        completionBlock((userParser.errorCode == .success), userParser.user, userParser.message)
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
    
    
    func UpdateSubCategoriesToServer(subcategoriesArray:[String],completionBlock:@escaping (_ success:Bool,_ cards: User?,_ message:String) -> Void){
         let head =  AppSettings.shared.prepareHeader(withAuth: true)
        var params = Dictionary<String,Any>()
         params.updateValue(subcategoriesArray, forKey: "subcategories")
         
         print_debug("hitting \(api.updateSubCategories.url()) with and headers :\(head) and params :\(params)")
         Alamofire.request(api.updateSubCategories.url(),method: .post,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
             switch response.result {
             case .success:
                 if let value = response.result.value {
                     let json = JSON(value)
                     print_debug("sub Category json is:\n\(json)")
                     let userParser = UserParser(json)
                     if userParser.errorCode == .sessionExpire{
                         AppSettings.shared.hideLoader()
                         AppSettings.shared.showSessionExpireAndProceedToLandingPage()
                     }else if userParser.errorCode == .forceUpdate{
                         AppSettings.shared.hideLoader()
                         AppSettings.shared.showForceUpdateAlert()
                     } else{
                        AppSettings.shared.isLoggedIn = true
                        userParser.user.saveUserJSON(json)

                         completionBlock((userParser.errorCode == .success),userParser.user,userParser.message)
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
    
    
        func registerTokenAfterLogin(_ email:String,sessionToken:String,completionBlock:@escaping (_ success:Bool, _ user: User?, _ message: String) -> Void){
            
            var params = Dictionary<String,String>()
            params.updateValue(email, forKey: "email")
            params.updateValue(sessionToken, forKey: "sessionToken")
            
            let head =  AppSettings.shared.prepareHeader(withAuth: false)
            print_debug("hitting \(api.registerToken.url()) with param \(params) and headers :\(head)")
            Alamofire.request(api.registerToken.url(),method: .post ,parameters: params,encoding: JSONEncoding.default, headers:head).responseJSON { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print_debug("sign in json is:\n\(json)")
                        let userParser = UserParser(json)
                        if userParser.errorCode == .forceUpdate{
                            AppSettings.shared.showForceUpdateAlert()
                        }else{
                            if userParser.errorCode == .success{
                                AppSettings.shared.isLoggedIn = true
    //                            AppSettings.shared.isRegistered = true
                                userParser.user.saveUserJSON(json)
                                LogInService.sharedInstance.updateDeviceTokeOnServer()

                            }
                            completionBlock((userParser.errorCode == .success), userParser.user, userParser.message)
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
    
    
    func logOut(completionBlock:@escaping ( _ success:Bool, _ user: User?, _ message: String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        print_debug("hitting \(api.logout.url()) headers :\(head)")
        Alamofire.request(api.logout.url(),method: .get, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug(json)
                    let userParser = UserParser(json)
                    completionBlock((userParser.errorCode == .success), userParser.user, userParser.message)
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
    
    func deactivatedAccount(completionBlock:@escaping ( _ success:Bool, _ user: User?, _ message: String) -> Void){
        let head =  AppSettings.shared.prepareHeader(withAuth: true)
        print_debug("hitting \(api.deactivateAccount.url()) headers :\(head)")
        Alamofire.request(api.deactivateAccount.url(),method: .get, encoding: JSONEncoding.default, headers:head).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print_debug(json)
                    let userParser = UserParser(json)
                    completionBlock((userParser.errorCode == .success), userParser.user, userParser.message)
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
