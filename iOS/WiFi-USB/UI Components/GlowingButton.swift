//
//  GlowingTextButton.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//
//  Copyright © 2016 Brandon Groff.
//
//  License: GNU GPLv3 (see LICENSE)
//

import UIKit

/// A custom button that allows for a text and image glow, with animation
@IBDesignable
class GlowingButton: UIButton {
    
    /**
     *  Glow defaults
     */
    struct Defaults {
        /// user by NSTimer to fire the grow/shrink animation
        static let AnimateGlowRate: Double = 1/30
        /// enables user interaction during the animation
        static let AnimatedGlowOptions: UIViewAnimationOptions = .AllowUserInteraction
        /// glow grow/shrink radius
        static var AnimatedGlowRange: CGFloat = 3.0
        /// starting radius for the glow
        static let GlowRadius: CGFloat = 3.0
        /// the glows opacity
        static let GlowOpacity: Float = 0.9
    }
    
    /**
     Simple enum for differentiating the glows current direction
     
     - Growing:   the glow is expanding
     - Shrinking: the glow is shrinking
     */
    enum AnimationDirection {
        case Growing
        case Shrinking
    }
    
    /// current glow radius
    private var glowRadius: CGFloat = Defaults.GlowRadius {
        didSet {
            self.titleLabel?.layer.shadowRadius = self.glowRadius
            self.imageView?.layer.shadowRadius = self.glowRadius
            self.setNeedsDisplay()
        }
    }
    /// the original glow radius, used to calc min/max
    private var originalGlowRadius: CGFloat? = Defaults.GlowRadius
    /// the glows smalleset size
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
    /// the glows largest size
    private var maxGlowRadius: CGFloat {
        get {
            if (self.originalGlowRadius == nil) {
                return 0
            }
            return self.originalGlowRadius! + Defaults.AnimatedGlowRange
        }
    }
    
    /// timer that triggers the glow resize functino
    private var animatedGlowTimer: NSTimer?
    /// the current direction the glow is going
    private var animatedGlowDirection: AnimationDirection = .Growing
    
    /// The color of the text's glow
    @IBInspectable var textGlow: UIColor? {
        didSet {
            self.titleLabel?.layer.shadowColor = textGlow?.CGColor
            self.titleLabel?.layer.shadowRadius = self.glowRadius
            self.titleLabel?.layer.shadowOpacity = Defaults.GlowOpacity
            self.titleLabel?.layer.shadowOffset = CGSizeZero
            self.titleLabel?.layer.masksToBounds = false
        }
    }
    
    /// the color of the image/icon's glow
    @IBInspectable var imageGlow: UIColor? {
        didSet {
            self.imageView?.layer.shadowColor = imageGlow?.CGColor
            self.imageView?.layer.shadowRadius = self.glowRadius
            self.imageView?.layer.shadowOffset = CGSizeZero
            self.imageView?.layer.shadowOpacity = Defaults.GlowOpacity
            self.imageView?.layer.masksToBounds = false
        }
    }
    
    /// static or animated glow?
    @IBInspectable var animatedGlow: Bool = false {
        didSet {
            if (animatedGlow) {
                self.animateGlow()
            }
        }
    }
    
    /**
     start the time that calls the glow animmation function
     */
    func animateGlow () {
        self.animatedGlowTimer = NSTimer.scheduledTimerWithTimeInterval(Defaults.AnimateGlowRate + 0.001,
                                                                        target: self,
                                                                        selector: #selector(self.animation),
                                                                        userInfo: nil,
                                                                        repeats: true)
    }
    
    /**
     the glow animation, dynamically changes the glow size as called by the timer
     */
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