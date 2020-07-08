//
//  UIColor.swift
//  RideApp
//
//  Created by Nakul Sharma on 31/05/19.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}



extension UIColor {

//    convenience init(hex: String) {
//        self.init(hex: hex, alpha:1)
//    }
//
//    convenience init(hex: String, alpha: CGFloat) {
//        var hexWithoutSymbol = hex
//        if hexWithoutSymbol.hasPrefix("#") {
//            hexWithoutSymbol = hex.substring(1)
//        }
//        
//        let scanner = Scanner(string: hexWithoutSymbol)
//        var hexInt:UInt32 = 0x0
//        scanner.scanHexInt(&hexInt)
//        
//        var r:UInt32!, g:UInt32!, b:UInt32!
//        switch (hexWithoutSymbol.length) {
//        case 3: // #RGB
//            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
//            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
//            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
//            break;
//        case 6: // #RRGGBB
//            r = (hexInt >> 16) & 0xff
//            g = (hexInt >> 8) & 0xff
//            b = hexInt & 0xff
//            break;
//        default:
//            // TODO:ERROR
//            break;
//        }
//        
//        self.init(
//            red: ((CGFloat(r) ?? 0)/255),
//            green: ((CGFloat(g) ?? 0)/255),
//            blue: ((CGFloat(b) ?? 0)/255),
//            alpha:alpha)
//    }
}

//extension UIColor {
//    convenience init(hexString: String) {
//        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
//        var int = UInt32()
//        NSScanner(string: hex).scanHexInt(&int)
//        let a, r, g, b: UInt32
//        switch hex.characters.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 0)
//        }
//        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
//    }
//}
