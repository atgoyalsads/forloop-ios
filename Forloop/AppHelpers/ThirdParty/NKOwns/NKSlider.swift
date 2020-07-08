//  NSSlider
//
//  Created by Nakul Sharma on 10/06/19.
//  Copyright © 2019 TecOrb Technologies Pvt. Ltd. All rights reserved.

import UIKit

public protocol NKSliderDelegate: class {
    func startDragging(slider: NKSlider)
    func endDragging(slider: NKSlider)
    func nkSlider(slider: NKSlider, dragged to: Float)
}
public protocol NKSliderDataSource:class{
    func slider(slider:NKSlider, textForToolTipForValue value: Double) -> String
    func slider(slider:NKSlider, textForTumbForValue value: Double) -> String
}

@IBDesignable
open class NKSlider: UISlider {
    
    open weak var delegate: NKSliderDelegate?
    open weak var dataSource: NKSliderDataSource?

    var thumbTextLabel: NKCustomLabel = NKCustomLabel()

    open var markPositions: [Float]?
    
    @IBInspectable
    open var markWidth : CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var markColor : UIColor = UIColor.clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var selectedBarColor: UIColor = UIColor.red{
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable
    open var unselectedBarColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var handlerImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var handlerColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var handlerTextColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
        
    open var lineCap: CGLineCap = .round {
        didSet {
            setNeedsDisplay()
        }
    }
    var font: UIFont = fonts.Roboto.bold.font(.small) {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var height: CGFloat = 12.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var toolTipView: NKTooltipView!
    
    var thumbRect: CGRect {
        let rect = trackRect(forBounds: bounds)
        return thumbRect(forBounds: bounds, trackRect: rect, value: value)
    }

    private var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }

    // MARK: view life circle
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        setup()
    }
    
    // MARK: local functions
    func setup() {
        thumbTextLabel.backgroundColor = appColor.appBlueColor
        thumbTextLabel.textColor = handlerTextColor
        thumbTextLabel.font = font
        addSubview(thumbTextLabel)
        thumbTextLabel.textAlignment = .center
        thumbTextLabel.layer.zPosition = layer.zPosition + 1

        toolTipView = NKTooltipView(frame: CGRect.zero)
        toolTipView.backgroundColor = UIColor.clear
        toolTipView.font = font
        toolTipView.fillColor = appColor.appBlueColor
        self.addSubview(toolTipView)
        self.bringSubviewToFront(thumbTextLabel)
    }
    
    // MARK: UIControl touch event tracking
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        delegate?.startDragging(slider: self)
        // Fade in and update the popup view
        let touchPoint = touch.location(in: self)
        // Check if the knob is touched. Only in this case show the popup-view
        if thumbRect.contains(touchPoint) {
            positionAndUpdatePopupView()
            fadePopupViewInAndOut(fadeIn: true)
        }
        return super.beginTracking(touch, with: event)
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // Update the popup view as slider knob is being moved
        positionAndUpdatePopupView()
        return super.continueTracking(touch, with: event)
    }
    
    open override func cancelTracking(with event: UIEvent?) {
        delegate?.endDragging(slider: self)
        super.cancelTracking(with: event)
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        // Fade out the popoup view
        delegate?.endDragging(slider: self)
        delegate?.nkSlider(slider: self, dragged: value)
        fadePopupViewInAndOut(fadeIn: false)
        super.endTracking(touch, with: event)
    }
    
    private func positionAndUpdatePopupView() {
        
        let tRect = CGRect(x: thumbRect.origin.x, y: thumbRect.origin.y, width: 60, height: 20) //thumbRect
        let popupRect = tRect.offsetBy(dx: 0, dy: -(tRect.size.height * 1))
        toolTipView.frame = popupRect.insetBy(dx: -5, dy: -5)
        guard let dSource = dataSource else {
            toolTipView.value = value
            return
        }

        toolTipView.text = dSource.slider(slider: self, textForToolTipForValue: Double(value))
        thumbTextLabel.text = dSource.slider(slider: self, textForTumbForValue: Double(value))
        thumbTextLabel.sizeToFit()
        thumbTextLabel.leftTextInset = 6
        thumbTextLabel.rightTextInset = 6
        thumbTextLabel.bottomTextInset = 3
        thumbTextLabel.topTextInset = 3
        thumbTextLabel.center = thumbFrame.center
        thumbTextLabel.makeCorenerRadius()
    }
    
    private func fadePopupViewInAndOut(fadeIn: Bool) {

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        if fadeIn {
            toolTipView.alpha = 1.0
        } else {
            toolTipView.alpha = 0.0
        }
        UIView.commitAnimations()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        thumbTextLabel.textColor = UIColor.white
        guard let dSource = dataSource else {
            toolTipView.value = value
            return
        }
        thumbTextLabel.text = dSource.slider(slider: self, textForTumbForValue: Double(value))
//        let frame = CGRect(x: 0, y: 0, width: 60, height: 30)
//        thumbTextLabel.frame = frame
        thumbTextLabel.sizeToFit()
        thumbTextLabel.leftTextInset = 6
        thumbTextLabel.rightTextInset = 6
        thumbTextLabel.bottomTextInset = 3
        thumbTextLabel.topTextInset = 3
        thumbTextLabel.center = thumbFrame.center
        thumbTextLabel.makeCorenerRadius()

    }

    // MARK: drawing
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // We create an innerRect in which we paint the lines
        let innerRect = rect.insetBy(dx: 1.0, dy: 10.0)
        
        UIGraphicsBeginImageContextWithOptions(innerRect.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            // Selected side
            context.setLineCap(lineCap)
            context.setLineWidth(height)
            context.move(to: CGPoint(x:height/2, y:innerRect.height/2))
            context.addLine(to: CGPoint(x:innerRect.size.width - 10, y:innerRect.height/2))
            context.setStrokeColor(self.selectedBarColor.cgColor)
            context.strokePath()
            
            let selectedSide = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero)
            
            // Unselected side
            context.setLineCap(lineCap)
            context.setLineWidth(height)
            context.move(to: CGPoint(x: height/2, y: innerRect.height/2))
            context.addLine(to: CGPoint(x: innerRect.size.width - 10,y: innerRect.height/2))
            context.setStrokeColor(self.unselectedBarColor.cgColor)
            context.strokePath()
            
            let unselectedSide = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero)
            
            
            // Set strips on selected side
            selectedSide?.draw(at: CGPoint.zero)
            
            if let positions = self.markPositions {
                for i in 0..<positions.count {
                    context.setLineWidth(self.markWidth)
                    let position = CGFloat(positions[i]) * innerRect.size.width / 100.0
                    context.move(to: CGPoint(x:position, y:innerRect.height/2 - (height/2 - 1)))
                    context.addLine(to: CGPoint(x:position, y:innerRect.height/2 + (height/2 - 1)))
                    context.setStrokeColor(self.markColor.cgColor)
                    context.strokePath()
                }
            }
            
            let selectedStripSide = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero)
            
//            context.clear(rect)
            
            // Set trips on unselected side
            unselectedSide?.draw(at: CGPoint.zero)
            if let positions = self.markPositions {
                for i in 0..<positions.count {
                    context.setLineWidth(self.markWidth)
                    let position = CGFloat(positions[i])*innerRect.size.width/100.0
                    context.move(to: CGPoint(x:position,y:innerRect.height/2-(height/2 - 1)))
                    context.addLine(to: CGPoint(x:position,y:innerRect.height/2+(height/2 - 1)))
                    context.setStrokeColor(self.markColor.cgColor)
                    context.strokePath()
                }
            }
            
            let unselectedStripSide = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero)
            
            context.clear(rect)
            UIGraphicsEndImageContext()
            
            setMinimumTrackImage(selectedStripSide, for: .normal)
            setMaximumTrackImage(unselectedStripSide, for: .normal)
            if handlerImage != nil {
                setThumbImage(handlerImage, for: .normal)
            } else {
                setThumbImage(UIImage(), for: .normal)
                thumbTintColor = .clear
            }
        }
    }
    
}



extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
}

extension UIView{
    func makeCorenerRadius(){
    self.layer.cornerRadius = self.bounds.size.height/4
    self.clipsToBounds = true
    }
}


extension CGRect{
    /** Creates a rectangle with the given center and dimensions
     - parameter center: The center of the new rectangle
     - parameter size: The dimensions of the new rectangle
     */
    init(center: CGPoint, size: CGSize)
    {
        self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }

    /** the coordinates of this rectangles center */
    var center: CGPoint
    {
        get { return CGPoint(x: centerX, y: centerY) }
        set { centerX = newValue.x; centerY = newValue.y }
    }

    /** the x-coordinate of this rectangles center
     - note: Acts as a settable midX
     - returns: The x-coordinate of the center
     */
    var centerX: CGFloat
    {
        get { return midX }
        set { origin.x = newValue - width * 0.5 }
    }

    /** the y-coordinate of this rectangles center
     - note: Acts as a settable midY
     - returns: The y-coordinate of the center
     */
    var centerY: CGFloat
    {
        get { return midY }
        set { origin.y = newValue - height * 0.5 }
    }

    // MARK: - "with" convenience functions

    /** Same-sized rectangle with a new center
     - parameter center: The new center, ignored if nil
     - returns: A new rectangle with the same size and a new center
     */
    func with(center: CGPoint?) -> CGRect
    {
        return CGRect(center: center ?? self.center, size: size)
    }

    /** Same-sized rectangle with a new center-x
     - parameter centerX: The new center-x, ignored if nil
     - returns: A new rectangle with the same size and a new center
     */
    func with(centerX: CGFloat?) -> CGRect
    {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY), size: size)
    }

    /** Same-sized rectangle with a new center-y
     - parameter centerY: The new center-y, ignored if nil
     - returns: A new rectangle with the same size and a new center
     */
    func with(centerY: CGFloat?) -> CGRect
    {
        return CGRect(center: CGPoint(x: centerX, y: centerY ?? self.centerY), size: size)
    }

    /** Same-sized rectangle with a new center-x and center-y
     - parameter centerX: The new center-x, ignored if nil
     - parameter centerY: The new center-y, ignored if nil
     - returns: A new rectangle with the same size and a new center
     */
    func with(centerX: CGFloat?, centerY: CGFloat?) -> CGRect
    {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY ?? self.centerY), size: size)
    }
}
