//
//  HomeProModel.swift
//  Forloop
//
//  Created by Tecorb on 13/03/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import SwiftyJSON



struct HomeProModel{
    var availableOptions = [AvailableOptionsModel]()
    var resultModel = [ResultModel]()
    var calls = [CallHistoryModel]()
    init(_ json: JSON) {

    availableOptions = json["availableOptions"].arrayValue.map{AvailableOptionsModel($0)}
    resultModel = json["result"].arrayValue.map{ResultModel($0)}
    calls = json["calls"].arrayValue.map{CallHistoryModel($0)}
        
    }
    init() {}

}


struct AvailableOptionsModel {
    

    var label1: String = ""
    var label2: String = ""
    var value: String = ""

    init(_ json: JSON) {
        label1 = json["label1"].stringValue
        label2 = json["label2"].stringValue
        value = json["value"].stringValue
    }
    init() {}
    
}

struct ResultModel {
    

    var label: String = ""
    var value: String = ""
    var intValue:Int{
        get{
            let labelArr = self.label.split(separator: " ")
            guard let first = labelArr.first else{return 0}
            let finalValue = Int(String(first)) ?? 0
            return finalValue
        }
    }
    
    init(_ json: JSON) {
        label = json["label"].stringValue
        value = json["value"].stringValue


    }
    init() {}
    
}




struct HomeProModelParser {
    var message = ""
    var homePro = HomeProModel()

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
        
         if let _homePro =  json as JSON?{
             self.homePro = HomeProModel(_homePro)
         }
        

    }
    
    
}

extension HomeProModelParser{
    enum keys: String {
        case code = "code"
        case message = "message"

    }
    
}

