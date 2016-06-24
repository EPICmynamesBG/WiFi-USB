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
    
    init () {
        self.currentDataTask = nil
    }
    
    /**
     Get the WiFi-USB's current USB-A power status
     */
    func getStatus () {
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
        self.sendRequestToEndpoint("/reboot", withHTTPMethod: "GET")
    }
    
    /**
     Simplified method of sending a network request
     
     - parameter endpoint: API url endpoin
     - parameter method:   the HTTP method (GET, POST, etc)
     */
    private func sendRequestToEndpoint (endpoint: String, withHTTPMethod method:String) {
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
     Processes the network response data and fires success/failure delegates as determined
     
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
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.delegate?.WiFiUSBStatus(parsedResponse!)
        })
        self.dataTaskComplete()
    }
    
    /**
     Clear the current data task on success/failure
     */
    private func dataTaskComplete () {
        self.currentDataTask = nil
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
        self.dataTaskComplete()
    }
    
}