//
//  PowerButton.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/25/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import UIKit

@IBDesignable
class PowerButton: UIButton {
    
    @IBInspectable var radialGradientColor: UIColor? {
        didSet {
            if (self.radialGradientColor != nil && self.backgroundColor != nil) {
                let gradientColors = [self.radialGradientColor!, self.backgroundColor!]
                self.backgroundColor = RadialGradientColor.create(self.frame, withColors: gradientColors)
            }
            self.setNeedsDisplay()
        }
    }
}