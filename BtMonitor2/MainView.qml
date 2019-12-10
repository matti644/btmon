import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.3
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Item {
    property string mon1Label
    property string mon2Label

    // Expose both charts
    property var mon1Chart: lsMon1
    property var mon2Chart: lsMon2

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ColumnLayout {
            id: textCont
            Layout.preferredHeight: 0.25 * parent.height;
            Layout.leftMargin: 10

            RowLayout {
                Rectangle {
                    height: 20
                    width: 20

                    color: "red"
                    border.color: "black"
                    border.width: 1
                }

                Text {
                    id: mon1Text
                    text: mon1Label
                }
            }

            RowLayout {
                Rectangle {
                    height: 20
                    width: 20

                    color: "blue"
                    border.color: "black"
                    border.width: 1
                }

                Text {
                    id: mon2Text
                    text: mon2Label
                }
            }
            RowLayout{
                Button {
                    text: "Snapshot"
                    onClicked: {
                        app.stackView.push("SnapShotView.qml", {mon1: app.mon1ChartData, mon2: app.mon2ChartData, stackView: app.stackView, fileMan: app.fileMan});
                        //app.stackView.push({item: "SnapShotView.qml", properties: {mon1: app.mon1ChartData, mon2: app.mon2ChartData, stackView: app.stackView}})
                    }
                }

                Button {
                    text: "Saved"
                    onClicked: {
                        app.stackView.push("FileView.qml", {file: app.fileMan.getSavedFiles(), stackView: app.stackView, manager: app.fileMan});
                    }
                }

                Button {
                    text: "Save"
                    onClicked: {
                        fileMan.save(mon1ChartData, mon2ChartData);
                    }
                }
            }
        }

        Rectangle {
            id: chartCont
            Layout.preferredHeight: 0.75 * parent.height;
            Layout.fillWidth: true

            ChartView {
                id: chart
                anchors.fill: parent
                antialiasing: true
                legend.visible: false

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

                LineSeries {
                    id: lsMon1

                    name: "Monitor 1"
                    axisX: axisX
                    axisY: axisY
                    useOpenGL: true

                    color: "red"
                }

                LineSeries {
                    id: lsMon2

                    name: "Monitor 2"
                    axisX: axisX
                    axisY: axisY
                    useOpenGL: true

                    color: "blue"
                }
            }
        }
    }
}
