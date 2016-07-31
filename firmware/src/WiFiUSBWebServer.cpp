/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 1.2
* License: GNU GPLv3 (see LICENSE)
*/

#include "WiFiUSBWebServer.h"
#include "config.h"
#include "FS.h"
#include "helpers/JSON.h"
#include "WiFiUSBSocketServer.h"

WiFiUSBWebServer::WiFiUSBWebServer() 
    : server(80) { };
            

void WiFiUSBWebServer::begin() {
    
    MDNS.addService("http", "tcp", 80);
    
    SPIFFS.begin();
    
    server.serveStatic("/", SPIFFS, "/index.html", "max-age=86400");
    server.serveStatic("/index.css", SPIFFS, "/index.css", "max-age=86400");
    server.serveStatic("/index.js", SPIFFS, "/index.js", "max-age=86400");
    server.serveStatic("/images/favicon.png", SPIFFS, "/favicon.png", "max-age=86400");
    server.serveStatic("/images/info-icon.png", SPIFFS, "/info-icon.png", "max-age=86400");
    server.serveStatic("/images/power_button_gray_512.png", SPIFFS, "/power_button_gray_512.png", "max-age=86400");
    server.serveStatic("/images/power_button_green_512.png", SPIFFS, "/power_button_green_512.png", "max-age=86400");
    server.serveStatic("/images/power_button_red_512.png", SPIFFS, "/power_button_red_512.png", "max-age=86400");
    server.serveStatic("/images/reboot-button-web_64.png", SPIFFS, "/reboot-button-web_64.png", "max-age=86400");
    server.serveStatic("/images/app-icon.png", SPIFFS, "/app-icon.png", "max-age=86400");
    
    server.on("/status", HTTP_GET, [this] {
        handleStatus();
    });
    
    server.on("/toggle", HTTP_POST, [this]{
        handleToggle();
    });
    
    server.on("/reboot", [this] {
        handleReboot();
    });
    
    server.begin();
    Serial.println("Web server is running at http://" + String(WEBSERVER_DOMAIN) + ".local");
}

void WiFiUSBWebServer::handleClients() {
    server.handleClient();
}

void WiFiUSBWebServer::handleStatus() {

    String description;
    if (powerManager.isOn()) {    
        description = "USB device is powererd on";
    } else {
        description = "USB device is currently off";
    }
    
    String json = JSON::standardResponse(powerManager.isOn(), powerManager.rawValue(), description);
    server.send(200, "application/json", json);
}

void WiFiUSBWebServer::handleToggle() {
    powerManager.togglePower();
    
    String description;
    if (powerManager.isOn()) {    
        description = "USB device has been powered on";
    } else {
        description = "USB device has been powered off";
    }
    
    String json = JSON::standardResponse(powerManager.isOn(), powerManager.rawValue(), description);
    SocketServer.relayMessage(json);
    server.send(200, "application/json", json);
}

void WiFiUSBWebServer::handleReboot() {
    
    String json = JSON::standardResponse(powerManager.isOn(), powerManager.rawValue(), "Rebooting NOW");
    SocketServer.relayMessage(json);
    server.send(200, "application/json", json);
    Serial.println("System is rebooting NOW");
    ESP.restart();
}

WiFiUSBWebServer WebServer;
