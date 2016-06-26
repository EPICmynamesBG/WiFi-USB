//
//  FadeLabel.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import UIKit

class FadeLabel: UILabel {
    
    private var tempShowingTime: NSTimeInterval? = nil
    private var showTimer: NSTimer?
    
    override var hidden: Bool {
        didSet {
            if (self.hidden) {
                fadeOut()
            } else {
                fadeIn()
            }
        }
    }
    
    @objc private func fadeOut() {
        UIView.animateWithDuration(0.75, animations: { 
            self.alpha = 0.0
        }) { (complete: Bool) in
            if (self.showTimer != nil) {
                self.showTimer!.invalidate()
                self.showTimer = nil
            }
            super.hidden = true
        }
    }
    
    private func fadeIn() {
        super.hidden = false
        UIView.animateWithDuration(0.75, animations: { 
            self.alpha = 1.0
        }) { (complete:Bool) in
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
