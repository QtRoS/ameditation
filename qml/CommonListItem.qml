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

//    Rectangle { color: "transparent"; anchors.fill: parent; border.width: 1; border.color: "red" }

    // TODO Remove row, use anchors.
    Row {
        id: contentRow
        spacing: 10
        anchors.fill: parent

        Image {
            id: imgIcon
            anchors.verticalCenter: parent.verticalCenter
            width: 60
            height: 60
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: contentRow.width - x

            Label {
                id: lblTitle
                width: parent.width
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
                width: parent.width
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
