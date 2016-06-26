//
//  RadialGradientLayer.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//
//  Copyright © 2016 Brandon Groff.
//
//  License: GNU GPLv3 (see LICENSE)
//

import UIKit

/// easily create a radial gradient from 2 colors
class RadialGradientColor {
    
    /**
     Static function. Creates a radial gradient UIColor from 2 colors and the given frame
     
     - parameter frame:    the frame of the area that the UIColor will be in
     - parameter colorArr: Array of 2 UIColors to blend
     
     - returns: UIColor - the radial gradient of the supplied colors
     */
    static func create(frame: CGRect, withColors colorArr:[UIColor]) -> UIColor {
        let backgroundGradientLayer: CAGradientLayer = CAGradientLayer()
        
        backgroundGradientLayer.frame = frame
        
        var cgColorArr: [CGColor] = Array()
        
        for color: UIColor in colorArr {
            cgColorArr.append(color.CGColor)
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
        
        let locations: [CGFloat] = [0.0, 1.0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let arrayRef: CFArrayRef = cgColorArr
        
        let myGradient = CGGradientCreateWithColors(colorSpace, arrayRef, locations)
        let myCentrePoint = CGPointMake(0.5 * frame.size.width, 0.5 * frame.size.height)
        
        let myRadius = min(frame.size.width, frame.size.height) * 1.0
        CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, myCentrePoint,
                                     0, myCentrePoint, myRadius,
                                     CGGradientDrawingOptions.DrawsAfterEndLocation)
        
        let backgroundColorImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return UIColor.init(patternImage: backgroundColorImage)
        
    }
    
}