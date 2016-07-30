# WiFi-USB #
A wirelessly controllable USB power port

_Firmware Version:_ 1.2

_iOS App Version_: 0.4

_Web App Version_: 0.2

---

## About ##

_What is WiFi-USB?_

WiFi-USB is an IoT device and software that enables a USB powered device (up to 2.0 A) to be remotely powered on and off.

_Why WiFi-USB?_

The inspiration for this project came from a general irritation with a USB powered device that did not have an inline power switch. Wall outlets aren't always in the most convenient of places, so plugging/unplugging this USB port from a wall adapter all the time could be a hassle.

_How can I use WiFi-USB?_

Keep reading below for more on how to build your own WiFi-USB board, and instructions on how to install the firmware to get your device up and running.

## Important Notes ##

** Never plug both the mini-USB power supply and the FTDI power at the same time. The hardware is not designed to handle this and will surely break **

## Recent Updates ##

### Firmware v1.2 ###

- Introducing Access Point Broadcasting fallback when client connect mode fails

## Hardware ##

Files and instructions will be posted soon.

## Firmware Install ##

1. Download and install the [Arduino IDE](https://www.arduino.cc/en/Main/Software)
2. Configure the IDE using the instructions [here](https://github.com/esp8266/arduino#installing-with-boards-manager)
3. In the Arduino IDE, go to Sketch > Include Library > Manage Libraries. Search 'WebSockets', and install the latest version of WebSockets by Marcus Sattler [GitHub](https://github.com/Links2004/arduinoWebSockets)
4. Download the zip/clone this repo
5. In `config.h` update the SSID and SSID_PASSWORD variables to match your network configuration.
6. Open `firmware.ino` and click upload in the Arduino IDE when the device is in develop mode

## Web Install ##

The appropriate web files are already in the WiFi-USB's firmware > data folder. Simply follow [this guide](https://github.com/esp8266/arduino-esp8266fs-plugin) on how to install and upload the those files to WiFi-USB for the web control panel to become available.

## Installing the iOS & Watch app (Requires a Mac) ##

1. Install [XCode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) on your system
  - Built using XCode 7.3.1
2. Open  WiFi-USB.xcodeproj
3. Select the Project (the blue icon) from the Nvigation bar
  - Under Targets, change the team on each one to the team of your desire (probably personal or None)
4. Now plug in your device, and click the Play arrow to Run the app on your device
  - If you have a watch, to install the watch app, on the bar next to the run button, select WK-WiFi-USB as your build target, then selecte your device with watch, and hit Run 


## Using WiFi-USB ##


The default endpoint for WiFi-USB will be [http://wifiusb.local](http://wifiusb.local). Going to this page will show you a simple html page, confirming that the wifiusb is running.

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
  * `description: String` - a textual confirmation that the device is rebooting


## Future Ideas ##
* Add a timer/alarm clock ability. Turn on/off at a set time!
* ~~Create an Apple Watch extensnion ~~
* Add WebSocket ability for live status sync across all controller devices


## Credits ##


[Alex Cordonnier](https://github.com/ajcord) - for designing the board and helping me troubleshoot every step of the way!

## Licenses ##

[_firmware_](https://github.com/EPICmynamesBG/WiFi-USB/blob/master/firmware/LICENSE) : GNU GPLv3

[_iOS_](https://github.com/EPICmynamesBG/WiFi-USB/blob/master/iOS/LICENSE) : GNU GPLv3

[_iOS_](https://github.com/EPICmynamesBG/WiFi-USB/blob/master/web/LICENSE) : GNU GPLv3
