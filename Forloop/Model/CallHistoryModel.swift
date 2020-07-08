//
//  CallHistoryModel.swift
//  Forloop
//
//  Created by Tecorb on 07/03/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit
import SwiftyJSON

struct CallHistoryModel {
    
    
    

    var id: String = ""
    var callStatus: String = ""
    var connectedAt: String = ""
    var createdAt: String = ""
    var durationMinutes: String = ""
    var endedAt: String = ""
    var paidStatus: Bool = false
    var pricePerHour: String = ""
    var updated_at: String = ""
    var totalPrice: Double = 0.0
    var pickedAt: String = ""
    var receiverUser = ReceiverModel()
    var dialerUser = DialerModel()
    var user = ReceiverModel()

    var tip:Double = 0
    var callReview:String = ""
    var completedAt:String = ""
    var callCategory:String = ""
    var feedbackNewFeatures:String = ""
    var feedbackQuestionAddressed:Bool = false
    var feedbackNotLiked:String = ""
    var rating:Double = 0
    var question = [QuestionModel]()
    var receiverId:String = ""


    init(_ json: JSON) {
        id = json["id"].stringValue
        callStatus = json["callStatus"].stringValue
        connectedAt = json["connectedAt"].stringValue
        createdAt = json["created_at"].stringValue
        durationMinutes = json["durationMinutes"].stringValue
        endedAt = json["endedAt"].stringValue
        paidStatus = json["paidStatus"].boolValue
        pickedAt = json["pickedAt"].stringValue
        pricePerHour = json["pricePerHour"].stringValue
        totalPrice = json["totalPrice"].doubleValue
        updated_at = json["updated_at"].stringValue
        tip = json["tip"].doubleValue
        callReview = json["callReview"].stringValue
        completedAt = json["completedAt"].stringValue
        callCategory = json["callCategory"].stringValue
        feedbackNewFeatures = json["feedbackNewFeatures"].stringValue
        feedbackQuestionAddressed = json["feedbackQuestionAddressed"].boolValue
        feedbackNotLiked = json["feedbackNotLiked"].stringValue
        rating = json["rating"].doubleValue
        question = json["questions"].arrayValue.map{QuestionModel($0)}
        
        //
        if let _receiver =  json["user"] as JSON?{
            self.user = ReceiverModel(_receiver)
        }
        if let _receiver =  json["receiver"] as JSON?{
            self.receiverUser = ReceiverModel(_receiver)
        }
        if let _dialerUser =  json["dialer"] as JSON?{
            self.dialerUser = DialerModel(_dialerUser)
        }
        receiverId = json["receiverId"].stringValue

        
    }
    init() {}
    
}


struct ReceiverModel {
    var image: String = ""
    var pricePerHour: String = ""
    var displayName:String = ""

    init(_ json: JSON) {
        image = json["image"].stringValue
        pricePerHour = json["pricePerHour"].stringValue
        displayName = json["displayName"].stringValue
    }
    init() {}
    
}


struct DialerModel {

    var image: String = ""
    var pricePerHour: String = ""
    var displayName:String = ""

    init(_ json: JSON) {
        image = json["image"].stringValue
        pricePerHour = json["pricePerHour"].stringValue
        displayName = json["displayName"].stringValue


    }
    init() {}
    
}


struct QuestionModel {

    var label: String = ""
    var rating :Double = 0.0
    var isAnswer:Bool = false
    var question:String = ""
    

    init(_ json: JSON) {
        label = json["label"].stringValue
        rating = json["rating"].doubleValue
        isAnswer = json["isAnswered"].boolValue
        question = json["question"].stringValue
    }
    init() {}
    
}



struct CallHistoryParser {
    var message = ""
    var histories = [CallHistoryModel]()
    var history = CallHistoryModel()
    var call = CallHistoryModel()

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
        
        
        if let _history =  json[keys.history.rawValue] as JSON?{
            self.history = CallHistoryModel(_history)
        }
        
        if let _call =  json[keys.call.rawValue] as JSON?{
            self.call = CallHistoryModel(_call)
        }

         histories = json[keys.histories.rawValue].arrayValue.map({ (orderjson) -> CallHistoryModel in
            return CallHistoryModel(orderjson)
         })
        

    }
    
    
}

extension CallHistoryParser{
    enum keys: String {
        case code = "code"
        case message = "message"
        case history = "histor"
        case histories = "history"
        case call = "call"

    }
    
}

