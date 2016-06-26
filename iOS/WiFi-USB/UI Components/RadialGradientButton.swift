//
//  PowerButton.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//
//  Copyright © 2016 Brandon Groff.
//
//  License: GNU GPLv3 (see LICENSE)
//

import UIKit

/// a custom button that allows for a radial gradient background
@IBDesignable
class RadialGradientButton: UIButton {
    
    /// the inner color to blend to
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