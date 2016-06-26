//
//  WiFiUSBNetworker.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/23/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import Foundation
import UIKit

/**
 *  Delegate for WiFiUSBNetworker
 */
protocol WiFiUSBNetworkerDelegate {
    /**
     Called when a response is recieved from WiFi-UB
     
     - parameter response: JsonResponse object
     */
    func WiFiUSBStatus(response: JsonResponse)
    /**
     Called when an error occurs communicating to WiFi-USB or parsing the response
     
     - parameter error:   optional NSError
     - parameter message: optional error description String
     */
    func WiFiUSBRequestError(error: NSError?, message: String?)
    
    /**
     Called when WiFi-USB is back online after a reboot
     
     - parameter response: JsonResponse object
     */
    func WiFiUSBRebootComplete(statusResponse: JsonResponse)
}

/// Simplified communications with WiFi-USB
class WiFiUSBNetworker {
    
    var delegate: WiFiUSBNetworkerDelegate?
    /// WiFi-USB base endpoint URL
    private let BASE_URL: String = "http://wifiusb.local"
    /// URLSession
    private let session: NSURLSession = NSURLSession.sharedSession()
    /// the current request in progress, if any
    private var currentDataTask: NSURLSessionDataTask?
    /// Check back for when WiFi-USB is back online
    private var postRebootTimer: NSTimer?
    /// Prevent reboot complete from being called by own request callback
    private var RebootIgnoreFirstResponseFlag: Bool = false
    /// Allow all to know if the WiFi-USB device is rebooting
    var rebooting: Bool = false {
        didSet {
            if rebooting {
                self.RebootIgnoreFirstResponseFlag = true
            }
        }
    }
    /// Constant for retry time after device has rebooted
    private static let RebootOnlineCheckTime: NSTimeInterval = 3.0
    
    init () {
        self.currentDataTask = nil
        self.rebooting = false
    }
    
    /**
     Get the WiFi-USB's current USB-A power status
     */
    @objc func getStatus () {
        self.sendRequestToEndpoint("/status", withHTTPMethod: "GET")
    }
    
    /**
     Toggle the WiFi-USB's USB-A power
     */
    func togglePower () {
        self.sendRequestToEndpoint("/toggle", withHTTPMethod: "POST")
    }
    
    /**
     Reboot the WiFi-USB
     */
    func reboot () {
        self.rebooting = true
        self.sendRequestToEndpoint("/reboot", withHTTPMethod: "GET")
        self.postRebootTimer = NSTimer.scheduledTimerWithTimeInterval(WiFiUSBNetworker.RebootOnlineCheckTime,
                                                                      target: self,
                                                                      selector: #selector(self.getStatus),
                                                                      userInfo: nil,
                                                                      repeats: true)
    }
    
    /**
     Simplified method of sending a network request
     
     - parameter endpoint: API url endpoin
     - parameter method:   the HTTP method (GET, POST, etc)
     */
    private func sendRequestToEndpoint (endpoint: String, withHTTPMethod method:String) {
        if (!Reachability.isConnectedToNetwork()) {
            self.delegate?.WiFiUSBRequestError(nil, message: "This device isn't connected to any networks")
            return
        }
        
        let url = NSURL(string: BASE_URL + endpoint)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = method
        let datatask = session.dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            self.requestProcessor(data, response: response, error: error)
        }
        self.startDataTask(datatask)
    }
    
    /**
     Processes the network response data
     
     - parameter data:     recieved NSData
     - parameter response: recieved NSURLResponse
     - parameter error:    recieved NSError
     */
    private func requestProcessor (data: NSData?, response: NSURLResponse?, error: NSError?) {
        if (error != nil) {
            self.throwError(error, withMessage: "Power toggle request error")
            return
        }
        
        let parsedResponse: JsonResponse? = self.dataToJsonResponse(data)
        
        if (parsedResponse == nil) {
            //error has already been thrown
            return
        }
        
        
        self.dataTaskComplete(parsedResponse!)
    }
    
    /**
     Clear the current data task and fire appropriate delegate
     */
    private func dataTaskComplete (response: JsonResponse) {
        self.currentDataTask = nil
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if self.RebootIgnoreFirstResponseFlag {
            self.RebootIgnoreFirstResponseFlag = false
        } else {
            if (self.postRebootTimer != nil) {
                self.postRebootTimer?.invalidate()
                self.postRebootTimer = nil
            }
            if (rebooting) {
                rebooting = false
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.delegate?.WiFiUSBRebootComplete(response)
                })
                return
            }
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.delegate?.WiFiUSBStatus(response)
        })
    }
    
    /**
     Cancels current data task, if any, then starts the new
     */
    private func startDataTask (datatask: NSURLSessionDataTask) {
        if (self.currentDataTask != nil) {
            self.currentDataTask?.cancel()
        }
        self.currentDataTask = datatask
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.currentDataTask?.resume()
    }
    
    /**
     Parse the response data to JsonResponse struct
     
     - parameter data: datatask recieved NSData
     
     - returns: JsonResponse on parse success, nil on fail
     */
    private func dataToJsonResponse (data: NSData?) -> JsonResponse? {
        var resultsDict: NSDictionary?
        
        do {
            resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
        } catch {
            self.throwError(nil, withMessage: "Error parsing JSON response")
        }
        
        if (resultsDict == nil) {
            self.throwError(nil, withMessage: "JSON parsed, but the dictionary is nil")
            return nil
        }
        
        let on: Bool? = resultsDict!["on"] as? Bool
        let raw: Int? = resultsDict!["raw"] as? Int
        let desc: String? = resultsDict!["description"] as? String
        
        return JsonResponse(on: on, raw: raw, description: desc)
    }
    
    /**
     Fire delgate error function on main queue
     
     - parameter error:   optional NSError
     - parameter message: optional message for reciever to show
     */
    private func throwError (error: NSError?, withMessage message:String?) {
        NSOperationQueue.mainQueue().addOperationWithBlock { 
            self.delegate?.WiFiUSBRequestError(error, message: message)
        }
        self.currentDataTask = nil
    }
    
}