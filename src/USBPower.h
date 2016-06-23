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
