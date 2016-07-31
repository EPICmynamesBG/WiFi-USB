/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 1.2
* License: GNU GPLv3 (see LICENSE)
*/

#pragma once

/**
* Manage the USB's Power
*/
class USBPower {
    
    
public:
    
    /**
    * Constructor
    */
    USBPower();
    
    /**
    * Get current power status
    * Note: 0 = on, 1 = off
    */
    int rawValue();
    
    /**
    * Like CurrentStatus, simple bool check
    */
    bool isOn();
    
    /**
    * Toggle the power
    */
    void togglePower();
    
    
private:
    
    void turnOn();
    
    void turnOff();
};

extern USBPower powerManager;
