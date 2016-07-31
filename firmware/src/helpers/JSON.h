/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 2.0
* License: GNU GPLv3 (see LICENSE)
*/

#pragma once

/**
* Standardize JSON response formatting
*/

class JSON {
    
    
public:
    
    static String standardResponse(bool isOn, int raw, String description);
    
    static char * parsePayload(uint8_t * payload, size_t leng);
    
};
