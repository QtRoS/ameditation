import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

Pane {
    property color customColor: "#ffffff" // Use color from options when white is set.

    width: parent.width
    height: 80
    Material.elevation: 4
    Material.background: customColor == "#ffffff" ? optionsKeeper.accentColor : customColor

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
                text: qsTr("Антонов Александр")
                Material.foreground: optionsKeeper.contrastColor
                font.pointSize: 10
                Rectangle {
                    color: "#00ff0000"
                    anchors.fill: parent
                }
            }

            Label {
                text: qsTr("МЕДИТАЦИИ 3")
                Material.foreground: optionsKeeper.contrastColor
                font.pointSize: 14
                elide: Text.ElideRight
                Rectangle {
                    color: "#00ff0000"
                    anchors.fill: parent
                }
            }

            Label {
                text: qsTr("Психолог - психотерапевт")
                Material.foreground: optionsKeeper.contrastColor
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
