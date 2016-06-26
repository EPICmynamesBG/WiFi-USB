//
//  FadeLabel.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//  
//  Copyright © 2016 Brandon Groff.
//
//  License: GNU GPLv3 (see LICENSE)
//

import UIKit

/// Custom implementation of a Toast type notification
class NotificationLabel: UILabel {
    
    /// How long to show the notification
    private var tempShowingTime: NSTimeInterval? = nil
    /// The timer that controls when to hide the notification
    private var showTimer: NSTimer?
    
    /// Custom hide implementation. Fade in/out and slide up on show
    override var hidden: Bool {
        didSet {
            if (self.hidden) {
                fadeOut()
            } else {
                fadeIn()
            }
        }
    }
    
    /**
     Get the y coordinate of the parent views bottom, 200 (random) if nil
    
     - returns: the parent views height, CGFloat
     */
    private func parentBottom () -> CGFloat{
        if (self.superview?.frame.size.height != nil) {
            return self.superview!.frame.size.height
        }
        
        return 200.0
    }
    
    /**
     Fade out animation
     */
    @objc private func fadeOut() {
        self.alpha = 0.8
        UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseInOut, animations: {
            self.alpha = 0.0
            self.frame.origin.y = self.parentBottom() + self.frame.size.height
        }) { (complete: Bool) in
            if (self.showTimer != nil) {
                self.showTimer!.invalidate()
                self.showTimer = nil
            }
            
            super.hidden = true
        }

    }
    
    /**
     Fade in animation, with slide up from bottom
     */
    private func fadeIn() {
        
        self.alpha = 0.0
        super.hidden = false
        self.frame.origin.y = self.parentBottom() + self.frame.size.height
        UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseInOut, animations: {
            self.alpha = 0.8
            self.frame.origin.y = self.parentBottom() - self.frame.size.height - 20
        }) { (complete: Bool) in
            if (self.tempShowingTime != nil) {
                self.showTimer = NSTimer.scheduledTimerWithTimeInterval(self.tempShowingTime!,
                                                                        target: self,
                                                                        selector: #selector(self.fadeOut),
                                                                        userInfo: nil,
                                                                        repeats: false)
                self.tempShowingTime = nil
            }
            
        }
        
    }
    
    /**
     Show this notification label for time duration
     
     - parameter time: time duration to show the notification
     */
    func showForDuration(time: NSTimeInterval) {
        if (self.showTimer != nil) {
            self.showTimer?.invalidate()
            self.showTimer = nil
        }
        self.tempShowingTime = time
        self.hidden = false
    }
    
    /**
     Override UILabel default to give text extra padding
     
     - parameter rect: CGRect
     */
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    /**
     Override UILabel default to give text extra padding
     
     - returns: CGSize
     */
    override func intrinsicContentSize() -> CGSize {
        var origSize = super.intrinsicContentSize()
        origSize.width = origSize.width + 20
        origSize.height = origSize.height + 10
        return origSize
    }
    
}
