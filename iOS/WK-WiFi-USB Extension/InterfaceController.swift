//
//  InterfaceController.swift
//  WK-WiFi-USB Extension
//
//  Created by Brandon Groff on 7/6/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, WiFiUSBNetworkerDelegate {

    @IBOutlet var togglePowerButton: WKInterfaceButton!
    @IBOutlet var powerButtonImage: WKInterfaceImage!
    @IBOutlet var loadingIndicator: WKInterfaceImage!
    
    private var networker: WiFiUSBNetworker = WiFiUSBNetworker()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.networker = WiFiUSBNetworker()
        self.networker.delegate = self
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didAppear() {
        self.networker.getStatus()
        self.disableButton()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func togglePowerTap() {
        self.disableButton()
        self.networker.togglePower()
    }
    
    @IBAction func updateStatusTap() {
        self.disableButton()
        self.networker.getStatus()
    }
    
    private func enableButton(response: JsonResponse?) {
        self.stopLoading()
        self.togglePowerButton.setEnabled(true)        
        self.togglePowerButton.setHidden(false)
        animateWithDuration(0.3) {
            self.togglePowerButton.setAlpha(1.0)
            if (response != nil) {
                if (response!.on!) {
                    self.powerButtonImage.setTintColor(ColorPalette.SecondaryA.Lightest)
                } else {
                    self.powerButtonImage.setTintColor(ColorPalette.Red)
                }
            }
        }
        
    }
    
    private func disableButton() {
        self.togglePowerButton.setEnabled(false)
        animateWithDuration(0.1) {
            self.powerButtonImage.setTintColor(UIColor.grayColor())
        }
        animateWithDuration(0.3) {
            self.togglePowerButton.setAlpha(0.0)
        }
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(self.disableButtonEndAnimation), userInfo: nil, repeats: false)
    }
    
    @objc func disableButtonEndAnimation() {
        self.togglePowerButton.setHidden(true)
        self.showLoading()
    }
    
    private func showLoading() {
        self.loadingIndicator.setImageNamed("Activity")
        self.loadingIndicator.startAnimatingWithImagesInRange(NSMakeRange(0, 15), duration: 1.0, repeatCount: 0)
        self.loadingIndicator.setHidden(false)
    }
    
    private func stopLoading() {
        self.loadingIndicator.setHidden(true)
        self.loadingIndicator.stopAnimating()
    }
    
    func WiFiUSBStatus(response: JsonResponse) {
        self.enableButton(response)
        
    }
    
    func WiFiUSBRequestError(error: NSError?, message: String?) {
        self.enableButton(nil)
        print("ERROR")
    }
    
    func WiFiUSBRebootComplete(statusResponse: JsonResponse) {
        self.enableButton(statusResponse)
        print("Reboot")
    }

}
