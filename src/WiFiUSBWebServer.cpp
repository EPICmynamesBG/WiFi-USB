#include "WiFiUSBWebServer.h"

#define WEBSERVER_DOMAIN    "wifiusb" //without the .local ending

WiFiUSBWebServer::WiFiUSBWebServer() {
    ESP8266WebServer server = server(80);
    USBPower powerManager = USBPower();
}              

void WiFiUSBWebServer::begin(const char* domain) {
    
    mdns.begin(domain, WiFi.localIP());
    
    SPIFFS.begin();
    
    server.on("/", [this]() {
        String response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<!DOCTYPE HTML>\r\n<html><body><h1>Welcome to WiFi USB v1</h1></body></html>";
        server.send(response);
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
    Serial.println("Web server is running at http://" + String(domain) + ".local");
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
    
    json.concat("\"on\":" + String(isOn));
    json.concat("\"raw\":" + String(rawValue));
    json.concat("\description\":" + description);
    
    json.concat("}");
    
    return json;
}