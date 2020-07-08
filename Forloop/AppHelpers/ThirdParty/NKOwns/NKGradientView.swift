//
//  NKGradientView.swift
//  GPDock
//
//  Created by TecOrb on 08/06/17.
//  Copyright © 2017 Nakul Sharma. All rights reserved.
//


import UIKit
@IBDesignable
class NKGradientView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        var i = 40
        var colors = [AnyObject]()
        while i >= 0 {
            colors.append(UIColor(red: CGFloat(i)/255.0, green: CGFloat(i)/255.0, blue: CGFloat(i)/255.0, alpha: 1.0).cgColor as AnyObject)
            i-=1
        }
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.layer.addSublayer(gradientLayer)
    }
}


@IBDesignable class GraphView: UIView {

    //1 - the properties for the gradient
    @IBInspectable var startColor: UIColor = UIColor.red
    @IBInspectable var endColor: UIColor = UIColor.green


    override func draw(_ rect: CGRect) {

        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]

        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]

        //5 - create the gradient
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)

        //6 - draw the gradient
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y:self.bounds.height)
        context!.drawLinearGradient(gradient!,start: startPoint,end: endPoint,options: .drawsAfterEndLocation)
    }
}
