//
//  UIView.swift
//  RideApp
//
//  Created by Nakul Sharma on 31/05/19.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreFoundation
import AVFoundation
import SystemConfiguration
//import Toast_Swift
extension UINavigationBar {
    var castShadow : String {
        get { return "anything fake" }
        set {
            self.layer.shadowOffset = CGSize(width:0,height: 3)
            self.layer.shadowRadius = 3.0
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.4
        }
    }

    func applyShadowOnNavigationBar(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 2.0,shadowOpacity:Float = 0.4) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity

        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height

        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}


//extension GMSMapView {
//    func getCenterCoordinate() -> CLLocationCoordinate2D {
//        let centerPoint = self.center
//        let centerCoordinate = self.projection.coordinate(for: centerPoint)
//        return centerCoordinate
//    }
//
//    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
//        // to get coordinate from CGPoint of your map
//        let topCenterCoor = self.convert(CGPoint(x: self.frame.size.width, y: 0), from: self)
//        let point = self.projection.coordinate(for: topCenterCoor)
//        return point
//    }
//
//    func getRadius() -> CLLocationDistance {
//        let centerCoordinate = getCenterCoordinate()
//        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
//        let topCenterCoordinate = self.getTopCenterCoordinate()
//        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
//        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
//        return round(radius)
//    }
//}

@IBDesignable
extension UITextField {

    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }

    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }

}

@IBDesignable class DottedVertical: UIView {
    @IBInspectable var dotColor: UIColor = UIColor.darkGray
    override func draw(_ rect: CGRect) {
        self.addDashedLine(fromPoint: self.frame.origin, toPoint: CGPoint(x:self.frame.size.width,y:self.frame.origin.y))
    }
    fileprivate func addDashedLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = dotColor.cgColor
        line.lineWidth = 1
        line.lineJoin = CAShapeLayerLineJoin.round
        line.lineDashPattern = [2, 2]
        self.layer.addSublayer(line)
    }
}


extension UIView:CAAnimationDelegate{
    func addRippleEffect(){
        let animation = CATransition()
        animation.delegate = self
        animation.duration = 25.0
        animation.timingFunction = CAMediaTimingFunction(name : CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType(rawValue: "rippleEffect")
        self.layer.add(animation, forKey: nil)
    }
    public func animationDidStart(_ anim: CAAnimation) {

    }
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

    }
}

extension UIView {

    func dropShadow(shadowColor: UIColor = .gray, shadowRadius: CGFloat = 2.0, shadowOpacity:Float = 0.4, shadowOffset:CGSize = CGSize(width: 2, height: 2)){
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }



    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 2.0,shadowOpacity:Float = 0.4,shadowColor: UIColor = .gray) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor.cgColor
        let path = UIBezierPath()

        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height

        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }

}


class BorderLayer: CALayer {
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class DashedBorderLayer: CAShapeLayer {
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {

//    class func loadNib<T: UIView>(viewType: T.Type) -> T {
//        let className = String.className(aClass: viewType)
//        return NSBundle(forClass: viewType).loadNibNamed(className, owner: nil, options: nil).first as! T
//    }
//    
//    class func loadNib() -> Self {
//        return loadNib(self)
//    }
//
//    func addGradientBackGround(){
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect(x:0, y:0, width:self.frame.size.width, height: self.frame.size.height)
//        var i = 36
//        var colors = [AnyObject]()
//        while i >= 0 {
//            colors.append(UIColor(red: CGFloat(i)/255.0, green: CGFloat(i)/255.0, blue: CGFloat(i)/255.0, alpha: 1.0).cgColor as AnyObject)
//            i-=1
//        }
//        gradientLayer.colors = colors
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
//        self.layer.addSublayer(gradientLayer)
//    }


//    func addShadow(topShadowWidth:CGFloat,leftShadowWidth:CGFloat,bottomShadowWidth:CGFloat,rightShadowWidth:CGFloat,shadowColor:UIColor,opicity:Float){
//        let shadowPath = UIBezierPath(rect: CGRectMake(self.frame.origin.x - leftShadowWidth,
//            self.frame.origin.y - topShadowWidth,
//            self.frame.size.width + rightShadowWidth,
//            self.frame.size.height + bottomShadowWidth))
//
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = shadowColor.CGColor;
//        self.layer.shadowOffset = CGSizeMake(10, 10);
//        self.layer.shadowOpacity = opicity
//        self.layer.shadowPath = shadowPath.CGPath;
//
//    }




    func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = BorderLayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:self.frame.size.width, height:width)
        if let subLayers = self.layer.sublayers {
            for subLayer in subLayers{
                if subLayer is BorderLayer{
                    subLayer.removeFromSuperlayer()
                    break
                }
            }
        }
        self.layer.addSublayer(border)
    }

    func addTopThinBorderWithColor(_ color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        let width = 1.0/(UIScreen.main.scale/4)
        border.frame = CGRect(x:0, y:0, width:self.frame.size.width, height:width)
        if let subLayers = self.layer.sublayers {
            for subLayer in subLayers{
                if subLayer is BorderLayer{
                    subLayer.removeFromSuperlayer()
                    break
                }
            }
        }
        self.layer.addSublayer(border)
    }
    func addBottomThinBorderWithColor(_ color: UIColor) {
        let border = CALayer()
        let width = 1.0/(UIScreen.main.scale/4)
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        if let subLayers = self.layer.sublayers {
            for subLayer in subLayers{
                if subLayer is BorderLayer{
                    subLayer.removeFromSuperlayer()
                    break
                }
            }
        }
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = BorderLayer()

        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:self.frame.size.width - width, y:0,width:width, height:self.frame.size.height)
        if let subLayers = self.layer.sublayers {
            for subLayer in subLayers{
                if subLayer is BorderLayer{
                    subLayer.removeFromSuperlayer()
                    break
                }
            }
        }
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        if let subLayers = self.layer.sublayers {
            for subLayer in subLayers{
                if subLayer is BorderLayer{
                    subLayer.removeFromSuperlayer()
                    break
                }
            }
        }
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        if let subLayers = self.layer.sublayers {
            for subLayer in subLayers{
                if subLayer is BorderLayer{
                    subLayer.removeFromSuperlayer()
                    break
                }
            }
        }
        self.layer.addSublayer(border)
    }

}

extension UIView{
    func addDashedLineBorder(color:UIColor,pattern:[NSNumber]) {
        let color = color.cgColor

        let shapeLayer = DashedBorderLayer()
        let frameSize = (self.frame.size)
        let shapeRect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = pattern
        shapeLayer.path = UIBezierPath(rect: shapeRect).cgPath
        if let subLayers = self.layer.sublayers {
            for subLayer in subLayers{
                if subLayer is DashedBorderLayer{
                    subLayer.removeFromSuperlayer()
                    break
                }
            }
        }
        self.layer.addSublayer(shapeLayer)
    }
}

 extension UIView {

    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue

            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }

    func applyShadow(shadowSize: CGFloat){
        let shadowPath = UIBezierPath(rect: CGRect(x: self.frame.origin.x - shadowSize,
                                                   y: self.frame.origin.y - shadowSize,
                                                   width: self.frame.size.width + shadowSize,
                                                   height: self.frame.size.height + shadowSize))
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowPath = shadowPath.cgPath
    }

    func addShadow(_ shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}


typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

 enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical

    var startPoint: CGPoint {
        return points.startPoint
    }

    var endPoint: CGPoint {
        return points.endPoint
    }

    var points: GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint.init(x: 0.0, y: 1.0), CGPoint.init(x: 1.0, y: 0.0))
        case .topLeftBottomRight:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 1, y: 1))
        case .horizontal:
            return (CGPoint.init(x: 0.0, y: 0.5), CGPoint.init(x: 1.0, y: 0.5))
        case .vertical:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 0.0, y: 1.0))
        }
    }
}

extension UIView {

    func applyGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        if let glayer = self.layer.sublayers?.first as? CAGradientLayer{
            glayer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradient, at: 0)
    }



    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        if let glayer = self.layer.sublayers?.first as? CAGradientLayer{
            glayer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradient, at: 0)
    }

    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation,locations: [NSNumber]? = nil) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        gradient.locations = locations
        if let glayer = self.layer.sublayers?.first as? CAGradientLayer{
            glayer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}


@objc extension UIView{
    @objc func applyGradientInObjC(withColours colours: [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        if let glayer = self.layer.sublayers?.first as? CAGradientLayer{
            glayer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}






extension UIView {
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }

    func popTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromBottom
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}


/*
 It is convenient if anything that can simmer conforms to this protocol
 */
protocol Shimmerable {
    func startShimmering(count: Int) -> Void
    func stopShimmering() -> Void
    var lightShimmerColor: UIColor {get set}
    var darkShimmerColor: UIColor {get set}
    var isShimmering: Bool {get}
}


@IBDesignable
extension UIView: Shimmerable {
    
    /*
     A way to store the custom properties
     */
    private struct UIViewCustomShimmerProperties {
        static let shimmerKey:String = "shimmer"
        static var lightShimmerColor:CGColor = UIColor.white.withAlphaComponent(0.1).cgColor
        static var darkShimmerColor:CGColor = UIColor.black.withAlphaComponent(1).cgColor
        static var isShimmering:Bool = false
        static var gradient:CAGradientLayer = CAGradientLayer()
        static var animation:CABasicAnimation = CABasicAnimation(keyPath: "locations")
    }
    
    /*
     Set shimmer properties
     */
    @IBInspectable
    var lightShimmerColor: UIColor {
        get {
            return UIColor(cgColor: UIViewCustomShimmerProperties.lightShimmerColor)
        }
        set {
            UIViewCustomShimmerProperties.lightShimmerColor = newValue.cgColor
        }
    }
    @IBInspectable
    var darkShimmerColor: UIColor {
        get {
            return UIColor(cgColor: UIViewCustomShimmerProperties.darkShimmerColor)
        }
        set {
            UIViewCustomShimmerProperties.darkShimmerColor = newValue.cgColor
        }
    }
    
    var isShimmering: Bool {
        get {
            return UIViewCustomShimmerProperties.isShimmering
        }
    }
    
    func stopShimmering() {
        guard UIViewCustomShimmerProperties.isShimmering else {return}
        self.layer.mask?.removeAnimation(forKey: UIViewCustomShimmerProperties.shimmerKey)
        self.layer.mask = nil
        UIViewCustomShimmerProperties.isShimmering = false
        self.layer.setNeedsDisplay()
    }
    
    func startShimmering(count: Int = 0) {
        guard !UIViewCustomShimmerProperties.isShimmering else {return}
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.stopShimmering()
        })
        
        UIViewCustomShimmerProperties.isShimmering = true
        
        UIViewCustomShimmerProperties.gradient.colors = [UIViewCustomShimmerProperties.darkShimmerColor, UIViewCustomShimmerProperties.lightShimmerColor, UIViewCustomShimmerProperties.darkShimmerColor];
        UIViewCustomShimmerProperties.gradient.frame = CGRect(x: CGFloat(-2*self.bounds.size.width), y: CGFloat(0.0), width: CGFloat(8*self.bounds.size.width), height: CGFloat(self.bounds.size.height))
        UIViewCustomShimmerProperties.gradient.startPoint = CGPoint(x: Double(0.0), y: Double(0.8));
        UIViewCustomShimmerProperties.gradient.endPoint = CGPoint(x: Double(1.0), y: Double(0.8));
        UIViewCustomShimmerProperties.gradient.locations = [0.4, 0.5, 0.6];
        
        UIViewCustomShimmerProperties.animation.duration = 1.0
        UIViewCustomShimmerProperties.animation.repeatCount = (count > 0) ? Float(count) : .infinity
        UIViewCustomShimmerProperties.animation.fromValue = [0.0, 0.12, 0.3]
        UIViewCustomShimmerProperties.animation.toValue = [0.6, 0.86, 1.0]
        
        UIViewCustomShimmerProperties.gradient.add(UIViewCustomShimmerProperties.animation, forKey: UIViewCustomShimmerProperties.shimmerKey)
        self.layer.mask = UIViewCustomShimmerProperties.gradient;
        
        CATransaction.commit()
    }
}
