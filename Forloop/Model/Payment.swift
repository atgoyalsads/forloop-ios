//
//  Payment.swift
//  Forloop
//
//  Created by Tecorb on 23/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Payment {
    
    var id: String = ""
    var brand: String = ""
    var expMonth: String = ""
    var expYear: String = ""
    var last4: String = ""
    var name: String = ""
    var funding: String = ""
    var isDefault:Bool = false
    
    init(_ json: JSON) {
        id = json["id"].stringValue
        brand = json["brand"].stringValue
        expMonth = json["exp_month"].stringValue
        expYear = json["exp_year"].stringValue
        last4 = json["last4"].stringValue
        name = json["name"].stringValue
        funding = json["funding"].stringValue
        isDefault = json["is_default"].boolValue
    }
    
    init(){}
    
}



struct PaymentParser {
    var responseMessage = ""
    var cards = Array<Payment>()
    var card = Payment()
    var errorCode: ErrorCode = .failure
    
    init(_ json: JSON){
        if let _rCode = json[keys.code.rawValue].int{
            self.errorCode = ErrorCode(rawValue: _rCode)
        }
        
        if let _message = json[keys.message.rawValue].string{
            self.responseMessage = _message
        }else if let _message = json["error"].string{
            self.responseMessage = _message
        }
        
        
        if let _order =  json[keys.card.rawValue] as JSON?{
            self.card = Payment(_order)
        }
        
        cards  = json[keys.cards.rawValue].arrayValue.map({ (orderjson) -> Payment in
            return Payment(orderjson)
        })
        
        //self.order = Order(json[keys.orders.rawValue])
    }
    
    
}

extension PaymentParser{
    enum keys: String {
        case code = "code"
        case message = "message"
        case card = "card"
        case cards = "cards"
    }
    
}
