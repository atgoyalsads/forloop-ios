//
//  WOWTooltipView.swift
//  Pods
//
//  Created by Zhou Hao on 11/4/17.
//
//
//  NSSlider
//
//  Created by Nakul Sharma on 10/06/19.
//  Copyright © 2019 TecOrb Technologies Pvt. Ltd. All rights reserved.

import UIKit

open class NKTooltipView: UIView {

    // MARK: properties
    var font: UIFont = fonts.Roboto.bold.font(.small) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var value: Float {
        get {
            if let text = text {
                return Float(text) ?? 0
            }
            return 0.0
        }
        set {
            text = String(format: "%.2f",newValue)
        }
    }
    
    var fillColor = UIColor.red{
        didSet {
            setNeedsDisplay()
        }
    }
    
    var textColor = UIColor(white: 1.0, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
        
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        fillColor.setFill()
        
        let roundedRect = CGRect(x:bounds.origin.x, y:bounds.origin.y, width:bounds.size.width, height:bounds.size.height * 0.8)
        let roundedRectPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: bounds.size.height * 0.4)//6.0)
        
        // create arrow
        let arrowPath = UIBezierPath()
        
        let p0 = CGPoint(x: bounds.midX, y: bounds.maxY - 2.0 )
        arrowPath.move(to: p0)
        arrowPath.addLine(to: CGPoint(x:bounds.midX - 6.0, y: roundedRect.maxY))
        arrowPath.addLine(to: CGPoint(x:bounds.midX + 6.0, y: roundedRect.maxY))
        
        roundedRectPath.append(arrowPath)
        roundedRectPath.fill()
        
        // draw text 
        if let text = self.text {
            
            let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
            let yOffset = (roundedRect.size.height - size.height) / 2.0
            let textRect = CGRect(x:roundedRect.origin.x, y: yOffset, width: roundedRect.size.width, height: size.height)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs = [NSAttributedString.Key.font.rawValue: font,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle,
                         NSAttributedString.Key.foregroundColor: textColor] as! [NSAttributedString.Key : Any]
            text.draw(in:textRect, withAttributes: attrs)
        }
    }

}
