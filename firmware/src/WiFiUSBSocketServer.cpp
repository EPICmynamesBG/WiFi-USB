/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 1.2
* License: GNU GPLv3 (see LICENSE)
*/

#include "WiFiUSBSocketServer.h"
#include "config.h"



WiFiUSBSocketServer::WiFiUSBSocketServer() 
    : server(8080) { };
            

void WiFiUSBSocketServer::begin() {
    
    MDNS.addService("ws", "tcp", 8080);
    
    server.begin();
    server.onEvent(webSocketEvent);
    
    Serial.println("Web Socket server is running at ws://" + String(WEBSERVER_DOMAIN) + ".local:8080");
}

void WiFiUSBSocketServer::webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {
    
    WebSocketsServer server = SocketServer.server;
    
    switch(type) {
        case WStype_DISCONNECTED:
            Serial.printf("[%u] Disconnected!\n", num);
            break;
        case WStype_CONNECTED:
            {
                IPAddress ip = server.remoteIP(num);
                Serial.printf("[%u] Connected from %d.%d.%d.%d url: %s\n", num, ip[0], ip[1], ip[2], ip[3], payload);
				
				// send message to client
				server.sendTXT(num, "Connected");
            }
            break;
        case WStype_TEXT:
            Serial.printf("[%u] get Text: %s\n", num, payload);

            // send message to client
            // server.sendTXT(num, "message here");

            // send data to all connected clients
            // server.broadcastTXT("message here");
            break;
        case WStype_BIN:
            Serial.printf("[%u] get binary lenght: %u\n", num, length);
            hexdump(payload, length);

            // send message to client
            // server.sendBIN(num, payload, lenght);
            break;
    }
    
}

void WiFiUSBSocketServer::loop() {
    server.loop();
}

void WiFiUSBSocketServer::handleStatus() {

    int raw = powerManager.rawValue();
    String description = "";
    if (powerManager.isOn()) {    
        description = "USB device is powererd on";
    } else {
        description = "USB device is currently off";
    }
    
    String json = buildJSON(raw, description);
//    server.send(200, "application/json", json);
}

void WiFiUSBSocketServer::handleToggle() {
    powerManager.togglePower();
    int raw = powerManager.rawValue();
    String description = "";
    
    if (powerManager.isOn()) {    
        description = "USB device has been powered on";
    } else {
        description = "USB device has been powered off";
    }
    
    String json = buildJSON(raw, description);
//    server.send(200, "application/json", json);
}

void WiFiUSBSocketServer::handleReboot() {
    String json = "{\"description\": \"Rebooting NOW\"}";
//    server.send(200, "application/json", json);
    Serial.println("System is rebooting NOW");
    ESP.restart();
}

String WiFiUSBSocketServer::buildJSON(int rawValue, String description) {
    String json = "{";
    String boolString = powerManager.isOn() ? "true" : "false";
    
    json.concat("\"on\":" + boolString + ", ");
    json.concat("\"raw\":" + String(rawValue) + ", ");
    json.concat("\"description\": \"" + description  + "\"");
    
    json.concat("}");
    
    return json;
}

WiFiUSBSocketServer SocketServer;
