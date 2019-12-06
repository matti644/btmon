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

    // Bluetooth discovery control
    property var found: false

    // Chart data control
    property var runTimer: false
    property var mon1ChartData
    property var mon2ChartData

    // Generator properties
    property var gen1Data: []
    property var gen2Data: []
    property var curIndex: 0

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
        updateMon(lsMon1, mon1ChartData);
        updateMon(lsMon2, mon2ChartData);

        monitor.text = "Monitor 1 avg (0.1s): " + calculateAvgOverLastTenPoints(mon1ChartData)
                + "\nMonitor 2 avg (0.1s): " + calculateAvgOverLastTenPoints(mon2ChartData)
    }

    function updateMon(sr, data) {
        for (let i = 0; i < data.length; i++) {
            sr.replace(i, i, data[i]);
        }
    }

    function calculateAvgOverLastTenPoints(data) {
        var sum = 0;
        for (let i = data.length - 1; i >= 90; i--) {
            sum += data[i];
        }
        return sum / 10;
    }

    /* --------------- Generator functions --------------- */
    function preFill() {
        for (let i = 0; i < 100; i++) {
            gen1Data.push(i);
            gen2Data.push((i / 10)**2);
        }
    }

    function nextStep() {
        for (let i = 0; i < 10; i++) {
            let ind = curIndex % 100;

            gen1Data.shift();
            gen2Data.shift();

            gen1Data.push(ind);
            gen2Data.push((ind / 10)**2)

            curIndex++
        }

        if (!runTimer) {
            for (var mon1Data in gen1Data) {
                lsMon1.append(lsMon1.count, mon1Data)
            }

            for (var mon2Data in gen2Data) {
                lsMon2.append(lsMon2.count, mon2Data);
            }

            timer.running = true
            runTimer = true
        }

        mon1ChartData = gen1Data;
        mon2ChartData = gen2Data;
    }

    Timer {
        id: generatorTimer
        interval: 100 // 10/1s
        running: true
        repeat: true
        onTriggered: {
            nextStep()
        }

        Component.onCompleted: {
            preFill()
        }
    }
    /* --------------- Back to normal --------------- */

    /*Bt {
        id: demo

        onSocketDataRead: {
            if (!runTimer) {
                // For the first time running, append all the data points
                // Afterwards update them
                for (var mon1Data in mon1) {
                    ls.append(ls.count, mon1Data)
                }

                for (var mon2Data in mon2) {
                    ls2.append(ls2.count, mon2Data);
                }

                timer.running = true
                runTimer = true
            }

            mon1ChartData = mon1;
            mon2ChartData = mon2;
        }
    }*/

    GridLayout {
        /*
          Doesn't scale all too neatly, unless 50/50 width/height split,
          look into better ways of handling scalability
          */

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
                    id: lsMon1

                    name: "Monitor 1"
                    axisX: axisX
                    axisY: axisY
                    useOpenGL: true
                }

                LineSeries {
                    id: lsMon2

                    name: "Monitor 2"
                    axisX: axisX
                    axisY: axisY
                }
            }
        }
    }
}


