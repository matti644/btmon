import QtQuick 2.12
import QtQuick.Window 2.12
import QtBluetooth 5.11
import QtQuick.Layouts 1.12
import QtCharts 2.3
import QtQuick.Controls 2.12

import Bt 1.0
import FileManager 1.0

Window {
    visible: true
    title: qsTr("BTmonitor")
    height: 640
    id: app


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

    // Exposed components
    property var stackView: stack
    property var fileMan: fileMan


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
        updateMon(mainView.mon1Chart, mon1ChartData);
        updateMon(mainView.mon2Chart, mon2ChartData);

        mainView.mon1Label = "Monitor 1: " + calculateAvgOverLastTenPoints(mon1ChartData);
        mainView.mon2Label = "Monitor 2: " + calculateAvgOverLastTenPoints(mon2ChartData);
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
            gen2Data.push((i / 10) ** 2);
        }
    }

    function nextStep() {
        for (let i = 0; i < 10; i++) {
            let ind = curIndex % 100;

            gen1Data.shift();
            gen2Data.shift();

            gen1Data.push(ind);
            gen2Data.push((ind / 10) ** 2)

            curIndex++
        }

        if (!runTimer) {
            for (var mon1Data in gen1Data) {
                mainView.mon1Chart.append(mainView.mon1Chart.count, mon1Data)
            }

            for (var mon2Data in gen2Data) {
                mainView.mon2Chart.append(mainView.mon2Chart.count, mon2Data);
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

    FileManager {
        id: fileMan

        Component.onCompleted: {
            fileMan.getSavedFiles();
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: rootView
    }

    Rectangle {
        id: rootView
        Layout.fillHeight: true
        Layout.fillWidth: true

        SwipeView {
            id: mainSwipeView

            currentIndex: 0
            anchors.fill: parent

            MainView {
                id: mainView
                mon1Label: "Monitor 1: "
                mon2Label: "Monitor 2: "
            }

            Item {

            }
        }

        PageIndicator {
            id: mainSwipeViewIndicator

            count: mainSwipeView.count
            currentIndex: mainSwipeView.currentIndex

            anchors.bottom: mainSwipeView.bottom
            anchors.horizontalCenter: mainSwipeView.horizontalCenter
        }
    }
}


