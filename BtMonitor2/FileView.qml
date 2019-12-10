import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import FileManager 1.0

Item {
    property var file
    property StackView stackView
    property FileManager manager

    function getFile(i) {
        return file[i];
    }

    Page {
        anchors.fill: parent

        header: ToolBar {
            RowLayout {
                ToolButton {
                    text: "<"
                    onClicked: stackView.pop()
                }
                Label {
                    text: "Saved files"
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }
            }
        }

        ScrollView {
            width: parent.width
            height: parent.height
            clip: true

            ListView {
                model: file.length

                delegate: RowLayout {
                    width: parent.width;
                    height: 30


                    Rectangle {
                        Layout.preferredWidth: parent.width

                        Text {
                            id:textElement
                            text: getFile(index)

                            MouseArea{
                                anchors.fill: parent;
                                //onClicked: console.log(manager.load(index, 0));
                                onClicked: stackView.push("SnapShotView.qml", {mon1: manager.load(index, 0), mon2: manager.load(index, 1), stackView: stackView});
                            }
                        }
                    }
                }
            }
        }
    }
}
