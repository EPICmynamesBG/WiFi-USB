//
//  ViewController.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/23/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WiFiUSBNetworkerDelegate {

    /// Used to control backgrond color change timing
    private var backgroundTimer: NSTimer?
    /// The background time duration
    private let fadeTime: NSTimeInterval = 3.0
    /// Current index in array of background colors
    private var currentColorIndex: Int = 0
    
    private var networker: WiFiUSBNetworker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networker = WiFiUSBNetworker()
        self.networker?.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundTimer = NSTimer.scheduledTimerWithTimeInterval(fadeTime + 0.001,
                                                                      target: self,
                                                                      selector: #selector(ViewController.animateBackground),
                                                                      userInfo: nil,
                                                                      repeats: true)
        self.networker?.getStatus()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.backgroundTimer?.invalidate()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Animate the change of the view's background color
     
     - parameter timer: sent by scheduled NSTimer with repeat
     */
    @objc private func animateBackground(timer: NSTimer) {
        UIView.animateWithDuration(fadeTime, animations: {
            self.view.backgroundColor = ColorPalette.BackgroundColorArray[self.currentColorIndex]
        }) { (complete: Bool) in
            self.currentColorIndex = (self.currentColorIndex + 1) % ColorPalette.BackgroundColorArray.count
        }
    }
    
    /* ----- WiFiUSBNetworkerDelegate Functions ----- */
    
    func WiFiUSBStatus(response: JsonResponse) {
        print(response)
    }
    
    func WiFiUSBRequestError(error: NSError?, message: String?) {
        print(message)
    }

}

