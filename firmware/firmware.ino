/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 1.0
* License: Apache License 2.0 (see src/LICENSE)
*/

#include <ESP8266WiFi.h>
#include "src/config.h"
#include "src/USBPower.h"
#include "src/WiFiUSBWebServer.h"

void setup() {
    
    initialize();
    
    printMacAddress();
    establishWirelessConnection();
    printWirelessInfo();
    
    WebServer.begin();
    
}

void loop() {
    
    WebServer.handleClients();
    
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
