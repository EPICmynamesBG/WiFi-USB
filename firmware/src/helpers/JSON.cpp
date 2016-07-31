/**
* WiFi-USB: a wirelessly controllable USB power port
* Author: Brandon Groff
* Version: 1.2
* License: GNU GPLv3 (see LICENSE)
*/

#include <Arduino.h>
#include "JSON.h"

String JSON::standardResponse(bool isOn, int raw, String description) {
    String json = "{";
    String boolString = isOn ? "true" : "false";
    
    json.concat("\"on\":" + boolString + ", ");
    json.concat("\"raw\":" + String(raw) + ", ");
    json.concat("\"description\": \"" + description  + "\"");
    
    json.concat("}");
    
    return json;
}

char * JSON::parsePayload(uint8_t * payload, size_t leng) {
    
    char * char_pointer = (char*)payload;
//    String str = std::string s( reinterpret_cast<char const*>(payload), leng ) ;
    
    Serial.print("Parsed to:");
    Serial.println(char_pointer);
    
    return char_pointer;
}
