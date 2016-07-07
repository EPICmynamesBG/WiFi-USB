//
//  GlanceController.swift
//  WK-WiFi-USB Extension
//
//  Created by Brandon Groff on 7/6/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController, WiFiUSBNetworkerDelegate {

    
    @IBOutlet var subLabelText: WKInterfaceLabel!
    @IBOutlet var powerButtonImage: WKInterfaceImage!
    
    private var networker: WiFiUSBNetworker = WiFiUSBNetworker()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.networker = WiFiUSBNetworker()
        self.networker.delegate = self
        self.networker.getStatus()
        self.showLoading()
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func showLoading() {
        self.subLabelText.setText("Loading...")
        self.subLabelText.setTextColor(ColorPalette.Primary.Lightest)
        self.powerButtonImage.setAlpha(0.5)
    }
    
    private func stopLoading(response: JsonResponse?) {
        if (response != nil) {
            if (response!.on!){
                self.subLabelText.setText("On")
                self.subLabelText.setTextColor(ColorPalette.SecondaryA.Lightest)
                self.powerButtonImage.setTintColor(ColorPalette.SecondaryA.Lightest)
            } else {
                self.subLabelText.setText("Off")
                self.subLabelText.setTextColor(ColorPalette.Red)
                self.powerButtonImage.setTintColor(ColorPalette.Red)
            }
        } else {
            self.subLabelText.setText("Unknown")
            self.subLabelText.setTextColor(ColorPalette.White)
            self.powerButtonImage.setTintColor(ColorPalette.Complementary.Normal)
        }
        self.powerButtonImage.setAlpha(1.0)
    }
    
    func WiFiUSBStatus(response: JsonResponse) {
        self.stopLoading(response)
        
    }
    
    func WiFiUSBRequestError(error: NSError?, message: String?) {
        self.stopLoading(nil)
    }
    
    func WiFiUSBRebootComplete(statusResponse: JsonResponse) {
        self.stopLoading(statusResponse)
    }
}
