//
//  InfoViewController.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//
//  Copyright © 2016 Brandon Groff.
//
//  License: GNU GPLv3 (see LICENSE)
//

import UIKit

class InfoViewController: UIViewController {
    
    /// UIButton for cloosing this view
    @IBOutlet weak var closeButton: UIButton!
    /// The scroll view the info text is contained in
    @IBOutlet weak var scrollView: UIScrollView!
    /// this view's parent. Should be set by the parent's segue fybc
    var parent: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgBlendColor = [ColorPalette.Black, UIColor.darkGrayColor()]
        self.view.backgroundColor = RadialGradientColor.create(self.view.frame, withColors: bgBlendColor).colorWithAlphaComponent(0.75)
    }
    
    /**
     Tap action, tell view's parent to hide it
     
     - parameter sender: the close Button
     */
    @IBAction func closeButtonTap(sender: UIButton) {
        if (parent != nil) {
            parent!.hideContainerView()
        }
    }
    
    /**
     Tap action, opens WiFi-USB's Github in Safari
     
     - parameter sender: the Open in Github button
     */
    @IBAction func openInGithubTap(sender: GlowingButton) {
        let url = NSURL(string: "https://github.com/EPICmynamesBG/WiFi-USB")
        UIApplication.sharedApplication().openURL(url!)
    }
}