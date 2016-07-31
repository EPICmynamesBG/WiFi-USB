/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 1.2
* License: GNU GPLv3 (see LICENSE)
*/

#include "WiFiUSBSocketServer.h"
#include "config.h"
#include "helpers/JSON.h"
#include <string.h>


WiFiUSBSocketServer::WiFiUSBSocketServer() 
    : server(8080) { };
            

void WiFiUSBSocketServer::begin() {
    
    MDNS.addService("ws", "tcp", 8080);
    
    server.begin();
    server.onEvent(webSocketEvent);
    
    Serial.println("Web Socket server is running at ws://" + String(WEBSERVER_DOMAIN) + ".local:8080");
}

void WiFiUSBSocketServer::webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t leng) {
    
    switch(type) {
        case WStype_DISCONNECTED:
            {
                Serial.printf("[%u] Disconnected!\n", num);
                break;
            }
        case WStype_CONNECTED:
            {
                IPAddress ip = SocketServer.server.remoteIP(num);
                Serial.printf("[%u] Connected from %d.%d.%d.%d url: %s\n", num, ip[0], ip[1], ip[2], ip[3], payload);
				
				// send message to client
                SocketServer.handleStatus(num);
                break;
            }
            
        case WStype_TEXT:
            {
                Serial.printf("[%u] get Text: %s\n", num, payload);
            
                // send message to client
                char * str = JSON::parsePayload(payload, leng);
                Serial.println(str);
                
                
                int evaluatedTo = SocketServer.prepareForSwitch(str);
                switch (evaluatedTo) {
                    case 1: //toggle
                        {   
                            SocketServer.handleToggle();
                            break;
                        }
                    case 2: //status
                        {
                            SocketServer.handleStatus(num);
                            break;
                        }
                    case 3: //reboot
                        {
                            SocketServer.handleReboot();
                            break;
                        }
                    default:
                        {
                            String json = JSON::standardResponse(powerManager.isOn(),powerManager.rawValue(), "Error: Invalid request");
                            break;
                        } 
                }
                
                break;
            }
            
        case WStype_BIN:
            {
                // When will this happen??
                Serial.printf("[%u] get binary lenght: %u\n", num, leng);
                hexdump(payload, leng);

                // send message to client
                SocketServer.server.sendBIN(num, payload, leng);
                break;
            }
    }
    
}

int WiFiUSBSocketServer::prepareForSwitch(char * sent) {
    char toggle[7];
    char status[7];
    char reboot[7];

    String("toggle").toCharArray(toggle, 7);
    String("status").toCharArray(status, 7);
    String("reboot").toCharArray(reboot, 7);
    
    if (strcmp(sent, toggle) == 0){
        return 1;
    } else if (strcmp(sent, status) == 0){
        return 2;
    } else if (strcmp(sent, reboot) == 0){
        return 3;
    } else {
        return -1;
    }
    
}

void WiFiUSBSocketServer::loop() {
    server.loop();
}

void WiFiUSBSocketServer::relayMessage(String json) {
    server.broadcastTXT(json);
}

void WiFiUSBSocketServer::handleStatus(uint8_t num) {

    String description;
    if (powerManager.isOn()) {    
        description = "USB device is powererd on";
    } else {
        description = "USB device is currently off";
    }
    
    String json = JSON::standardResponse(powerManager.isOn(),powerManager.rawValue(), description);
    server.sendTXT(num, json);
}

void WiFiUSBSocketServer::handleToggle() {
    powerManager.togglePower();
    
    String description;
    if (powerManager.isOn()) {    
        description = "USB device has been powered on";
    } else {
        description = "USB device has been powered off";
    }
    
    String json = JSON::standardResponse(powerManager.isOn(),powerManager.rawValue(), description);
    server.broadcastTXT(json);
}

void WiFiUSBSocketServer::handleReboot() {
    
    String json = JSON::standardResponse(powerManager.isOn(),powerManager.rawValue(), "Rebooting NOW");
    server.broadcastTXT(json);
    Serial.println("System is rebooting NOW");
    ESP.restart();
}

WiFiUSBSocketServer SocketServer;
