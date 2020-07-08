//
//  CategoryModel.swift
//  Forloop
//
//  Created by Tecorb on 17/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

struct CategoryModel {
    
    var id:String = ""
    var title: String = ""
    var isSelect: Bool = false
    
    init(_ json: JSON) {
        id = json["id"].stringValue
        title = json["title"].stringValue
    }
    init() {}
    
}





struct CategoryParser {
    var message = ""
    var categories = [CategoryModel]()
    var category = CategoryModel()
    var subCategories = [CategoryModel]()
    var subCategory = CategoryModel()
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
        
        
        if let _category =  json[keys.category.rawValue] as JSON?{
            self.category = CategoryModel(_category)
        }
        
        if let _subCategory =  json[keys.subCategory.rawValue] as JSON?{
            self.subCategory = CategoryModel(_subCategory)
        }
        
         categories = json[keys.categories.rawValue].arrayValue.map({ (orderjson) -> CategoryModel in
            return CategoryModel(orderjson)
        })
        
        
         subCategories = json[keys.subCategories.rawValue].arrayValue.map({ (orderjson) -> CategoryModel in
            return CategoryModel(orderjson)
        })
        
        //self.order = Order(json[keys.orders.rawValue])
    }
    
    
}

extension CategoryParser{
    enum keys: String {
        case code = "code"
        case message = "message"
        case category = "category"
        case categories = "categories"
        case subCategories = "subcategories"
        case subCategory = "subcategory"

    }
    
}




