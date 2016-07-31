/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 1.2
* License: GNU GPLv3 (see LICENSE)
*/

#pragma once

#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WebSocketsServer.h>
#include "USBPower.h"

/**
* Manage the socket server
*/
class WiFiUSBSocketServer {
    
public:
    
    /**
    * Create a class instance
    */
    WiFiUSBSocketServer();
    
    
    /**
    * Start the SocketServer
    *
    *
    */
    void begin ();
    
    /**
    * Inherited from WebSocketsServer
    *
    * **Call within main loop
    */
    void loop();
    
    void relayMessage(String json);
    
protected:
    
    WebSocketsServer server;
    
private:
    
    /**
    * Needed by WebSocketsServer
    */
    static void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t leng);
    
    void handleReboot();
    void handleStatus(uint8_t num);
    void handleToggle();
    
    int prepareForSwitch(char * sent);
    
    MDNSResponder mdns;
    
};

extern WiFiUSBSocketServer SocketServer;
