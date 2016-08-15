# WiFi-USB PCB v3

This folder contains the Eagle CAD files for the WiFi-USB circuit board.

To install Eagle with a free Express or Educational license, go to
https://cadsoft.io.

It also contains a PDF of the schematic and an image of the board layout
if you want to view the design without installing Eagle.

## Parts

These saved cart links include all the parts necessary to build one board.

* DigiKey: http://www.digikey.com/short/3mnpbh
* Mouser: http://www.mouser.com/ProjectManager/ProjectDetail.aspx?AccessID=066B4F095A
* Sparkfun: https://www.sparkfun.com/products/9717
    - This cable is reusable for many other kinds of projects.
      It is possible to use an alternative to avoid buying an expensive new
      cable, as long as the Tx and Rx signals are 3.3V. The ESP8266 may get
      fried by 5V signals. However, Vcc goes through the voltage regulator and
      is therefore 5V tolerant.

## Fabrication

I recommend ordering PCBs through [OSH Park](https://oshpark.com).
It only costs about $11 for 3 copies of this board, the quality is good,
and they come in a very regal purple and gold.
There are of course many other options you may prefer, but for newcomers,
OSH Park is recommended.

## Building

TODO (Brandon): add build instructions/hints

## Mounting

The mounting holes on the PCB are 2.79mm in diameter, designed to fit
M2.5 screws. These mounting holes are not grounded in the interest of
saving board space.

## Changelog (v3):
* Redesigned form factor to be longer and thinner with receptacles on
  opposite sides
* Added mounting holes
* Removed USB data connection &mdash; only passes through power now
* Grounded USB receptacle chassis
* Added pads around USB-A mounting holes and voltage regulator heatsink
* Eliminated some unnecessary resistors
* Added OSHW logo
