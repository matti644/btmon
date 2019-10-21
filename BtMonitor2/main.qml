import QtQuick 2.12
import QtQuick.Window 2.12
import QtBluetooth 5.11
import Bt 1.0
import QtQuick.Layouts 1.12
import QtCharts 2.3

Window {
    visible: true
    title: qsTr("BTmonitor")
    height: 640
    property var found: false

    property var runTimer: false
    property var mon1Data
    property var mon2Data

    width: 320

    Timer {
        id: timer
        interval: 1 / 60 * 1000 // 60fps
        running: false
        repeat: true
        onTriggered: {
            updateMons()
        }
    }

    function updateMons() {
        updateMon(ls, mon1Data);
        updateMon(ls2, mon2Data);

        monitor.text = "Monitor 1 avg (0.1s): " + calculateAvgOverLastTenPoints(mon1Data)
                + "\nMonitor 2 avg (0.1s): " + calculateAvgOverLastTenPoints(mon2Data)
    }

    function updateMon(sr, data) {
        for (var i = 0; i < data.length; i++) {
            sr.replace(i, i, data[i]);
        }
    }

    function calculateAvgOverLastTenPoints(data) {
        var sum = 0;
        for (var i = data.length - 1; i >= 90; i--) {
            sum += data[i];
        }
        return sum / 10;
    }

    Bt {
        id: demo

        onReadedSocket:
        {
            if (!runTimer) {
                // For the first time running, append all the data points
                // Afterwards update them
                for (var prop in atalante) {
                    ls.append(ls.count, prop)
                }

                for (var prop in tamamo) {
                    ls2.append(ls2.count, prop);
                }

                timer.running = true
                runTimer = true
            }

            mon1Data = atalante;
            mon2Data = tamamo;
        }
    }

    GridLayout {
        id: gr
        anchors.fill: parent
        anchors.margins: 20
        rowSpacing: 20
        columnSpacing: 20
        flow: width > height ? GridLayout.LeftToRight : GridLayout.TopToBottom

        Rectangle {
            id: textRect
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#fff"

            Text {
                id: monitor

                text: qsTr("A connection to the device has not been established yet.")
                font.pixelSize: 12
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#fff"

            ChartView {
                id: chart
                anchors.fill: parent
                antialiasing: true

                ValueAxis {
                    id: axisX
                    min: 0
                    max: 100
                }

                ValueAxis {
                    id: axisY
                    min: 0
                    max: 100
                }

                ValueAxis {
                    id: axisY2
                    min: 0
                    max: 10.0
                }

                LineSeries {
                    id: ls

                    name: "Monitor 1"
                    axisX: axisX
                    axisY: axisY
                    useOpenGL: true
                }

                LineSeries {
                    id: ls2

                    name: "Monitor 2"
                    axisX: axisX
                    axisY: axisY
                }
            }
        }
    }
}


