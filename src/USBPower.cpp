#include "USBPower.h"

#define USB_PIN     2

USBPower::USBPower () {
    //init? do something?
}


/**
* Returns 0 if on, 1 if off
*/
int USBPower::currentStatus() {
    
    int statusInt = digitalRead(USB_PIN);
    Serial.println("Current power status: " + String(statusInt));
    return statusInt;
}

bool USBPower::isOn() {
    int statusInt = digitalRead(USB_PIN);
    bool statusBool = statusInt == 0 ? true : false;
    Serial.println("Power is on: " + String(statusBool));
    return statusBool;
}

void USBPower::togglePower() {
    int statusInt = digitalRead(USB_PIN);
    if (statusInt == 0) {
        turnOn();
    } else {
        turnOff();
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