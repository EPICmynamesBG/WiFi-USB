//
//  ColorPalette.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//
//  Copyright © 2016 Brandon Groff.
//
//  License: GNU GPLv3 (see LICENSE)
//
//  Color Palette by Paletton.com
//  Palette URL: http://paletton.com/#uid=61S0u0kEDuWniE+u3DHG+oOL9jc

import UIKit

/**
 *  WiFi-USB Color Palette
 */
struct ColorPalette {
    
    struct Primary {
        static let Lightest: UIColor = UIColor(red: 246, green: 245, blue: 0, alpha: 1.0) // #F6F500
        static let Light: UIColor = UIColor(red: 255, green: 254, blue: 69, alpha: 1.0) // #FFFE45
        static let Normal: UIColor = UIColor(red: 255, green: 253, blue: 16, alpha: 1.0) // #FFFD10
        static let Dark: UIColor = UIColor(red: 198, green: 196, blue: 0, alpha: 1.0) // #C6C400
        static let Darkest: UIColor = UIColor(red: 153, green: 152, blue: 0, alpha: 1.0) // #999800
    }
    
    struct SecondaryA {
        static let Lightest: UIColor = UIColor(red: 156, green: 231, blue: 0, alpha: 1.0) // #9CE700
        static let Light: UIColor = UIColor(red: 187, green: 244, blue: 66, alpha: 1.0) // #BBF442
        static let Normal: UIColor = UIColor(red: 170, green: 243, blue: 15, alpha: 1.0) // #AAF30F
        static let Dark: UIColor = UIColor(red: 125, green: 185, blue: 0, alpha: 1.0) // #7DB900
        static let Darkest: UIColor = UIColor(red: 97, green: 143, blue: 0, alpha: 1.0) // #618F00
    }
    
    struct SecondaryB {
        static let Lightest: UIColor = UIColor(red: 246, green: 203, blue: 0, alpha: 1.0) // #F6CB00
        static let Light: UIColor = UIColor(red: 255, green: 222, blue: 69, alpha: 1.0) // #FFDE45
        static let Normal: UIColor = UIColor(red: 255, green: 213, blue: 16, alpha: 1.0) // #FFD510
        static let Dark: UIColor = UIColor(red: 198, green: 163, blue: 0, alpha: 1.0) // #C6A300
        static let Darkest: UIColor = UIColor(red: 153, green: 126, blue: 0, alpha: 1.0) // #997E00
    }
    
    struct Complementary {
        static let Lightest: UIColor = UIColor(red: 106, green: 6, blue: 165, alpha: 1.0) // #6A06A5
        static let Light: UIColor = UIColor(red: 147, green: 62, blue: 197, alpha: 1.0) // #933EC5
        static let Normal: UIColor = UIColor(red: 130, green: 22, blue: 193, alpha: 1.0) // #8216C1
        static let Dark: UIColor = UIColor(red: 85, green: 5, blue: 132, alpha: 1.0) // #550584
        static let Darkest: UIColor = UIColor(red: 65, green: 3, blue: 102, alpha: 1.0) // #410366
    }
    
    static let Black: UIColor = UIColor(red: 22, green: 24, blue: 25, alpha: 1.0) // #161819
    static let White: UIColor = UIColor(red: 238, green: 238, blue: 238, alpha: 1.0) // #EEEEEE
    static let Red: UIColor = UIColor(red: 255, green: 53, blue: 48, alpha: 1.0) // #FF3530
    
    static let BackgroundColorArray: [UIColor] = [
        Primary.Light,
        SecondaryA.Light,
        SecondaryB.Light
    ]
    
    struct Rainbow {
        struct Faded {
            static let WhiteBlue: UIColor = UIColor(hex: "EAFFFF")
            static let Blue: UIColor = UIColor(hex: "94FFFF")
            static let DeepBlue: UIColor = UIColor(hex: "0794FF")
            static let Magenta: UIColor = UIColor(hex: "E188FF")
            static let Purple: UIColor = UIColor(hex: "AA88FF")
            static let Red: UIColor = UIColor(hex: "FE1C4D")
            static let SeafoamGreen: UIColor = UIColor(hex: "5ADFA5")
            static let Green: UIColor = UIColor(hex: "0ADE0D")
            static let YellowGreen: UIColor = UIColor(hex: "84F11C")
            static let Cyan: UIColor = UIColor(hex: "35FFEE")
            
            /// array used for background animation
            static let Array: [UIColor] = [
                Faded.Green,
                Faded.WhiteBlue,
                Faded.Blue,
                Faded.DeepBlue,
                Faded.Magenta,
                Faded.Red,
                Faded.WhiteBlue,
                Faded.DeepBlue,
                Faded.Purple,
                Faded.WhiteBlue,
                Faded.Cyan,
                Faded.SeafoamGreen,
                Faded.YellowGreen
            ]
        }
        
        
    }
}

private extension UIColor {
    
    /**
     Create a color using CSS RGBA (values 0 - 255)
     
     - parameter red:   0 - 255
     - parameter green: 0 - 255
     - parameter blue:  0 - 255
     - parameter alpha: 0.0 - 1.0
     
     - returns: UIColor
     */
    convenience init(red: Int, green: Int, blue: Int, alpha: Double) {
        self.init(red: CGFloat(Double(red) / 255.0),
                  green: CGFloat(Double(green) / 255.0),
                  blue: CGFloat(Double(blue) / 255.0),
                  alpha: CGFloat(alpha))
    }
    
    /**
     Create a color using CSS HEX code
     
     - parameter hex: 3 or 6 char color hex code
     
     - returns: UIColor, Black if error
     */
    convenience init(hex: String) { // "001122" OR "#FFddFF"
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            self.init(red: 0,
                      green: 0,
                      blue: 0,
                      alpha: 1.0)
            return
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}