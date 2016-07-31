//
//  WiFiUSBWebSocket.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 7/31/16.
//  Copyright © 2016 Brandon Groff. All rights reserved.
//

import Foundation
import SwiftWebSocket

protocol WiFiUSBWebSocketDelegate {
    func SocketConnectionOpened()
    func SocketConnectionClosed(reason: String)
    func SocketError(error: ErrorType)
    func SocketDataRecieved(response: JsonResponse)
    func SocketReconnectAborted()
}


class WiFiUSBWebSocket {
    
    private var ws: WebSocket?
    
    private let WS_URL: String = "ws://wifiusb.local:8080"
    
    private let WS_PROTOCOL: String = "arduino"
    
    private(set) var connecting: Bool = false {
        didSet {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = connecting
        }
    }
    
    private let MAX_ATTEMPTS: Int = 2
    
    private(set) var connected: Bool = false
    
    private(set) var rebooting: Bool = false
    
    var delegate: WiFiUSBWebSocketDelegate?
    
    private var reconnectAttempts: Int = 0
    
    init() {
        self.ws = WebSocket(WS_URL)
        self.connecting = true
        setup()
    }
    
    private func setup() {
        self.ws!.event.open = {
            self.connecting = false
            self.connected = true
            self.rebooting = false
            self.delegate?.SocketConnectionOpened()
            self.reconnectAttempts = 0
        }
        self.ws!.event.close = { (code: Int, reason: String, wasClean: Bool) in
            self.delegate?.SocketConnectionClosed(reason)
            self.connected = false
            if (self.reconnectAttempts >= self.MAX_ATTEMPTS) {
                return
            }
            self.reconnect()
            
        }
        self.ws!.event.error = { (error: ErrorType) in
//            if (error == WebSocketError.Network("The operation couldn’t be completed. Operation timed out")){
//                self.reconnect()
//            }
            self.delegate?.SocketError(error)
        }
        self.ws!.event.message = { (data: Any) in
            let json = self.dataToJsonResponse(data)
            if (json != nil){
                self.delegate?.SocketDataRecieved(json!)
            }
            
        }
        self.ws!.event.pong = { (data: Any) in
            self.ws!.ping()
        }
    }
    
    func getStatus() {
        ws!.send(text: "status")
    }
    
    func togglePower() {
        ws!.send(text: "toggle")
    }
    
    func reboot() {
        ws!.send(text: "reboot")
        self.rebooting = true
    }
    
    func disconnect() {
        self.ws!.close()
    }
    
    func reconnect() {
        if (self.reconnectAttempts >= MAX_ATTEMPTS) {
            self.ws!.close()
            self.connecting = false
            self.delegate?.SocketReconnectAborted()
            self.ws = nil
            return
        }
        self.reconnectAttempts += 1
        print(self.reconnectAttempts)
        if (self.ws == nil){
            self.ws = WebSocket(WS_URL)
            self.ws!.open()
        }
        self.connecting = true
    }
    
    private func dataToJsonResponse (data: Any) -> JsonResponse? {
        var resultsDict: NSDictionary?
        
        let str = data as! String
        if let data2 = str.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                resultsDict = try NSJSONSerialization.JSONObjectWithData(data2, options: .MutableLeaves) as? NSDictionary
            } catch let error as NSError {
                
                self.delegate?.SocketError(error)
                return nil
            }
        }
        
        
        let on: Bool? = resultsDict!["on"] as? Bool
        let raw: Int? = resultsDict!["raw"] as? Int
        let desc: String? = resultsDict!["description"] as? String
        
        return JsonResponse(on: on, raw: raw, description: desc)
    }
    
}