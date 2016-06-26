//
//  HyperlinkLabel.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//
//  Copyright © 2016 Brandon Groff.
//
//  License: GNU GPLv3 (see LICENSE)
//

import UIKit

/// a clickable label that opens a link
@IBDesignable
class HyperlinkLabel: UILabel {

    /// a URL
    @IBInspectable var link: String?
    
    /**
     Parent override, used to initialize the tap gesture
     
     - parameter frame: CGRect
     
     - returns: self
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeTapGesture()
    }
    
    /**
     Parent override, required, used to initialize the tap gesture
     
     - parameter aDecoder: NSCode
     
     - returns: self
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeTapGesture()
    }
    
    /**
     Set up the tap gesture
     
     - returns: nothing
     */
    private func initializeTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.openLinkInSafari))
        self.addGestureRecognizer(tapGesture)
    }
    
    /**
     Open this label's link in Safari
     */
    func openLinkInSafari() {
        if link != nil {
            let url = NSURL(string: link!)
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
}
