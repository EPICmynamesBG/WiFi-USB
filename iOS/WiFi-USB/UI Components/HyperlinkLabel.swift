//
//  HyperlinkLabel.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/25/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import UIKit

@IBDesignable
class HyperlinkLabel: UILabel {

    
    @IBInspectable var link: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeTapGesture()
    }
    
    private func initializeTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.openLinkInSafari))
        self.addGestureRecognizer(tapGesture)
    }
    
    func openLinkInSafari() {
        if link != nil {
            let url = NSURL(string: link!)
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
}
