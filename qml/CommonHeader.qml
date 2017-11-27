import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

Pane {
    property color customColor: "#ffffff" // Use color from options when white is set.

    width: parent.width
    height: 80
    Material.elevation: 4
    Material.background: customColor == "#ffffff" ? Material.Amber : customColor

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Image {
            source: Qt.resolvedUrl("qrc:/img/photo.png")
            sourceSize {
                width: 140
                height: 140
            }
            width: 70
            height: 70

            MouseArea {
                anchors.fill: parent
                onClicked: stackView.pop()
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            Label {
                text: qsTr("Антонов Александр")
                Material.foreground: "white" //optionsKeeper.contrastColor
                font.pixelSize: 12
                Rectangle {
                    color: "#00ff0000"
                    anchors.fill: parent
                }
            }

            Label {
                text: qsTr("МЕДИТАЦИИ 3")
                Material.foreground: "white" //optionsKeeper.contrastColor
                font.pixelSize: 18
                elide: Text.ElideRight
                Rectangle {
                    color: "#00ff0000"
                    anchors.fill: parent
                }
            }

            Label {
                text: qsTr("Психолог - психотерапевт")
                Material.foreground: "white" //optionsKeeper.contrastColor
                font.pixelSize: 12
                elide: Text.ElideRight
                Rectangle {
                    color: "#00ff0000"
                    anchors.fill: parent
                }
            }
        }
    }
}
