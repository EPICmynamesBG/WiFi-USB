//
//  ViewController.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//
//  Copyright © 2016 Brandon Groff.
//
//  License: GNU GPLv3 (see LICENSE)
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
    /// object for sending async network requests and being notified on completion
    private var networker: WiFiUSBNetworker?
    
    /// The UI Button that toggles WiFi-USB's power
    @IBOutlet weak var togglePowerButton: GlowingButton!
    /// The UI Button that reboots WiFi-USB
    @IBOutlet weak var rebootButton: GlowingButton!
    /// button for displaying the info overlay
    @IBOutlet weak var infoButton: UIButton!
    /// container the contains the Info View
    @IBOutlet weak var infoViewContainer: UIView!
    /// the UI Notification label
    @IBOutlet weak var notificationLabel: NotificationLabel!
    /// the UI Button for user refreshing WiFi-USB's status
    @IBOutlet weak var statusButton: GlowingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networker = WiFiUSBNetworker()
        self.networker?.delegate = self
        self.disableButtons()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onAppMinimize), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onAppResume), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.onAppResume()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.onAppMinimize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Stop animations, clear the timers
     */
    @objc private func onAppMinimize() {
        self.backgroundTimer?.invalidate()
        self.backgroundTimer = nil
    }
    
    /**
     restart animations, update the WiFi-USB status
     */
    @objc private func onAppResume() {
        if (self.backgroundTimer == nil) {
            self.backgroundTimer = NSTimer.scheduledTimerWithTimeInterval(fadeTime + 0.001,
                                                                          target: self,
                                                                          selector: #selector(ViewController.animateBackground),
                                                                          userInfo: nil,
                                                                          repeats: true)
        }
        self.sendStatusSignal()
    }
    
    /**
     Tap triggered func, calls for a status update
     
     - parameter sender: the status refresh button
     */
    @IBAction func statusRefresh(sender: UIButton) {
        self.sendStatusSignal()
    }
    
    /**
     Tap triggered func, calls for the power to toggle
     
     - parameter sender: the power button
     */
    @IBAction func togglePowerButtonTap(sender: GlowingButton) {
        self.sendToggleSignal()
    }
    
    /**
     Tap friggered func, calls for WiFi-USB to reboot
     
     - parameter sender: the reboot button
     */
    @IBAction func rebootButtonTap(sender: GlowingButton) {
        self.sendRebootSignal()
    }
    
    /**
     Tap triggered action, calls to show the Info overlay
     
     - parameter sender: info button
     */
    @IBAction func infoButtonTap(sender: AnyObject) {
        self.showContainerView()
    }
    
    /**
     Show the Info Overlay with Fade in animation
     */
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
    
    /**
     Hide the Info Overlay with Fade out animation
     */
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
    
    /**
     Update WiFi-USB status, disable some buttons while requesting
     */
    private func sendStatusSignal() {
        self.networker?.getStatus()
        self.disableButtons()
    }
    
    /**
     Reboot WiFi-USB, disable some buttons while requesting
     */
    private func sendRebootSignal() {
        self.networker?.reboot()
        self.disableButtons()
    }
    
    /**
     Toggle WiFi-USB's port power, disable some buttons while requesting
     */
    private func sendToggleSignal() {
        self.networker?.togglePower()
        self.disableButtons()
    }
    
    /**
     Disable's UIButton's that can trigger a network request
     */
    private func disableButtons() {
        self.togglePowerButton.enabled = false
        self.togglePowerButton.tintColor = UIColor.darkGrayColor()
        self.rebootButton.enabled = false
        self.rebootButton.tintColor = UIColor.darkGrayColor()
        self.statusButton.enabled = false
    }
    
    /**
     Enable UIButtons that may have been disabled, updating color based on WiFi-USB status
     */
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
    
    /**
     Display the notification label with a message
     
     - parameter message: the message to show in the notification
     */
    func showNotification(message: String) {
        self.notificationLabel.text = message
        self.notificationLabel.showForDuration(4.0)
    }
    
    /* ----- WiFiUSBNetworkerDelegate Functions ----- */
    
    /**
     Called by WiFiUSBNetworker when a response is recieved
     
     - parameter response: JsonResponse from WiFi-USB
     */
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
    
    /**
     Called by WiFiUSBNetworker when a network error occurs
     
     - parameter error:   the error
     - parameter message: the error message
     */
    func WiFiUSBRequestError(error: NSError?, message: String?) {
        if (!self.networker!.rebooting) {
            self.showNotification(message!)
        }
        self.statusButton.enabled = true
    }
    
    /**
     Called by WiFiUSBNetworker when the device reboot is complete
     
     - parameter statusResponse: last /status JsonResponse from WiFi-USB
     */
    func WiFiUSBRebootComplete(statusResponse: JsonResponse) {
        self.lastResponse = statusResponse
        self.notificationLabel.text = "Reboot complete. Device is ONLINE"
        self.notificationLabel.showForDuration(3.0)
        self.enableButtons()
    }
    
    /**
     Override parent, used to tell the embedded InfoView that this view is its parent
     
     - parameter segue:  UIStoryboardSegue
     - parameter sender: AnyObject?
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "infoEmbed") {
            let infoEmbeddedView = segue.destinationViewController as! InfoViewController
            infoEmbeddedView.parent = self
        }
    }
}

