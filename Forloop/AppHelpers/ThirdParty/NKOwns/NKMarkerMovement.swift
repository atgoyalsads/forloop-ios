//
//  NKMarkerMovement.swift
//  RideApp
//
//  Created by Nakul Sharma on 28/07/18.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

//class NKMarkerMovement{
//    static let shared = NKMarkerMovement()
//    fileprivate init() {}
//
//    func moveMarker(_ marker : GMSMarker,fromSource source:CLLocationCoordinate2D, to destination:CLLocationCoordinate2D,completionBlock:@escaping (_ movedMarkerPosition:CLLocationCoordinate2D) -> Void){
//        let start = source
//        let startRotation = marker.rotation
//        let animator = ValueAnimator.animate("", from: 0, to: 1, duration: 1.0) { (prop, value) in
//            let v = value.value
//            let newPosition = self.getInterpolation(fraction: v, startPoint: start, endPoint: destination)
//            marker.position = newPosition
//            let newBearing = self.bearingFromCoordinate(from: start, to: newPosition)
//            let rotation = self.getRotation(fraction: v, start: startRotation, end: newBearing)
//            marker.rotation = rotation
//            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
//            marker.isFlat = true
//            completionBlock(start)
//        }
//        animator.resume()
//
//    }
//
//
//    private func angleFromCoordinate(from first : CLLocationCoordinate2D, to seccond:CLLocationCoordinate2D) -> Double {
//        let deltaLongitude = seccond.longitude - first.longitude
//        let deltaLatitude = seccond.latitude - first.latitude
//        let angle = (.pi * 0.5) - atan(deltaLatitude/deltaLongitude)
//        if deltaLongitude > 0 {return angle}
//        else if deltaLongitude < 0 {return angle + .pi}
//        else if deltaLatitude == 0 {return .pi}
//        return 0.0
//    }
//
//
//    func bearingFromCoordinate(from first : CLLocationCoordinate2D, to seccond:CLLocationCoordinate2D) -> Double {
//        let pi = Double.pi
//        let lat1 = first.latitude*pi/180.0
//        let long1 = first.longitude*pi/180.0
//        let lat2 = seccond.latitude*pi/180.0
//        let long2 = seccond.longitude*pi/180.0
//
//        let diffLong = long2 - long1
//        let y = sin(diffLong)*cos(lat2)
//        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(diffLong)
//        var bearing = atan2(y, x)
//        bearing = bearing.toDegree(fromRadian: bearing)
//        bearing = (bearing+360).truncatingRemainder(dividingBy: 360)
//        return bearing
//    }
//
//
//    private func getRotation(fraction:Double, start: Double, end: Double) -> Double{
//        let normailizedEnd = end - start
//        let normailizedEndAbs = ((normailizedEnd+360)).truncatingRemainder(dividingBy: 360)
//        let direction = (normailizedEndAbs > 180) ? -1 : 1 //-1 for anticlockwise and 1 for closewise
//        let rotation = (direction > 0) ? normailizedEndAbs : (normailizedEndAbs-360)
//        let result = fraction*rotation+start
//        let finalResult = (result+360).truncatingRemainder(dividingBy: 360)
//        return finalResult
//    }
//
//    private func getInterpolation(fraction:Double, startPoint:CLLocationCoordinate2D, endPoint:CLLocationCoordinate2D) -> CLLocationCoordinate2D{
//        let latitude = (endPoint.latitude - startPoint.latitude) * fraction + startPoint.latitude
//        var longDelta = endPoint.longitude - startPoint.longitude
//        if abs(longDelta) > 180{
//            longDelta -= longDelta*360
//        }
//        let longitude = (longDelta*fraction) + startPoint.longitude
//        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//
//    
//}



extension Double{
    func toDegree(fromRadian radian:Double) -> Double{
        return radian*180/Double.pi
    }

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}










import Foundation

public class ValueAnimator: Hashable {

    public struct Option {
        let yoyo: Bool
        let repeatCount: Int
        let delay: TimeInterval
        let repeatInfinitely: Bool
    }

    public class OptionBuilder {
        var yoyo: Bool = false
        var repeatCount: Int = 0
        var delay: TimeInterval = 0
        var repeatInfinitely: Bool = false

        public init() {
        }

        public func setYoyo(_ v: Bool) -> OptionBuilder {
            yoyo = v
            return self
        }

        public func setRepeatCount(_ v: Int) -> OptionBuilder {
            repeatCount = v
            return self
        }

        public func setDelay(_ v: TimeInterval) -> OptionBuilder {
            delay = v
            return self
        }

        public func setRepeatInfinitely(_ b: Bool) -> OptionBuilder {
            repeatInfinitely = b
            return self
        }

        public func build() -> Option {
            return Option(yoyo: yoyo, repeatCount: repeatCount, delay: delay, repeatInfinitely: repeatInfinitely)
        }
    }

    public typealias EndFunction = () -> Void
    public typealias ChangeFunction = (String, ValueAnimatable) -> Void

    private lazy var objectIdentifier = ObjectIdentifier(self)
    private var props = [String]()
    private var startTime: TimeInterval = 0
    private var initials = [String: ValueAnimatable]()
    private var changes = [String: ValueAnimatable]()
    private var duration: TimeInterval = 1

    /// seconds in covered on timeline
    private var covered: TimeInterval = 0
    /// seconds to delay
    private var delay: TimeInterval = 0
    /// yoyo animation
    public private(set) var yoyo = false
    /// how many it repeat animation.
    public private(set) var repeatCount: Int = 0
    /// animated count
    public private(set) var counted: Int = 0 {
        didSet {
            #if DEBUG
            print("ValueAnimator--- counted: \(counted)")
            #endif
        }
    }
    private lazy var easingCapture: Easing = EaseLinear.easeInOut()
    public var easing: Easing! {
        set {
            if !isAnimating {
                easingCapture = newValue
            }
        }
        get {
            return easingCapture
        }
    }
    /// whether if it repeat infinitely or not.
    /// if true, animation ignores repeatCount
    public private(set) var isInfinitely = false
    public private(set) var isAnimating = false
    public private(set) var isFinished = false
    public private(set) var isDisposed = false

    /// callback for animation updates
    public var changeFunction: ChangeFunction? = nil
    /// callback for animation finishes
    public var endFunction: EndFunction? = nil

    public var hashValue: Int {
        return self.objectIdentifier.hashValue
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.objectIdentifier)
    }

    public var callbackOnMainThread: Bool = true

    public static func ==(left: ValueAnimator, right: ValueAnimator) -> Bool {
        return left.objectIdentifier == right.objectIdentifier
    }

    private init() {
    }

    public func resume() {
        isAnimating = true
    }

    public func pause() {
        isAnimating = false
    }

    public func finish() {
        isFinished = true
    }

    public func dispose() {
        isDisposed = true
    }


    // MARK: class values

    static public var debug = false
    static public var frameRate: Int = 40 {
        didSet {
            sleepTime = 1 / Double(frameRate)
        }
    }
    static private var nowTime: TimeInterval = 0
    static private var renderer: Thread? = nil
    static private var aniList = Set<ValueAnimator>()
    static private var sleepTime: TimeInterval = 0.02

    static public func finishAll() {
        aniList.forEach {
            $0.finish()
        }
    }

    static public func disposeAll() {
        aniList.removeAll()
    }

    static public func hasAnimation(_ prop: String) -> Bool {
        return aniList.first{ $0.props.contains(prop) } != nil
    }

    @discardableResult
    static public func animate(_ prop: String,
                               from: AnimatableValueType,
                               to: AnimatableValueType,
                               duration: TimeInterval,
                               easing: Easing? = nil,
                               onChanged: ChangeFunction? = nil) -> ValueAnimator {
        return animate(props: [prop],
                       from: [from],
                       to: [to],
                       duration: duration,
                       easing: easing,
                       onChanged: onChanged,
                       option: nil,
                       onEnd: nil)
    }

    @discardableResult
    static public func animate(_ prop: String,
                               from: AnimatableValueType,
                               to: AnimatableValueType,
                               duration: TimeInterval,
                               onChanged: ChangeFunction? = nil) -> ValueAnimator {
        return animate(props: [prop],
                       from: [from],
                       to: [to],
                       duration: duration,
                       easing: nil,
                       onChanged: onChanged,
                       option: nil,
                       onEnd: nil)
    }

    @discardableResult
    static public func animate(_ prop: String,
                               from: AnimatableValueType,
                               to: AnimatableValueType,
                               duration: TimeInterval,
                               easing: Easing? = nil,
                               onChanged: ChangeFunction? = nil,
                               option: Option? = nil) -> ValueAnimator {
        return animate(props: [prop],
                       from: [from],
                       to: [to],
                       duration: duration,
                       easing: easing,
                       onChanged: onChanged,
                       option: option,
                       onEnd: nil)
    }

    @discardableResult
    static public func animate(props: [String],
                               from: [AnimatableValueType],
                               to: [AnimatableValueType],
                               duration: TimeInterval,
                               easing: Easing? = nil,
                               onChanged: ChangeFunction? = nil,
                               option: Option? = nil,
                               onEnd: EndFunction? = nil) -> ValueAnimator {
        let ani = ValueAnimator()
        ani.props = props
        for (i, p) in props.enumerated() {
            ani.initials[p] = from[i].toAnimatable()
            ani.changes[p] = to[i].toAnimatable() - from[i].toAnimatable()
        }
        ani.duration = duration
        if let easingFn = easing {
            ani.easing = easingFn
        }
        ani.endFunction = onEnd
        if let option = option {
            ani.yoyo = option.yoyo
            ani.repeatCount = option.repeatCount
            ani.delay = option.delay
            ani.isInfinitely = option.repeatInfinitely
        }
        if ani.yoyo && ani.repeatCount > 0 {
            ani.repeatCount *= 2
        }
        ani.changeFunction = onChanged
        ani.startTime = Date().timeIntervalSince1970

        aniList.insert(ani)
        if debug {
            print("ValueAnimator -----------: aniList added id: \(ani.hashValue)")
        }
        // start runLoop if not running
        if renderer == nil || renderer?.isFinished == true {
            renderer = Thread(target: self, selector: #selector(onProgress), object: nil)
            renderer?.name = "renderer"
            renderer?.qualityOfService = .default
            renderer?.start()
        }

        return ani
    }

    @objc
    static private func onProgress() {
        if renderer == nil{
            return
        }
        while aniList.count > 0 {
            for ani in aniList {
                update(ani)
            }
            Thread.sleep(forTimeInterval: sleepTime)

            if renderer != nil && renderer!.isFinished {
                print("ValueAnimator is finished because main thread is finished")
                Thread.exit()
            }
        }

        if debug {
            print("ValueAnimator nothing to animate")
        }
        Thread.exit()
    }

    static private func update(_ ani: ValueAnimator) {
        if ani.isDisposed {
            dispose(ani)
            return
        }
        if ani.isFinished {
            finish(ani)
            return
        }

        nowTime = Date().timeIntervalSince1970

        if !ani.isAnimating {
            ani.startTime = nowTime - ani.covered * 1000.0
            return
        }

        if ani.delay > 0 {
            ani.delay -= (nowTime - ani.startTime)
            ani.startTime = nowTime
            return
        }
        // 시간 계산
        ani.covered = nowTime - ani.startTime
        // repeating
        if ani.covered >= ani.duration {
            if ani.yoyo {
                if ani.repeatCount <= 0 || ani.repeatCount > ani.counted || ani.isInfinitely {
                    for p in ani.props {
                        if let initial = ani.initials[p],
                            let changeEnd = ani.changes[p] {
                            let changed = initial + changeEnd
                            change(ani, p, changed)
                            ani.initials[p] = changed
                            ani.changes[p]! *= -1.0
                        }
                    }
                    ani.startTime = nowTime
                    ani.counted += 1
                    return
                }
            }
            if ani.counted < ani.repeatCount || ani.isInfinitely {
                for p in ani.props {
                    if let initial = ani.initials[p] {
                        change(ani, p, initial)
                    }
                }
                ani.startTime = nowTime
                ani.counted += 1
                return
            }

            finish(ani)
        } else {
            // call updates in progress
            for p in ani.props {
                change(ani, p, ani.easing(ani.covered, ani.initials[p]!.value, ani.changes[p]!.value, ani.duration).toAnimatable())
            }
        }
    }

    static private func change(_ ani: ValueAnimator, _ p: String, _ v: ValueAnimatable) {
        if ani.callbackOnMainThread {
            DispatchQueue.main.async {
                ani.changeFunction?(p, v)
            }
        } else {
            ani.changeFunction?(p, v)
        }
    }

    /// finish animation and update value with target
    static private func finish(_ ani: ValueAnimator) {
        if self.renderer == nil{return}
        if aniList.count == 0{return}
        guard let _ani = ani as ValueAnimator? else{
            return
        }
        aniList.remove(_ani)
        for p in _ani.props {
            if let initial = _ani.initials[p],
                let amount = _ani.changes[p] {
                change(ani, p, initial + amount)
            }
        }
        _ani.isAnimating = false
        _ani.isFinished = true
        if ani.callbackOnMainThread {
            DispatchQueue.main.async {
                _ani.endFunction?()
            }
        } else {
            _ani.endFunction?()
        }
    }

    /// finish animation during animation
    static private func dispose(_ ani: ValueAnimator) {
        if self.renderer == nil{return}
        if aniList.count == 0{return}
        guard let _ani = ani as ValueAnimator? else{
            return
        }
        aniList.remove(_ani)
        _ani.isDisposed = true
        _ani.isAnimating = false
    }
}


/// Easing method
///
/// - Parameters:
///   - t Specifies the current time, between 0 and duration inclusive.
///   - b Specifies the initial value of the animation property.
///   - c Specifies the total change in the animation property.
///   - d Specifies the duration of the motion.
/// - Returns: The value of the interpolated property at the specified time.
public typealias Easing = (_ t: Double, _ b: Double, _ c: Double, _ d: Double) -> Double


import CoreGraphics // CGFloat
import Foundation

public protocol AnimatableValueType {
    func toAnimatable() -> ValueAnimatable
}

public struct ValueAnimatable {
    public var value: Double

    public init(_ value: Int) {
        self.value = Double(value)
    }

    public init(_ value: Float) {
        self.value = Double(value)
    }

    public init(_ value: CGFloat) {
        self.value = Double(value)
    }

    public init(_ value: Double) {
        self.value = value
    }

    public var timeInterval: Foundation.TimeInterval {
        return TimeInterval(value)
    }
}

extension ValueAnimatable {
    public var cg: CGFloat {
        return CGFloat(value)
    }
    public var i: Int {
        return Int(value)
    }
    public var f: Float {
        return Float(value)
    }
    public var d: Double {
        return value
    }
}

extension ValueAnimatable: Hashable {
    public static func ==(lhs: ValueAnimatable, rhs: ValueAnimatable) -> Bool {
        return lhs.value == rhs.value
    }

//    public var hashValue: Int {
//        return timeInterval.hashValue
//    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(timeInterval)
    }
}

extension ValueAnimatable {

    public static func <(lhs: ValueAnimatable, rhs: ValueAnimatable) -> Bool {
        return lhs.value < rhs.value
    }

    public static func <=(lhs: ValueAnimatable, rhs: ValueAnimatable) -> Bool {
        return lhs.value <= rhs.value
    }

    public static func >(lhs: ValueAnimatable, rhs: ValueAnimatable) -> Bool {
        return lhs.value >= rhs.value
    }

    public static func >=(lhs: ValueAnimatable, rhs: ValueAnimatable) -> Bool {
        return lhs.value >= rhs.value
    }
}

extension ValueAnimatable {

    public prefix static func -(lhs: ValueAnimatable) -> ValueAnimatable {
        return ValueAnimatable(-lhs.value)
    }

    public static func +(lhs: ValueAnimatable, rhs: ValueAnimatable) -> ValueAnimatable {
        let inValue = lhs.value + rhs.value
        return ValueAnimatable(inValue)
    }

    public static func -(lhs: ValueAnimatable, rhs: ValueAnimatable) -> ValueAnimatable {
        return lhs + (-rhs)
    }

    public static func +=(lhs: inout ValueAnimatable, rhs: ValueAnimatable) {
        lhs = lhs + rhs
    }

    public static func -=(lhs: inout ValueAnimatable, rhs: ValueAnimatable) {
        lhs = lhs - rhs
    }

    public static func *=(lhs: inout ValueAnimatable, rhs: Double) {
        lhs = lhs * rhs
    }

    public static func *(lhs: ValueAnimatable, rhs: Double) -> ValueAnimatable {
        return ValueAnimatable(lhs.value * rhs)
    }

    public static func /(lhs: ValueAnimatable, rhs: Double) -> ValueAnimatable {
        return ValueAnimatable(lhs.value / rhs)
    }
}

extension Int: AnimatableValueType {
    public func toAnimatable() -> ValueAnimatable {
        return ValueAnimatable(self)
    }
}

extension Float: AnimatableValueType {
    public func toAnimatable() -> ValueAnimatable {
        return ValueAnimatable(self)
    }
}

extension CGFloat: AnimatableValueType {
    public func toAnimatable() -> ValueAnimatable {
        return ValueAnimatable(self)
    }
}

extension Double: AnimatableValueType {
    public func toAnimatable() -> ValueAnimatable {
        return ValueAnimatable(self)
    }
}



public class EaseLinear {

    /// The easeNone method defines a constant motion with no acceleration.
    public static func easeNone() -> Easing {
        return { t, b, c, d in
            return c * t / d + b
        }
    }

    /// The easeIn method defines a constant motion with no acceleration.
    public static func easeIn() -> Easing {
        return { t, b, c, d in
            return c * t / d + b
        }
    }
    /// The easeOut method defines a constant motion with no acceleration.
    public static func easeOut() -> Easing {
        return { t, b, c, d in
            return c * t / d + b
        }
    }
    /// The easeNone method defines a constant motion with no acceleration.
    public static func easeInOut() -> Easing {
        return { t, b, c, d in
            return c * t / d + b
        }
    }
}

