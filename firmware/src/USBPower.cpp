/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 1.0
* License: GNU GPLv3 (see LICENSE)
*/

#include "USBPower.h"
#include "config.h"
#include <Arduino.h>

USBPower::USBPower () {
    //init? do something?
}


/**
* Returns 0 if on, 1 if off
*/
int USBPower::rawValue() {
    
    int statusInt = digitalRead(USB_PIN);
    Serial.println("Current power status: " + String(statusInt));
    return statusInt;
}

bool USBPower::isOn() {
    int statusInt = digitalRead(USB_PIN);
    bool statusBool = statusInt == 0 ? true : false;
    Serial.println("Power is on: " + String(statusBool ? "true":"false"));
    return statusBool;
}

void USBPower::togglePower() {

    if (isOn()) {
        turnOff();
    } else {
        turnOn();
    }
}

void USBPower::turnOn() {
    digitalWrite(USB_PIN, 0);
    Serial.println("Turning on USB");
}

void USBPower::turnOff() {
    digitalWrite(USB_PIN, 1);
    Serial.println("Turning off USB");
}

USBPower powerManager;
