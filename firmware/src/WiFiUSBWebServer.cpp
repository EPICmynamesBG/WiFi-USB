/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 1.1
* License: GNU GPLv3 (see LICENSE)
*/

#include "WiFiUSBWebServer.h"
#include "config.h"
#include "FS.h"

WiFiUSBWebServer::WiFiUSBWebServer() 
    : server(80) { };
            

void WiFiUSBWebServer::begin() {
    
    mdns.begin(WEBSERVER_DOMAIN, WiFi.localIP());
    
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

    int raw = powerManager.rawValue();
    String description = "";
    if (powerManager.isOn()) {    
        description = "USB device is powererd on";
    } else {
        description = "USB device is currently off";
    }
    
    String json = buildJSON(raw, description);
    server.send(200, "application/json", json);
}

void WiFiUSBWebServer::handleToggle() {
    powerManager.togglePower();
    int raw = powerManager.rawValue();
    String description = "";
    
    if (powerManager.isOn()) {    
        description = "USB device has been powered on";
    } else {
        description = "USB device has been powered off";
    }
    
    String json = buildJSON(raw, description);
    server.send(200, "application/json", json);
}

void WiFiUSBWebServer::handleReboot() {
    String json = "{\"description\": \"Rebooting NOW\"}";
    server.send(200, "application/json", json);
    Serial.println("System is rebooting NOW");
    ESP.restart();
}

String WiFiUSBWebServer::buildJSON(int rawValue, String description) {
    String json = "{";
    String boolString = powerManager.isOn() ? "true" : "false";
    
    json.concat("\"on\":" + boolString + ", ");
    json.concat("\"raw\":" + String(rawValue) + ", ");
    json.concat("\"description\": \"" + description  + "\"");
    
    json.concat("}");
    
    return json;
}

WiFiUSBWebServer WebServer;
