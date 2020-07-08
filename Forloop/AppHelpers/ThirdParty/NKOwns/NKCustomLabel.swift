//
//  NKCustomLabel.swift
//  EatWeDo
//
//  Created by TecOrb on 30/03/17.
//  Copyright © 2017 Nakul Sharma. All rights reserved.
//

import Foundation
import UIKit

class NKCustomLabel : UILabel {
    // MARK: - Colors to create gradient from
    open var gradientColors:Array<UIColor> = [gradientTextColor.start,gradientTextColor.end]{
        didSet{
            setNeedsDisplay()
        }
    }

    @IBInspectable open var isGradientApplied : Bool = false{
        didSet{
            setNeedsDisplay()
        }
    }

    @IBInspectable open var gradientFrom: UIColor = gradientTextColor.start{
        didSet{
            setNeedsDisplay()
        }
    }

    @IBInspectable open var gradientTo: UIColor = gradientTextColor.end{
        didSet{
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        if !isGradientApplied{super.draw(rect); return}
        // begin new image context to let the superclass draw the text in (so we can use it as a mask)
        if self.gradientColors.count == 0{
            self.gradientColors.append(gradientFrom)
            self.gradientColors.append(gradientTo)
        }

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        do {
            // get your image context
            guard let ctx = UIGraphicsGetCurrentContext() else { super.draw(rect); return }
            // flip context
            ctx.scaleBy(x: 1, y: -1)
            ctx.translateBy(x: 0, y: -bounds.size.height)
            // get the superclass to draw text
            super.draw(rect)
        }
        // get image and end context
        guard let img = UIGraphicsGetImageFromCurrentImageContext(), img.cgImage != nil else { return }
        UIGraphicsEndImageContext()
        // get drawRect context
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        // clip context to image
        ctx.clip(to: bounds, mask: img.cgImage!)

        // define your colors and locations
        let colors: [CGColor] = [gradientTextColor.start.cgColor, gradientTextColor.end.cgColor]
        let locs: [CGFloat] = [0.3, 0.7]


        // create your gradient
        guard let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locs) else { return }
        // draw gradient
        ctx.drawLinearGradient(grad, start: CGPoint(x: 0, y: bounds.size.height*0.5), end: CGPoint(x:bounds.size.width, y: bounds.size.height*0.5), options: CGGradientDrawingOptions(rawValue: 0))
    }
    var textInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = textInsets.apply(rect: bounds)
        rect = super.textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        return textInsets.inverse.apply(rect: rect)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: textInsets.apply(rect: rect))
    }

}

@IBDesignable
extension NKCustomLabel {

    // currently UIEdgeInsets is no supported IBDesignable type,
    // so we have to fan it out here:
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }

    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right}
    }

    @IBInspectable
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }

    @IBInspectable
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
    // Same for the right, top and bottom edges.
}
extension NSMutableAttributedString {

    func setAttachmentsAlignment(_ alignment: NSTextAlignment) {
        self.enumerateAttribute(NSAttributedString.Key.attachment, in: NSRange(location: 0, length: self.length), options: .longestEffectiveRangeNotRequired) { (attribute, range, stop) -> Void in
            if attribute is NSTextAttachment {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = alignment
                self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
            }
        }
    }

}

extension UIEdgeInsets {
    var inverse: UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }

    func apply(rect: CGRect) -> CGRect {
        return rect.inset(by: self)
    }
}
