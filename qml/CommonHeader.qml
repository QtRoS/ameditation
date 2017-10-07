import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

Pane {
    width: parent.width
    height: 80
    Material.elevation: 4
    Material.background: Material.LightGreen

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Image {
            source: Qt.resolvedUrl("file:/home/mrqtros/Downloads/x8PhM.png")
            sourceSize {
                width: 70
                height: 70
            }

            MouseArea {
                anchors.fill: parent
                onClicked: stackView.pop()
            }
        }

        Column {
            Label {
                text: qsTr("Antonov Alexander")
                Material.foreground: "white" //Material.LightGreen
                font.pointSize: 10
                Rectangle {
                    color: "#00ff0000"
                    anchors.fill: parent
                }
            }

            Label {
                text: qsTr("MEDITATIONS 3")
                Material.foreground: "white" //Material.LightGreen
                font.pointSize: 14
                elide: Text.ElideRight
                Rectangle {
                    color: "#00ff0000"
                    anchors.fill: parent
                }
            }

            Label {
                text: qsTr("Psychologist - psychotherapist")
                Material.foreground: "white" //Material.LightGreen
                font.pointSize: 10
                elide: Text.ElideRight
                Rectangle {
                    color: "#00ff0000"
                    anchors.fill: parent
                }
            }
        }
    }
}
