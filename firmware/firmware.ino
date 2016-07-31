/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 2.0
* License: GNU GPLv3 (see LICENSE)
*/

#include <ESP8266WiFi.h>
#include "src/config.h"
#include "src/USBPower.h"
#include "src/WiFiUSBWebServer.h"
#include "src/WiFiUSBSocketServer.h"

void setup() {
    
    initialize();
    
    printMacAddress();
    
    if (establishWirelessConnection()){
        printWirelessClientInfo();
        MDNS.begin(WEBSERVER_DOMAIN, WiFi.localIP());
    } else {
        Serial.print("\n\nConnecting to network "+String(SSID)+" failed. Going into Access Point mode...");
        setupAccessPointMode();
        printWirelessBroadcastInfo();
        MDNS.begin(WEBSERVER_DOMAIN, WiFi.softAPIP());
    }
    
    
    WebServer.begin();
    SocketServer.begin();
}

void loop() {
    
    WebServer.handleClients();
    
    SocketServer.loop();
    
}

/**
* Setup Serial printing and GPIO pins
*/
void initialize() {
    Serial.begin(115200);
    Serial.print("\n\n");

    pinMode(USB_PIN, OUTPUT);
    digitalWrite(USB_PIN, 0);
}

/**
 * Print the ESP8266's MAC address
 */
void printMacAddress() {

    Serial.print("MAC address: ");

    unsigned char mac[WL_MAC_ADDR_LENGTH];
    WiFi.macAddress(mac);

    for (int i = WL_MAC_ADDR_LENGTH - 1; i > 0; i--) {
        Serial.print(mac[i], HEX);
        Serial.print(":");
    }

    Serial.println(mac[0], HEX);
}

/**
 * Print info about the wireless connection.
 */
void printWirelessClientInfo() {

    Serial.print("LAN IPv4 address: ");
    Serial.println(WiFi.localIP());

    Serial.print("Signal strength (RSSI): ");
    Serial.println(WiFi.RSSI());
}

bool establishWirelessConnection() {
    
    Serial.print("\n\nAttempting to establish a wireless connection to " + String(SSID) + "\n");
    WiFi.begin(SSID, SSID_PASSWORD);
    
    int connectAttempts = 0;
    while (WiFi.status() != WL_CONNECTED) {
        if (connectAttempts > 10){
            WiFi.disconnect(true);
            return false;
            break;
        }
        
        delay(1000);
        Serial.print(".");
        connectAttempts += 1;
    }
    
    Serial.println("Connected to " + String(SSID));
    return true;
}

void setupAccessPointMode() {
    Serial.print("\n\nConfiguring access point...\n");
    WiFi.softAP(AP_SSID, AP_PASSWORD);
}

void printWirelessBroadcastInfo() {
    Serial.print("Access Point IPv4 address: ");
    Serial.println(WiFi.softAPIP());
    
    Serial.println("Access Point started.");
    Serial.println("SSID: "+ String(AP_SSID));
    Serial.println("Password: "+ String(AP_PASSWORD));
    
}
