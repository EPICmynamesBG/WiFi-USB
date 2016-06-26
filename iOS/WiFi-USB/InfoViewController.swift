//
//  InfoViewController.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/25/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var parent: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgBlendColor = [ColorPalette.Black, UIColor.darkGrayColor()]
        self.view.backgroundColor = RadialGradientColor.create(self.view.frame, withColors: bgBlendColor).colorWithAlphaComponent(0.75)
    }
    
    @IBAction func closeButtonTap(sender: UIButton) {
        if (parent != nil) {
            parent!.hideContainerView()
        }
    }
    
    @IBAction func openInGithubTap(sender: GlowingButton) {
        let url = NSURL(string: "https://github.com/EPICmynamesBG/WiFi-USB")
        UIApplication.sharedApplication().openURL(url!)
    }
}