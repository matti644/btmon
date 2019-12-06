import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Item {
    property var mon1
    property var mon2
    property StackView stackView

    function getMon1(i) {
        return mon1[i];
    }

    function getMon2(i) {
        return mon2[i];
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
                    text: "Snapshot"
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
                model: mon1.length

                delegate: RowLayout {
                    width: parent.width;
                    height: 30

                    Rectangle {
                        Layout.preferredWidth: 0.5 * parent.width

                        Text {
                            text: getMon1(index)
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 0.5 * parent.width

                        Text {
                            text: getMon2(index)
                        }
                    }
                }
            }
        }
    }
}
