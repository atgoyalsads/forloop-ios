//
//  UIIMage.swift
//  RideApp
//
//  Created by Nakul Sharma on 31/05/19.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//


import UIKit
import ImageIO

public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    public func base64(format: ImageFormat) -> String? {
        var imageData: Data?
        switch format {
        case .png: imageData = self.pngData()
        case .jpeg(let compression): imageData = self.jpegData(compressionQuality: compression)
        }
        return imageData?.base64EncodedString()
    }

    func makeImageWithColorAndSize(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(CGRect(x:0, y:0, width:size.width, height:size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

 func drawAvatar(size: CGSize,
                            letters: String,
                            lettersFont: UIFont,
                            lettersColor: UIColor,
                            backgroundColor: CGColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(backgroundColor)
            context.fill(rect)

            let style = NSParagraphStyle.default.mutableCopy()
            #if swift(>=4.0)
                let attributes = [
                    NSAttributedString.Key.paragraphStyle: style,
                    NSAttributedString.Key.font: lettersFont.withSize(min(size.height, size.width) / 2.0),
                    NSAttributedString.Key.foregroundColor: lettersColor
                ]

                let lettersSize = letters.size(withAttributes: attributes)
            #else
                let attributes = [
                NSParagraphStyleAttributeName: style,
                NSFontAttributeName: lettersFont.withSize(min(size.height, size.width) / 2.0),
                NSForegroundColorAttributeName: lettersColor
                ]

                let lettersSize = letters.size(attributes: attributes)
            #endif

            let lettersRect = CGRect(
                x: (rect.size.width - lettersSize.width) / 2.0,
                y: (rect.size.height - lettersSize.height) / 2.0,
                width: lettersSize.width,
                height: lettersSize.height
            )
            letters.draw(in: lettersRect, withAttributes: attributes)

            let avatarImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return avatarImage
        }
        return nil
    }


}


extension UIImage {
    static func drawDottedImage(width: CGFloat, height: CGFloat, color: UIColor) -> UIImage {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 1.5, y: 1.0))
        path.addLine(to: CGPoint(x:1.5,y:height-1))
        path.lineWidth = 1
        let dashes: [CGFloat] = [path.lineWidth, path.lineWidth * 2.5]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = .round
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height-2), false, 2)
        UIColor.white.setFill()
        UIGraphicsGetCurrentContext()!.fill(.infinite)
        UIColor.black.setStroke()
        path.stroke()

        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    static func drawDottedSeparatorImage(width: CGFloat, height: CGFloat, color: UIColor) -> UIImage {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 1.0, y: 1.0))
        path.addLine(to: CGPoint(x:width-1,y:1))
        path.lineWidth = 1

        let dashes: [CGFloat] = [path.lineWidth, path.lineWidth*3]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.round

        UIGraphicsBeginImageContextWithOptions(CGSize(width:width, height:1), false, 2)

        UIColor.white.setFill()
        UIGraphicsGetCurrentContext()!.fill(.infinite)

        UIColor.black.setStroke()
        path.stroke()

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}


extension UIImage {

    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func resizedTo1MB() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }

        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1024.0 // ! Or devide for 1024 if you need KB but not kB

        while imageSizeKB > 1024 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = resizedImage.pngData()
                else { return nil }

            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1024.0 // ! Or devide for 1024 if you need KB but not kB
        }

        return resizingImage
    }
}










private let ChannelDivider: CGFloat = 255

public class RGBA: NSObject {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init(intRed: Int, green: Int, blue: Int, alpha: Int) {
        self.red = CGFloat(intRed)/ChannelDivider
        self.green = CGFloat(green)/ChannelDivider
        self.blue = CGFloat(blue)/ChannelDivider
        self.alpha = CGFloat(alpha)/ChannelDivider
    }
}

public class Grayscale: NSObject {
    var white: CGFloat
    var alpha: CGFloat

    init(white: CGFloat, alpha: CGFloat) {
        self.white = white
        self.alpha = alpha
    }
}

public class GradientPoint<C>: NSObject {
    var location: CGFloat
    var color: C

    init(location: CGFloat, color: C) {
        self.location = location
        self.color = color
    }
}



    extension UIImage {
        
        public class func gifImageWithData(_ data: Data) -> UIImage? {
            guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                print("image doesn't exist")
                return nil
            }
            
            return UIImage.animatedImageWithSource(source)
        }
        
        public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
            guard let bundleURL:URL? = URL(string: gifUrl)
                else {
                    print("image named \"\(gifUrl)\" doesn't exist")
                    return nil
            }
            guard let imageData = try? Data(contentsOf: bundleURL!) else {
                print("image named \"\(gifUrl)\" into NSData")
                return nil
            }
            
            return gifImageWithData(imageData)
        }
        
        public class func gifImageWithName(_ name: String) -> UIImage? {
            guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
                    print("SwiftGif: This image named \"\(name)\" does not exist")
                    return nil
            }
            guard let imageData = try? Data(contentsOf: bundleURL) else {
                print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
                return nil
            }
            
            return gifImageWithData(imageData)
        }
        
        class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
            var delay = 0.1
            
            let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
            let gifProperties: CFDictionary = unsafeBitCast(
                CFDictionaryGetValue(cfProperties,
                                     Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
                to: CFDictionary.self)
            
            var delayObject: AnyObject = unsafeBitCast(
                CFDictionaryGetValue(gifProperties,
                                     Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
                to: AnyObject.self)
            if delayObject.doubleValue == 0 {
                delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                                 Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
            }
            
            delay = delayObject as! Double
            
            if delay < 0.1 {
                delay = 0.1
            }
            
            return delay
        }
        
        class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
            var a = a
            var b = b
            if b == nil || a == nil {
                if b != nil {
                    return b!
                } else if a != nil {
                    return a!
                } else {
                    return 0
                }
            }
            
            if a < b {
                let c = a
                a = b
                b = c
            }
            
            var rest: Int
            while true {
                rest = a! % b!
                
                if rest == 0 {
                    return b!
                } else {
                    a = b
                    b = rest
                }
            }
        }
        
        class func gcdForArray(_ array: Array<Int>) -> Int {
            if array.isEmpty {
                return 1
            }
            
            var gcd = array[0]
            
            for val in array {
                gcd = UIImage.gcdForPair(val, gcd)
            }
            
            return gcd
        }
        
        class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
            let count = CGImageSourceGetCount(source)
            var images = [CGImage]()
            var delays = [Int]()
            
            for i in 0..<count {
                if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(image)
                }
                
                let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                                source: source)
                delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
            }
            
            let duration: Int = {
                var sum = 0
                
                for val: Int in delays {
                    sum += val
                }
                
                return sum
            }()
            
            let gcd = gcdForArray(delays)
            var frames = [UIImage]()
            
            var frame: UIImage
            var frameCount: Int
            for i in 0..<count {
                frame = UIImage(cgImage: images[Int(i)])
                frameCount = Int(delays[Int(i)] / gcd)
                
                for _ in 0..<frameCount {
                    frames.append(frame)
                }
            }
            
            let animation = UIImage.animatedImage(with: frames,
                                                  duration: Double(duration) / 1000.0)
            
            return animation
        }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


