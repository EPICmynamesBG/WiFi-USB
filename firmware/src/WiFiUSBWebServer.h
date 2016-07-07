/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 1.1
* License: GNU GPLv3 (see LICENSE)
*/

#pragma once

#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include "USBPower.h"

/**
* Manage the web server
*/
class WiFiUSBWebServer {
    
public:
    
    /**
    * Create a class instance
    */
    WiFiUSBWebServer();
    
    
    /**
    * Start the WebServer
    *
    *
    */
    void begin ();
    
    
    /**
    * Handles incoming connections.
    *
    * **Call within main loop
    */
    void handleClients();
    
private:
    
    void handleReboot();
    void handleStatus();
    void handleToggle();
    String buildJSON(int rawValue, String description);
    
    MDNSResponder mdns;
    ESP8266WebServer server;
    USBPower powerManager;
    
};

extern WiFiUSBWebServer WebServer;
