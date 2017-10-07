import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

Button {

    property alias iconSource: imgIcon.source
    property alias title: lblTitle.text
    property alias subtitle: lblSubtitle.text

    anchors {
        left: parent.left
        right: parent.right
    }
    height: 80
    Material.background: "transparent"

    // Rectangle { color: "red"; anchors.fill: parent }
    Rectangle { color: "transparent"; anchors.fill: parent; border.width: 1; border.color: "red" }

    Row {
        spacing: 10
        anchors.fill: parent
        Layout.maximumHeight: imgIcon.height

        Image {
            id: imgIcon
            Layout.rowSpan: 2
            anchors.verticalCenter: parent.verticalCenter
            width: 60
            height: 60

//            Rectangle { color: "red"; anchors.fill: parent }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            Label {
                id: lblTitle
    //            Material.foreground: "white"
                Material.foreground: Material.LightGreen
                font.pointSize: 14
                elide: Text.ElideRight
                Rectangle {
                    color: "#00ff0000"
                    anchors.fill: parent
                }
            }

            Label {
                id: lblSubtitle
    //            Material.foreground: "white"
                Material.foreground: Material.LightGreen
                font.pointSize: 11
                elide: Text.ElideRight
                Rectangle {
                    color: "#00ff0000"
                    anchors.fill: parent
                }
            }
        }
    }
}
