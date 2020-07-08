//
//  SubCategoryModel.swift
//  Forloop
//
//  Created by Tecorb on 10/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON



struct HomeModel {
    
    var categories = [CategoryModel]()
    var subcategories = [SubCategoryModel]()
    var topProModel = [User]()

    init(_ json: JSON) {
        categories = json["categories"].arrayValue.map{CategoryModel($0)}
        subcategories = json["subcategories"].arrayValue.map{SubCategoryModel($0)}
        topProModel = json["top"].arrayValue.map{User($0)}

    }
    init() {}
    
}


struct HomeParser {
    var message = ""
    var home = HomeModel()
    var errorCode: ErrorCode = .failure
    var categories = [CategoryModel]()
    var subCategories = [SubCategoryModel]()
    var topUsers = [User]()

    init(_ json: JSON){
        if let _rCode = json[keys.code.rawValue].int{
            self.errorCode = ErrorCode(rawValue: _rCode)
        }

        if let _message = json[keys.message.rawValue].string{
            self.message = _message
        }else if let _message = json["error"].string{
            self.message = _message
        }
       
        if let _home =  json[keys.result.rawValue] as JSON?{
            self.home = HomeModel(_home)
        }
        
        categories = json[keys.categories.rawValue].arrayValue.map{CategoryModel($0)}
        subCategories = json[keys.subCategories.rawValue].arrayValue.map{SubCategoryModel($0)}
        topUsers = json[keys.topUsers.rawValue].arrayValue.map{User($0)}

     }

    }

extension HomeParser{
    enum keys: String {
        case code = "code"
        case message = "message"
        case result = "result"
        case categories = "categories"
        case subCategories = "subcategories"
        case topUsers = "top"
    }
}







struct SubCategoryModel {
    
    var title: String = ""
    var id:String = ""
    var user = [User]()
    var oid:Int = 0
    
    init(_ json: JSON) {
        id = json["id"].stringValue
        title = json["title"].stringValue
        user = json["users"].arrayValue.map{User($0)}
        oid = json["$oid"].intValue
    }
    init() {}
    
}





struct TopProModel {
    
    var title: String = ""
    var user = [User]()
    
    init(_ json: JSON) {
        title = json["title"].stringValue
        user = json["users"].arrayValue.map{User($0)}
    }
    init() {}
    
}



struct SkillModel {
    var skill:String = ""
    init(_ json: JSON) {
        skill = json.stringValue
        
    }

    init() {}

}





