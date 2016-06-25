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
    
    struct Defaults {
        static let BorderRadius: Int = 0
        static let BorderWidth: Int = 0
        static let BorderColor: UIColor = UIColor.clearColor()
        static let RadialGradientColor: UIColor? = nil
        static let AnimateGlowRate: Double = 1/30
        static let AnimatedGlowOptions: UIViewAnimationOptions = .AllowUserInteraction
        static let AnimatedGlowRange: Float = 2.0
    }
    
    enum AnimationDirection {
        case Growing
        case Shrinking
    }
    
    private var _borderRadius: Int = Defaults.BorderRadius
    private var _borderWidth: Int = Defaults.BorderWidth
    private var _borderColor: UIColor? = Defaults.BorderColor
    private var _glowRadius: Float = 4.0
    private var _radialGradientColor: UIColor? = Defaults.RadialGradientColor
    
    private var originalGlowRadius: Float? = nil
    private var minGlow: Float {
        get {
            if (self.originalGlowRadius == nil) {
                return 0
            }
            var value = self.originalGlowRadius! - Defaults.AnimatedGlowRange
            if (value < 1 ){
                value = 1
            }
            return value
        }
    }
    
    private var maxGlow: Float {
        get {
            if (self.originalGlowRadius == nil) {
                return 0
            }
            return self.originalGlowRadius! + Defaults.AnimatedGlowRange
        }
    }
    
    
    private var animatedGlowTimer: NSTimer?
    private var animatedGlowDirection: AnimationDirection = .Growing
    
    @IBInspectable var borderRadius: Int {
        get {
            return self._borderRadius
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
            self._borderRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: Int {
        get {
            return self._borderWidth
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
            self._borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return self._borderColor
        }
        set {
            self.layer.borderColor = newValue?.CGColor
            self._borderColor = newValue
        }
    }
    
    @IBInspectable var glow: UIColor? {
        didSet {
            self.imageView?.layer.shadowColor = glow?.CGColor
            self.imageView?.layer.shadowRadius = CGFloat(self.glowRadius)
            self.imageView?.layer.shadowOffset = CGSizeZero
            self.imageView?.layer.shadowOpacity = 0.9
            self.imageView?.layer.masksToBounds = false
            self.update()
        }
    }
    
    @IBInspectable var glowRadius: Float {
        get {
            return self._glowRadius
        }
        set {
            self._glowRadius = newValue
            self.imageView?.layer.shadowRadius = CGFloat(newValue)
            self.update()
        }
    }
    
    @IBInspectable var radialGradientColor: UIColor? {
        get {
            return self._radialGradientColor
        }
        set {
            self._radialGradientColor = newValue
            self.update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.originalGlowRadius = self.glowRadius
        self.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.originalGlowRadius = self.glowRadius
        self.update()
    }
 
    private func update() {
        if (self.radialGradientColor != nil && self.backgroundColor != nil) {
            let gradientColors = [self.radialGradientColor!, self.backgroundColor!]
            self.backgroundColor = RadialGradientColor.create(self.frame, withColors: gradientColors)
        }
        self.imageView?.image = self.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate)
        self.imageView?.tintColor = self.tintColor
        self.setNeedsDisplay()
        
    }
    
    func animateGlow () {
        self.animatedGlowTimer = NSTimer.scheduledTimerWithTimeInterval(Defaults.AnimateGlowRate + 0.001,
                                                                        target: self,
                                                                        selector: #selector(self.animation),
                                                                        userInfo: nil,
                                                                        repeats: true)
    }
    
    
    @objc private func animation() {
        UIView.animateWithDuration(Defaults.AnimateGlowRate, delay: 0.0, options: Defaults.AnimatedGlowOptions, animations: {
            if (self.glowRadius >= self.maxGlow ||
                self.animatedGlowDirection == .Shrinking) {
                self.glowRadius -= 0.1
            } else if (self.animatedGlowDirection == .Growing) {
                self.glowRadius += 0.1
            } else {
                self.glowRadius += 0.1
            }
            
            if (self.glowRadius > self.maxGlow) {
                self.animatedGlowDirection = .Shrinking
            } else if (self.glowRadius < self.minGlow) {
                self.animatedGlowDirection = .Growing
            }
        }) { (completed:Bool) in
            //nothing
        }
    }
}