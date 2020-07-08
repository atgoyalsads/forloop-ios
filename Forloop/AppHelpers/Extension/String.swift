//
//  StringExtension.swift
//  RideApp
//
//  Created by Nakul Sharma on 31/05/19.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//



import Foundation

extension String {
    var last4:String{
        let last4 = String(self.suffix(4))
        return last4
    }

    func last(_ n: UInt) -> String{
        if self.count > n{return self}
        let lastn = String(self.suffix(Int(n)))
        return lastn
    }

    func removingWhitespaces() -> String {
        let customCharSet = CharacterSet(charactersIn: " +-()$")
        return components(separatedBy: customCharSet).joined()
    }
    
//    static func className(aClass: AnyClass) -> String {
//        return NSStringFromClass(aClass).componentsSeparated(by: ".").last!
//    }
//    
//    func substring(from: Int) -> String {
//        return self.substring(from: self.startIndex.advancedBy(from))
//    }
//    
//    var length: Int {
//        return self.characters.count
//    }
}
//
//extension String {
//    var localizedString:String{
//        let myLangBundle = AppSettings.shared.languageBundle
//        let tableName = "Localizable"
//        return NSLocalizedString(self, tableName: tableName, bundle: myLangBundle, value: "**\(self)**", comment: "")
//    }
//
//    subscript(value: NSRange) -> Substring {
//        return self[value.lowerBound..<value.upperBound]
//    }
//}

extension String {
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }

    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }

    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
}

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}
