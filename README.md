# ![Title](/.images/ninjacat-lamp-title.jpg)

> [!NOTE]
> If you have received a Ninjacat lamp because your were a speaker during the conference; **CONGRATULATIONS!** 🎉 And thank you for being awesome! 🙏🏻
> Please skip ahead to [the setup instructions](https://github.com/yellowhat-live/ninjacat-lamp/tree/main#re-configure-wifi) at the end.

Create your own Ninjacat Wi-Fi-enabled smart light powered by [WLED](https://kno.wled.ge/) and compatible with [Home Assistant](https://www.home-assistant.io/)! 👌🏻

![army](/.images/ninjacat-lamp-army.gif)

## Print and build your own lamp

This repository contains all the print files and instructions to print and built your own Ninjacat lamp!

### Requirements

- a 3D printer with a build plate of at least 236mm x 236mm (9.3" x 9.3")
- [ESP8266 Wi-Fi microcontroller](https://www.amazon.nl/dp/B01N9RXGHY?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1)
- [WS2812B LED Strip 2m (6.5ft)](https://www.amazon.nl/dp/B0D5B5CGVX?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1)
- Micro-USB cable
- Black and white filament are probably your best choice but feel free to experiment 😉

### Print Files

| Example | Filename | Description |
| --- | --- | --- |
| ![housing](/.images/ninjacat-lamp-printfiles-housing.png) | ninjacat-lamp-housing.stl | This is the lamp's main housing. If you have a multi-material printer (i.e. Bambu Labs with AMS) color the bottom white to increase light relfectivity. If you don't own a multi-material printer, please print the separate 'reflector' and put this inside the housing. |
| ![cover](/.images/ninjacat-lamp-printfiles-cover.png) | ninjacat-lamp-cover.stl | This is the cover to put on the front of the houding after LED installation. The 1mm thick front should provide plenty of transparency for the lights to shine through. If you want to print this cover as nicely as possible use the following print settings:<br> - Print face up with **NORMAL** supports<br> - Top interface spacing: 0.3mm<br> - Enable ironing<br> - Ironing speed: 150mm/s<br> - Ironing flow: 38%<br> - Ironing line spacing: 0.15mm<br> - Ironing inset: 0.21mm<br>This will create the most smooth surface for both the top and underside of the cover. |
| ![reflector](/.images/ninjacat-lamp-printfiles-reflector.png) | ninjacat-lamp-housing-reflector.stl | This is relfector is optional if you don't own a printer capable of printing multiple materials within the same layer. The reflector fits nice and snug inside the housing and provides maximum light reflectivity. |
| ![espholder](/.images/ninjacat-lamp-printfiles-espholder.png) | ninjacat-lamp-housing-esp8266-holder.stl | This is holds the ESP8266 board and should be glued to the backside of the housing/reflector. This ensures the board and cables won't touch the front cover creating ugly shadows from the LEDs. |
| ![eyes](/.images/ninjacat-lamp-printfiles-eyes.png) | ninjacat-lamp-housing-eye-infill.stl | These tiny white cylinders fit inside the cavities of the cat's eye, part of the housing. |
| ![stand](/.images/ninjacat-lamp-printfiles-stand.png) | ninjacat-lamp-housing-stand.stl | A separate stand if you which to put your Ninjacat on a shelve instead of hanging it on the wall. |
| ![tag](/.images/ninjacat-lamp-printfiles-tag.png) | ninjacat-lamp-housing-stand.stl | This tag was part of the Yellowhat 2025 giveaway and speaker gifts and is obviously completely optional. The QR code links to this page for instructions on how to use/setup the lamp. |

![print-timelapse](/.images/ninjacat-lamp-print-timelapse.gif)

### Assembly

1. Cut off the connector from the LED strip and also remove the separate red and white cables.
2. Solder the red (5V), white (G) and green (D4) to the ESP8266 board.
![solder](/.images/ninjacat-lamp-assemble-solder.jpg)
3. Start the LED strip on the bottom right and circle counter-clockwise around the ring to get started. The first LED should be right on the edge:
![led-start](/.images/ninjacat-lamp-assemble-led-start.jpg)
4. Make sure to router the cable underneath the LED strip near the end:
![led-end](/.images/ninjacat-lamp-assemble-led-end.jpg)

### Installing WLED firmware

![wled-install](/.images/ninjacat-lamp-wled-install.gif)

1. Connect the USB cable to your computer and open up a browser which support serial-port emulation (i.e. Microsoft Edge, sorry Safari won't work...)
2. visit [https://install.wled.me](https://install.wled.me) and click on **INSTALL**.
3. A pop-up will open asking you which port to use, select the emulated serial port over USB.
4. Wait until flash is complete and enter in your Wi-Fi network credentials.
5. You'll be automatically redirected to the device page.

> [!NOTE]
> While you could go with a different order of the LED placement, the `ledmap.json` further don't this document only works with this exact placements If you change the order you should create your own `ledmap.json`.

#### Initial setup

1. Go into "Config" --> "WiFi Setup" and update your hostname (i.e. `ninjacat-lamp.local`)
2. Go into "Config" --> "LED Preferences" and update both the Max PSU current to **900mA** and Length to **94**:
![ledpreferences](/.images/ninjacat-lamp-wled-ledconfig.jpg)
3. Add `/edit` to the device page URL and create a new file named `ledmap.json`.
4. Copy the contents and click "Save".

```json
{
  "map": [
      0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
     33, 34, 35, 36, 37, 38, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93,
     39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76
  ]
}
```

![wled-install](/.images/ninjacat-lamp-wled-ledmap.png)

> [!NOTE]
> The ledmap.json changes the order of your LEDs on the strip. This ensure that we can have three distinct segments for either the "ring", "Ninjacat" and its "Bandana". Otherwise we would've ended up with multiple segments of each due to the way the entire strip is routed through the housing.

#### Configuring LED segments

The easiest wat is to run the PowerShell script `Send-Wledconfig.ps1` from this repository to push the initial setup.

```powershell
./wled/Send-Wledconfig.ps1 -lampAddress ninjacat-lamp.local
```
![wled-pssendconfig](/.images/ninjacat-lamp-wled-pssendconfig.jpg)

But you can also set the segments manually:
![wled-install](/.images/ninjacat-lamp-wled-segments.jpg)

## Re-configure Wi-Fi

If your lamp is already fully assembled and was setup earlier, please go through the following steps to re-configure Wi-Fi.

1. Connect the USB cable to your computer and open up a browser which support serial-port emulation (i.e. Microsoft Edge, sorry Safari won't work...)
2. visit [https://install.wled.me](https://install.wled.me) and click on **INSTALL**.
3. A pop-up will open asking you which port to use, select the emulated serial port over USB.
4. Since the device is already flashed with WLED firmware you get an option to change the Wi-Fi configuration.
5. After altering the Wi-Fi configuration you get the option to "visit device" or "add to Home Assistant". The device is accessible via [http://ninjacat-lamp.local](http://ninjacat-lamp.local)
6. Use the device page to create your own unique presets and animations using the pre-defined segments "Ninjcat", "Ring" and "Bandana".
7. There's a WLED App for iOS and Android to switch/alter your Ninjacat lamp or you can choose to integrate it into Home Assistant.
