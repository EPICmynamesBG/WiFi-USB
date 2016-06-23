#include "WiFiUSBWebServer.h"

//#define WEBSERVER_DOMAIN "wifiusb" //without the .local ending

WiFiUSBWebServer::WiFiUSBWebServer() 
    : server(80) { };
            

void WiFiUSBWebServer::begin() {
    
    mdns.begin(WEBSERVER_DOMAIN, WiFi.localIP());
    
    server.on("/", [this]() {
        String response = "<!DOCTYPE HTML>\r\n<html><body><h1>Welcome to WiFi USB v0.1</h1></body></html>";
        server.send(200, "text/html", response);
    });
    
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
    bool isOn = powerManager.isOn();
    int raw = powerManager.rawValue();
    String description = "";
    if (isOn) {    
        description = "USB device is powererd on";
    } else {
        description = "USB device is currently off";
    }
    
    String json = buildJSON(isOn, raw, description);
    server.send(200, "application/json", json);
}

void WiFiUSBWebServer::handleToggle() {
    powerManager.togglePower();
    bool isOn = powerManager.isOn();
    int raw = powerManager.rawValue();
    String description = "";
    
    if (isOn) {    
        description = "USB device has been powered on";
    } else {
        description = "USB device has been powered off";
    }
    
    String json = buildJSON(isOn, raw, description);
    server.send(200, "application/json", json);
}

void WiFiUSBWebServer::handleReboot() {
    String json = "{\"description\": \"Rebooting NOW\"}";
    server.send(200, "application/json", json);
    Serial.println("System is rebooting NOW");
    ESP.restart();
}

String WiFiUSBWebServer::buildJSON(bool isOn, int rawValue, String description) {
    String json = "{";
    String boolString = isOn ? "true" : "false";
    
    json.concat("\"on\":" + boolString + ", ");
    json.concat("\"raw\":" + String(rawValue) + ", ");
    json.concat("\"description\": \"" + description  + "\"");
    
    json.concat("}");
    
    return json;
}

WiFiUSBWebServer WebServer;
