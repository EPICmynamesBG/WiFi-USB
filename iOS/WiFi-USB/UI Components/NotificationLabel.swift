//
//  FadeLabel.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import UIKit

class NotificationLabel: UILabel {
    
    private var tempShowingTime: NSTimeInterval? = nil
    private var showTimer: NSTimer?
    private var showing: Bool = false
    
    override var hidden: Bool {
        didSet {
            if (self.hidden) {
                fadeOut()
            } else {
                fadeIn()
            }
        }
    }
    
    private func parentBottom () -> CGFloat{
        if (self.superview?.frame.size.height != nil) {
            return self.superview!.frame.size.height
        }
        
        return 200.0
    }
    
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
    
    func showForDuration(time: NSTimeInterval) {
        if (self.showTimer != nil) {
            self.showTimer?.invalidate()
            self.showTimer = nil
        }
        self.tempShowingTime = time
        self.hidden = false
    }
    
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func intrinsicContentSize() -> CGSize {
        var origSize = super.intrinsicContentSize()
        origSize.width = origSize.width + 20
        origSize.height = origSize.height + 10
        return origSize
    }
    
}
