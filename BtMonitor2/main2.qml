import QtQuick 2.12
import QtQuick.Window 2.12
import QtBluetooth 5.11
import Bt 1.0

Window {
    visible: true
    title: qsTr("BTmonitor")
    height: 640
    property var found: false
    width: 320

    BluetoothDiscoveryModel {
        id: btModel
        running: true
        discoveryMode: BluetoothDiscoveryModel.MinimalServiceDiscovery

        onServiceDiscovered: {
            if (found)
                return

            element.text += service.deviceAddress + " - " + service.serviceName + "\n"

            if (service.deviceAddress == "B8:27:EB:43:05:5D" && service.serviceName == "Serial Port Profile") {
                found = true
                element.text += "Found service\n"
                socket.setService(service)
            }
        }
    }

    BluetoothSocket {
        id: socket
        connected: true

        onSocketStateChanged: {
            element.text += socketState + "\n" + socket.service.serviceProtocol + "\n"
            switch (socketState) {
                case BluetoothSocket.Unconnected:
                    element.text += "Socket is unconnected\n";
                    break;
                case BluetoothSocket.NoServiceSet:
                    element.text += "Socket doesn't have a service yet\n";
                    break;
                case BluetoothSocket.Connected:
                    element.text += "Socket connected\n";
                    break;
                case BluetoothSocket.Connecting:
                    element.text += "Socket is connecting...\n"
                    break;
                case BluetoothSocket.ServiceLookup:
                    element.text += "Socket is looking for a service\n"
                    break;
                case BluetoothSocket.Closing:
                    element.text += "Socket is closing\n"
                    break;
                case BluetoothSocket.Listening:
                    element.text += "Socket is listening\n"
                    break;
                case BluetoothSocket.Bound:
                    element.text += "Socket is bound\n"
                    break;
            }
        }

        onStringDataChanged: {
            element.text = "message: " + this.stringData + "\n"
        }
    }

    Text {
        id: element
        x: 0
        y: 0
        text: qsTr("Text")
        font.pixelSize: 12
    }
}


