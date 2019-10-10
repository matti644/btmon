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

    Bt {
        id: demo

        onReadedSocket:
        {
            element.text = i;
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


