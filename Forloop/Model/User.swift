//
//  User.swift
//  FuelDelivery_Delivery
//
//  Created by Tecorb Techonologies on 16/09/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit
import SwiftyJSON

struct User {
    

    var ID: String = ""
    var fname: String = ""
    var lname: String = ""
    var email: String = ""
    var contact: String = ""
    var address: String = ""
    var countryCode: String = ""
    var image: String = ""
    var sessionToken: String = ""
    var certificate1:String = ""
    var certificate2:String = ""
    var userDescription:String = ""
    var displayName:String = ""
    var experience:String = ""
    var linkBlogger:String = ""
    var linkInstagram:String = ""
    var linkPinterest:String = ""
    var pricePerHours:Double = 0
    var linkLinkedin:String = ""
    var selectedRole:String = ""
    var zipcode:String = ""
    var dob:String = ""
    var gender:String = ""
    var proUserStatus:ProStatusModel = ProStatusModel()
    var certificates = [CertificateModel]()
    var skills = [SkillModel]()
    var receivedCallsCount = ""
    var avgCallAmount = ""
    var avgCallMinutes = ""
    var rating:Int = 0
    var ratings = [RatingsModel]()
    var isFavourite: Bool = false
    var callsDataHome = CallsDataHome()
    var callsDataDetails = CallsDataHome()
    var skillSets =  [CategoryModel]()
    var allProSkills = [SkillModel]()
    var question = [QuestionModel]()
    var callCategory:String = ""



    init(_ json: JSON) {
        ID = json["id"].stringValue
        fname = json["fname"].stringValue
        lname = json["lname"].stringValue
        email = json["email"].stringValue
        contact = json["contact"].stringValue
        address = json["address"].stringValue
        countryCode = json["countryCode"].stringValue
        image = json["image"].stringValue
        sessionToken = json["sessionToken"].stringValue
        certificate1 = json["certificate1"].stringValue
        certificate2 = json["certificate2"].stringValue
        userDescription = json["description"].stringValue
        displayName = json["displayName"].stringValue
        experience = json["experience"].stringValue
        linkBlogger = json["linkBlogger"].stringValue
        linkInstagram = json["linkInstagram"].stringValue
        linkLinkedin = json["linkLinkedin"].stringValue

        linkPinterest = json["linkPinterest"].stringValue
        pricePerHours = json["pricePerHour"].doubleValue
        selectedRole = json["selectedRole"].stringValue
        proUserStatus = ProStatusModel(json["proDataStatus"])
        zipcode = json["zipcode"].stringValue
        dob = json["dob"].stringValue
        gender = json["gender"].stringValue
        certificates = json["certificates"].arrayValue.map { CertificateModel($0) }
        skills = json["skills"].arrayValue.map{(SkillModel($0))}
        receivedCallsCount = json["receivedCallsCount"].stringValue
        avgCallAmount = json["avgCallAmount"].stringValue
        avgCallMinutes = json["avgCallMinutes"].stringValue
        rating = json["rating"].intValue
        ratings = json["ratings"].arrayValue.map { RatingsModel($0) }
        isFavourite = json["inFav"].boolValue
        callsDataHome = CallsDataHome(json["callsDataHome"])
        callsDataDetails = CallsDataHome(json["callsDataDetail"])
        skillSets = json["skillsJson"].arrayValue.map { CategoryModel($0) }
        allProSkills = json["allSkills"].arrayValue.map{(SkillModel($0))}
        question = json["questions"].arrayValue.map{QuestionModel($0)}
        callCategory = json["callCategory"].stringValue


    }



    init() {}
    /*
     *initializer for user using SwiftyJSON
     */


    /**
     save user json into UserDefaults
     */
    func saveUserJSON(_ json:JSON) {
        if let userInfo = json["user"].dictionaryObject as [String:AnyObject]?{
            let documentPath = NSHomeDirectory() + "/Documents/"
            do {
                let data = try JSON(userInfo).rawData(options: [.prettyPrinted])
                let path = documentPath + "user"
                try data.write(to: URL(fileURLWithPath: path), options: .atomic)
            }catch{
                print_debug("error in saving userinfo")
            }
            UserDefaults.standard.synchronize()
        }else if let userInfo = json["result"].dictionaryObject as [String:AnyObject]?{
            let documentPath = NSHomeDirectory() + "/Documents/"
            do {
                let data = try JSON(userInfo).rawData(options: [.prettyPrinted])
                let path = documentPath + "user"
                try data.write(to: URL(fileURLWithPath: path), options: .atomic)
            }catch{
                print_debug("error in saving userinfo")
            }
            UserDefaults.standard.synchronize()
        }
    }

    /**
     delete user json from UserDefaults. Basically it saves empty object in place of user josn dictionary
     */
    static func removeUserFromDeviceSession(){
        let documentPath = NSHomeDirectory() + "/Documents/"
        do {
            let emptyDict = Dictionary<String,AnyObject>()
            let data = try JSON(emptyDict).rawData(options: [.prettyPrinted])
            let path = documentPath + "user"
            try data.write(to: URL(fileURLWithPath: path), options: .atomic)
        }catch{
            print_debug("error in saving userinfo")
        }
    }

    /**
     To load the data saved in UserDefaults and return and instance of User
     */
    static func loadSavedUser() -> User {
        let documentPath = NSHomeDirectory() + "/Documents/"
        let path = documentPath + "user"
        var data = Data()
        var json : JSON
        do{
            data = try Data(contentsOf: URL(fileURLWithPath: path))
            json = try JSON(data: data)
        }catch{
            json = JSON.init(data)
            print_debug("error in getting userinfo")
        }
        let user = User(json)
        return user
    }
    
    static func updateAfterDlUpload(driveApproved:Bool=true){
        let documentPath = NSHomeDirectory() + "/Documents/"
        let path = documentPath + "user"
        var data = Data()
        var json : JSON
        do{
            data = try Data(contentsOf: URL(fileURLWithPath: path))
            json = try JSON(data: data)
        }catch{
            json = JSON.init(data)
            print_debug("error in getting userinfo")
            return
        }
        if var userDict = json.dictionaryObject as [String:AnyObject]?{
            userDict.updateValue(driveApproved as AnyObject, forKey: "driveApproved")
            let superDict = ["user":userDict]
            let json = JSON(superDict)
            User().saveUserJSON(json)
        }
    }

}


struct CertificateModel {
    var certificate:String = ""
    var link:String = ""

    init(_ json: JSON) {
        certificate = json["title"].stringValue
        link = json["link"].stringValue

    }

    init() {}

}


struct RatingsModel {
    var createdAt:String = ""
    var reviewedBy:String = ""
    var callReview:String = ""
    var rating:Double = 0
    
    init(_ json: JSON) {
        createdAt = json["created_at"].stringValue
        reviewedBy = json["reviewedBy"].stringValue
        callReview = json["callReview"].stringValue
        rating = json["rating"].doubleValue
    }

    init() {}

}


//struct SkillSet {
//    var subcategoryTitle:String = ""
//    var subcategory  = SubCategoryModel()
//
//
//    init(_ json: JSON) {
//        subcategoryTitle = json["subcategoryTitle"].stringValue
//        subcategory = SubCategoryModel(json["subcategoryId"])
//
//    }
//
//    init() {}
//
//}




struct CallsDataHome {
    var totalReviews: Int = 0
    var totalCalls:Int = 0
    var avgRating:Double = 0
    var avgAmount:Double = 0
    var avgMinutes:Double = 0.0
    
    init(_ json: JSON) {
        totalReviews = json["totalReviews"].intValue
        totalCalls = json["totalCalls"].intValue
        avgRating = json["avgRating"].doubleValue
        avgAmount = json["avgAmount"].doubleValue
        avgMinutes = json["avgMinutes"].doubleValue

    }
    init() {}
    
}



struct UserDocStatus {
    
    var message: String = ""
    var documentStatus: Bool?
    var errorCode: ErrorCode = .failure
    
    init(_ json: JSON) {
        errorCode = ErrorCode(rawValue: json["code"].intValue)
        message = json["message"].stringValue
        documentStatus = json["document_status"].bool
    }
    
}


struct UserParser {
    var message = ""
    var users = [User]()
    var user = User()
    var errorCode: ErrorCode = .failure
    var referalCode = ""
    var favouritesList = [User]()
    var ratings = [RatingsModel]()

    init(_ json: JSON){
        if let _rCode = json[keys.code.rawValue].int{
            self.errorCode = ErrorCode(rawValue: _rCode)
        }

        if let _message = json[keys.message.rawValue].string{
            self.message = _message
        }else if let _message = json["error"].string{
            self.message = _message
        }
        if let referalCode = json[keys.referalCode.rawValue].string{
            self.referalCode = referalCode
        }

        if let _user =  json[keys.user.rawValue] as JSON?{
            self.user = User(_user)
        }else if let _user =  json[keys.result.rawValue] as JSON?{
            self.user = User(_user)
        }else if let _user =  json[keys.users.rawValue] as JSON?{
            self.user = User(_user)
        }

        if let usrs  = json[keys.users.rawValue].array{
            users.removeAll()
            for u in usrs{
                let usr = User(u)
                users.append(usr)
            }
        }
        favouritesList =  json[keys.favouritesList.rawValue].arrayValue.map{User($0)}
        ratings =  json[keys.ratings.rawValue].arrayValue.map{RatingsModel($0)}

    }

}


extension UserParser{
    enum keys: String {
        case code = "code"
        case message = "message"
        case result = "result"
        case user = "user"
        case users = "users"
        case referalCode = "referalCode"
        case favouritesList = "profiles"
        case ratings = "ratings"

    }
}







//

struct NameImageParser {
    var message = ""
    var errorCode: ErrorCode = .failure
    
    init(_ json: JSON){
        if let _rCode = json[keys.code.rawValue].int{
            self.errorCode = ErrorCode(rawValue: _rCode)
        }

        if let _message = json[keys.message.rawValue].string{
            self.message = _message
        }else if let _message = json["error"].string{
            self.message = _message
        }
    }

}


extension NameImageParser{
    enum keys: String {
        case code = "code"
        case message = "message"
        case user = "user"
    }
}





struct ProStatusModel {
    
    var isLinks:Bool = false
    var isSubcategories:Bool = false
    var isDetails:Bool = false
    var isDisplayName:Bool = false
    var isPrice:Bool = false

    init(_ json: JSON) {
        isLinks = json["links"].boolValue
        isSubcategories = json["subcategories"].boolValue
        isDetails = json["details"].boolValue
        isDisplayName = json["displayName"].boolValue
        isPrice = json["price"].boolValue
    }
    init() {}
    
}

class ForgotPasswordParser: NSObject {
    let kResponseCode = "code"
    let kResponseMessage = "message"
    let kVerificationCode = "verificationCode"
    let kUser = "user"
    
    var responseMessage = ""
    var code: Int = 0
    var verificationCode = ""
    override init() {
        super.init()
    }

    init(json: JSON) {
        if let _rCode = json[kResponseCode].int as Int?{
            self.code = _rCode
        }

        if let _message = json[kResponseMessage].string{
            self.responseMessage = _message
        }

        if let _verificationCode = json[kVerificationCode].string{
            self.verificationCode = _verificationCode
        }else if let _verificationCode = json[kVerificationCode].int{
            self.verificationCode = "\(_verificationCode)"
        }

    }

}


