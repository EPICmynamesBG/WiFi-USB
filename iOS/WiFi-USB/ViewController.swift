//
//  ViewController.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/23/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, WiFiUSBNetworkerDelegate {

    /// Used to control backgrond color change timing
    private var backgroundTimer: NSTimer?
    /// The background time duration
    private let fadeTime: NSTimeInterval = 3.0
    /// Current index in array of background colors
    private var currentColorIndex: Int = 0
    /// Retain last response from WiFi-USB request
    private var lastResponse: JsonResponse?
    
    private var networker: WiFiUSBNetworker?
    @IBOutlet weak var togglePowerButton: GlowingButton!
    @IBOutlet weak var rebootButton: GlowingButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var infoViewContainer: UIView!
    @IBOutlet weak var notificationLabel: NotificationLabel!
    @IBOutlet weak var statusButton: GlowingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networker = WiFiUSBNetworker()
        self.networker?.delegate = self
        self.disableButtons()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundTimer = NSTimer.scheduledTimerWithTimeInterval(fadeTime + 0.001,
                                                                      target: self,
                                                                      selector: #selector(ViewController.animateBackground),
                                                                      userInfo: nil,
                                                                      repeats: true)
        self.sendStatusSignal()

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.backgroundTimer?.invalidate()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func statusRefresh(sender: UIButton) {
        self.sendStatusSignal()
    }
    
    @IBAction func togglePowerButtonTap(sender: GlowingButton) {
        self.sendToggleSignal()
    }
    
    @IBAction func rebootButtonTap(sender: GlowingButton) {
        self.sendRebootSignal()
    }
    
    @IBAction func infoButtonTap(sender: AnyObject) {
        self.showContainerView()
    }
    
    func showContainerView () {
        self.infoViewContainer.alpha = 0.0
        self.infoViewContainer.hidden = false
        UIView.animateWithDuration(0.5, animations: {
            self.infoViewContainer.alpha = 1.0
            self.infoButton.alpha = 0.0
        }) { (complete: Bool) in
            self.infoButton.hidden = true
        }
    }
    
    func hideContainerView () {
        self.infoViewContainer.alpha = 1.0
        self.infoButton.hidden = false
        UIView.animateWithDuration(0.5, animations: { 
            self.infoViewContainer.alpha = 0.0
            self.infoButton.alpha = 1.0
        }) { (complete: Bool) in
            self.infoViewContainer.hidden = true
        }
    }

    /**
     Animate the change of the view's background color
     
     - parameter timer: sent by scheduled NSTimer with repeat
     */
    @objc private func animateBackground(timer: NSTimer) {
        UIView.animateWithDuration(fadeTime, delay: 0, options: .AllowUserInteraction, animations: {
            self.view.backgroundColor = ColorPalette.Rainbow.Faded.Array[self.currentColorIndex]
        }) { (complete: Bool) in
            self.currentColorIndex = (self.currentColorIndex + 1) % ColorPalette.Rainbow.Faded.Array.count
        }
    }
    
    private func sendStatusSignal() {
        self.networker?.getStatus()
        self.disableButtons()
    }
    
    private func sendRebootSignal() {
        self.networker?.reboot()
        self.disableButtons()
    }
    
    private func sendToggleSignal() {
        self.networker?.togglePower()
        self.disableButtons()
    }
    
    private func disableButtons() {
        self.togglePowerButton.enabled = false
        self.togglePowerButton.tintColor = UIColor.darkGrayColor()
        self.rebootButton.enabled = false
        self.rebootButton.tintColor = UIColor.darkGrayColor()
        self.statusButton.enabled = false
    }
    
    private func enableButtons() {
        if ( lastResponse != nil) {
            if lastResponse?.on != nil {
                if (lastResponse!.on!){
                    self.togglePowerButton.tintColor = ColorPalette.SecondaryA.Lightest
                    self.togglePowerButton.imageGlow = ColorPalette.Black
                } else {
                    self.togglePowerButton.tintColor = ColorPalette.Red
                    self.togglePowerButton.imageGlow = ColorPalette.White
                }
            }
        }
        self.togglePowerButton.enabled = true
        self.rebootButton.enabled = true
        self.rebootButton.tintColor = ColorPalette.Primary.Normal
        self.statusButton.enabled = true
        
    }
    
    func showNotification(message: String) {
        self.notificationLabel.text = message
        self.notificationLabel.showForDuration(4.0)
    }
    
    /* ----- WiFiUSBNetworkerDelegate Functions ----- */
    
    func WiFiUSBStatus(response: JsonResponse) {
        self.lastResponse = response
        if (self.networker!.rebooting) {
            self.lastResponse = nil
            self.notificationLabel.text = "Rebooting. Device is OFFLINE"
            self.notificationLabel.hidden = false
        } else {
            self.showNotification(response.description!)
            self.enableButtons()
        }
        
    }
    
    func WiFiUSBRequestError(error: NSError?, message: String?) {
        if (!self.networker!.rebooting) {
            self.showNotification(message!)
        }
        self.statusButton.enabled = true
    }
    
    func WiFiUSBRebootComplete(statusResponse: JsonResponse) {
        self.lastResponse = statusResponse
        self.notificationLabel.text = "Reboot complete. Device is ONLINE"
        self.notificationLabel.showForDuration(3.0)
        self.enableButtons()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "infoEmbed") {
            let infoEmbeddedView = segue.destinationViewController as! InfoViewController
            infoEmbeddedView.parent = self
        }
    }
}

