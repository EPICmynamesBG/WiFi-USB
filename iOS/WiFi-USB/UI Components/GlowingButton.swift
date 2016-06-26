//
//  GlowingTextButton.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/25/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import UIKit

@IBDesignable
class GlowingButton: UIButton {
    
    struct Defaults {
        static let AnimateGlowRate: Double = 1/30
        static let AnimatedGlowOptions: UIViewAnimationOptions = .AllowUserInteraction
        static var AnimatedGlowRange: CGFloat = 3.0
        static let GlowRadius: CGFloat = 3.0
        static let GlowOpacity: Float = 0.9
    }
    
    enum AnimationDirection {
        case Growing
        case Shrinking
    }

    private var glowRadius: CGFloat = Defaults.GlowRadius {
        didSet {
            self.titleLabel?.layer.shadowRadius = self.glowRadius
            self.imageView?.layer.shadowRadius = self.glowRadius
            self.setNeedsDisplay()
        }
    }
    private var originalGlowRadius: CGFloat? = Defaults.GlowRadius
    private var minGlowRadius: CGFloat {
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
    private var maxGlowRadius: CGFloat {
        get {
            if (self.originalGlowRadius == nil) {
                return 0
            }
            return self.originalGlowRadius! + Defaults.AnimatedGlowRange
        }
    }
    
    private var animatedGlowTimer: NSTimer?
    private var animatedGlowDirection: AnimationDirection = .Growing
    
    @IBInspectable var textGlow: UIColor? {
        didSet {
            self.titleLabel?.layer.shadowColor = textGlow?.CGColor
            self.titleLabel?.layer.shadowRadius = self.glowRadius
            self.titleLabel?.layer.shadowOpacity = Defaults.GlowOpacity
            self.titleLabel?.layer.shadowOffset = CGSizeZero
            self.titleLabel?.layer.masksToBounds = false
        }
    }
    
    @IBInspectable var imageGlow: UIColor? {
        didSet {
            self.imageView?.layer.shadowColor = imageGlow?.CGColor
            self.imageView?.layer.shadowRadius = self.glowRadius
            self.imageView?.layer.shadowOffset = CGSizeZero
            self.imageView?.layer.shadowOpacity = Defaults.GlowOpacity
            self.imageView?.layer.masksToBounds = false
        }
    }
    
    @IBInspectable var animatedGlow: Bool = false {
        didSet {
            if (animatedGlow) {
                self.animateGlow()
            }
        }
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
            if (self.glowRadius >= self.maxGlowRadius ||
                self.animatedGlowDirection == .Shrinking) {
                self.glowRadius -= 0.1
            } else if (self.animatedGlowDirection == .Growing) {
                self.glowRadius += 0.1
            } else {
                self.glowRadius += 0.1
            }
            
            if (self.glowRadius > self.maxGlowRadius) {
                self.animatedGlowDirection = .Shrinking
            } else if (self.glowRadius < self.minGlowRadius) {
                self.animatedGlowDirection = .Growing
            }
        }) { (completed:Bool) in
            //nothing
        }
    }
}