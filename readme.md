# BTMon

BTMon aka BTMonitor is a mobile application that talks with a specified end device. The app connects to the device on startup and presents the information as seen in [these screenshots](https://github.com/matti644/btmon/tree/master/Dokumentaatio/Kuvakaappaukset). The app also provides functionality to take snapshots of the shown data, saving and viewing them.

The app has been tested to work with a Raspberry Pi 3b and with an Arduino Mega 2560. The app has been developed alongside JAMK courses Mobile Application Development (as the Research Project) and Mobile Project.

# How to run

### Prerequisite:

* Qt 5.12.5
* QtCharts 5.13.1
* Qt Community Editor 4.10.x
* Bluetooth cabable Raspberry Pi or Arduino with a bluetooth module

While developing, we've tested functionality both on a Raspberry Pi 3b and on an Arduino Mega 2560 with an AliExpress bluetooth module. Code used in both devices are included. `server.py` was used for the Raspberry Pi and `arduino.ino` was used for the Arduino Mega.

### Running

1. Copy the repository `git clone https://github.com/matti644/btmon.git`.
2. If using an Arduino, make sure the serial.
3. Open the project using Qt Community Editor, make sure the editor is configured correctly.
4. Configure [The device ID to match your Raspberry Pi or Arduino](https://github.com/matti644/btmon/blob/master/BtMonitor2/Bt.cpp#L57).
5. Make sure your Raspberry Pi or Arduino is running the server code.
6. Compile and run the application.


# Research Project

| Tekijä         | Itsearvointi |
|----------------|--------------|
| Eero Ronkainen | [Linkki](./Itsearviointi/Eero_Ronkainen.md)       |
| Matti Aho      | [Linkki](./Itsearviointi/Matti_Aho.md)      |

# Mobile Project

Screenshots: [/Kuvakaappaukset](https://github.com/matti644/btmon/tree/master/Dokumentaatio/Kuvakaappaukset)  
Documentation (in Finnish): [Documentation](https://github.com/matti644/btmon/blob/master/Dokumentaatio/Dokumentaatio.pdf)

| Tekijä         | Itsearvointi |
|----------------|--------------|
| Eero Ronkainen | [Linkki](./Itsearviointi/Eero_Ronkainen.md)       |
| Matti Aho      | [Linkki](./Itsearviointi/Matti_Aho.md)      |
