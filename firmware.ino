/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 0.1
*/

#include <ESP8266WiFi.h>
#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <src/USBPower.h>
#include <src/WiFiUSBWebServer.h>

#define SSID                "XCast"
#define SSID_PASSWORD       "XCast2016"
#define WEBSERVER_DOMAIN    "wifiusb" //without the .local ending

void setup() {
    Serial.begin(115200);
    Serial.print("\n\n");
    
    printMACAddress();
    establishWirelessConnection();
    printWirelessInfo();
    
    WiFiUSBWebServer.begin();
    
}

void loop() {
    
    WiFiUSBWevServer.handleClients();
    
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
    WiFi.begin(SSID, SSID_PASSWORD);
    Serial.print("\n\nEstablishing a wireless connection to " + SSID + "\n");
    while (WiFi.status() !+ WL_CONNECTED) {
        delay(1000);
        Serial.print(".");
    }
    Serial.print("\nConnected to " + SSID);
}