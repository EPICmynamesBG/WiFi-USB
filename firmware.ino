/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 0.1
*/

#include <ESP8266WiFi.h>
#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include "src/config.h"
#include "src/USBPower.h"
#include "src/WiFiUSBWebServer.h"

void setup() {
    Serial.begin(115200);
    Serial.print("\n\n");

    pinMode(USB_PIN, OUTPUT);
    digitalWrite(USB_PIN, 0);
    
    printMacAddress();
    establishWirelessConnection();
    printWirelessInfo();
    
    WebServer.begin();
    
}

void loop() {
    
    WebServer.handleClients();
    
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
void printWirelessInfo() {

    Serial.print("LAN IPv4 address: ");
    Serial.println(WiFi.localIP());

    Serial.print("Signal strength (RSSI): ");
    Serial.println(WiFi.RSSI());
}

void establishWirelessConnection() {
    
    Serial.print("\n\nEstablishing a wireless connection to " + String(SSID) + "\n");
    WiFi.begin(SSID, SSID_PASSWORD);
    
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.print(".");
    }
    Serial.println("Connected to " + String(SSID));
}
