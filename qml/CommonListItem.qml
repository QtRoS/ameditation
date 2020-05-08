import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Button {

    property alias iconSource: imgIcon.source
    property alias iconColor: imgIcon.color
    property alias title: lblTitle.text
    property alias titleColor: lblTitle.color
    property alias subtitle: lblSubtitle.text

    property bool extendedMode: false

    anchors {
        left: parent.left
        right: parent.right
    }

    height: 80
    Material.background: "white" //optionsKeeper.contrastColor
    Material.elevation: 2

    RoundedIcon {
        id: imgIcon
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: extendedMode ? (80 - parent.height) / 2 : 0
        }

        width: 60
        height: 60
    }

    Column {
        anchors {
            left: imgIcon.right
            leftMargin: 10
            right: parent.right
            rightMargin: 5
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: extendedMode ? (80 - parent.height) / 2 : 0
        }

        Label {
            id: lblTitle
            width: parent.width
            color: "dimgrey"
            Material.foreground: Material.Amber
            font.pixelSize: 16
            elide: Text.ElideRight
            Rectangle { // DBG
                color: "#00ff0000"
                anchors.fill: parent
            }
        }

        Label {
            id: lblSubtitle
            width: parent.width
            Material.foreground: Material.Grey
            font.pixelSize: 12
            elide: Text.ElideRight
            maximumLineCount: 2
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            Rectangle { // DBG
                color: "#00ff0000"
                anchors.fill: parent
            }
        }
    }
}
