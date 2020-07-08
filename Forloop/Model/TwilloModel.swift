//
//  TwilloModel.swift
//  Forloop
//
//  Created by Tecorb on 12/02/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//
import UIKit
import Foundation
import SwiftyJSON

struct TwilloModel {

    
    var fromNumber: String = ""
    var toNumber: String = ""
    var sid: String = ""
    var accountSid: String = ""

    init(_ json: JSON) {
        sid = json["sid"].stringValue
        accountSid = json["account_sid"].stringValue
        fromNumber = json["from"].stringValue
        toNumber = json["to"].stringValue
    }
    init() {}
    
}





struct TwilloModelParser {
    var message = ""
    var category = TwilloModel()
//    var subCategories = [CategoryModel]()
//    var subCategory = CategoryModel()
    var errorCode: ErrorCode = .failure
    var token = ""
    var callObjectID = ""
    
    init(_ json: JSON){
        if let _rCode = json[keys.code.rawValue].int{
            self.errorCode = ErrorCode(rawValue: _rCode)
        }
        
        if let _message = json[keys.message.rawValue].string{
            self.message = _message
        }else if let _message = json["error"].string{
            self.message = _message
        }
        
        if let _token = json[keys.token.rawValue].string{
            self.token = _token
        }
        if let _callObjectID = json[keys.callObjectID.rawValue].string{
            self.callObjectID = _callObjectID
        }
        
        
        if let _category =  json[keys.category.rawValue] as JSON?{
            self.category = TwilloModel(_category)
        }
//
//        if let _subCategory =  json[keys.subCategory.rawValue] as JSON?{
//            self.subCategory = CategoryModel(_subCategory)
//        }
//
//         categories = json[keys.categories.rawValue].arrayValue.map({ (orderjson) -> CategoryModel in
//            return CategoryModel(orderjson)
//        })
//
//
//         subCategories = json[keys.subCategories.rawValue].arrayValue.map({ (orderjson) -> CategoryModel in
//            return CategoryModel(orderjson)
//        })
        
        //self.order = Order(json[keys.orders.rawValue])
    }
    
    
}

extension TwilloModelParser{
    enum keys: String {
        case code = "code"
        case message = "message"
        case category = "category"
        case categories = "categories"
        case subCategories = "subcategories"
        case subCategory = "subcategory"
        case token = "token"
        case callObjectID = "callObjId"

    }
    
}




