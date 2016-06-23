#pragma once

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP6266mDNS.h>
#include <USBPower.h>

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
    void begin (const char* domain);
    
    
    /**
    * Handles incomding connections.
    *
    * **Call within main loop
    */
    void handleClients();
    
private:
    
    void handleReboot();
    void handleStatus();
    void handleToggle();
    String buildJSON(bool isOn, int rawValue, String description);
    
    MDNSResponder mdns;
    ESP8266WebServer server;
    USBPower powerManager;
    
};

extern WiFiUSBWebServer WebServer;