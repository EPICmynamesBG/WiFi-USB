# WiFi-USB #
Hardware Version 1.1

Firmware Version 1.0

A wirelessly controllable USB power port

---

## About ##

_What is WiFi-USB?_

WiFi-USB is an IoT based device and software that enables a USB powered device (up to 5V) to be remotely powered on and off.

_Why WiFi-USB?_

The inspiration for this project came from a general irritation with a USB powered device that did not have an inline power switch. Wall outlets aren't always in the most convenient of places, so plugging/unplugging this USB port from a wall adapter all the time could be a hassle.

_How can I use WiFi-USB?_

Keep reading below for more on how to build your own WiFi-USB board, and instructions on how to install the firmware to get your device up and running.

## Hardware ##
---
_Soldering iron and solder required for assembly_

* Custom Board
  * use [Eagle](http://www.cadsoftusa.com/download-eagle/) to view the board files in the hardware folder
  * boards can be ordered through [OSH Park](https://oshpark.com/)
* Ardiuno ESP8266
* MORE

## Firmware Install ##
---

1. Download and install the [Ardiuno IDE](https://www.arduino.cc/en/Main/Software)
2. Configure the IDE
  * Configuration steps HERE
3. Download the zip/clone this repo into a folder named 'firmware'
4. In `config.h` update the SSID and SSID_PASSWORD variables to match your network configuration.
5. Open `firmware.imo` and click upload in the Arduino IDE

## Using WiFi-USB ##
---

The default endpoint for WiFi-USB will be http://wifiusb.local. Going to this page will show you a simple html page, confirming that the wifiusb is running.

WiFi-USB is configured with 3 REST endpoints that will return JSON data:


_Check the status of the USB's power_
* `/status` - GET (no parameters)
  * `on: Bool` - simple check if USB is on or off
  * `raw: Int` - the raw GPIO pin value for the USB pin 
  * `description: String` - a textual description of the USB power status


_Toggle the USB power on/off_
* `/toggle` - POST (no parameters)
  * `on: Bool` - simple check if USB is on or off
  * `raw: Int` - the raw GPIO pin value for the USB pin 
  * `description: String` - a textual description of the USB power status


_Reboot the device_
* `/reboot` - GET (no parameters)
  * `description: String` - a textual confirmation that the device is reooting


## Credits ##
---

[Alex Cordonnier](https://github.com/ajcord) - for designing the board and helping me troubelshoot every step of the way!

## License ##
---

TODO
