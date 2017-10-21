import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

Button {

    property alias iconSource: imgIcon.source
    property alias iconColor: imgIcon.color
    property alias title: lblTitle.text
    property alias titleColor: lblTitle.color
    property alias subtitle: lblSubtitle.text

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
        }

        Label {
            id: lblTitle
            width: parent.width
            color: "dimgrey"
            Material.foreground: optionsKeeper.accentColor
            font.pointSize: 14
            elide: Text.ElideRight
            Rectangle { // DBG
                color: "#00ff0000"
                anchors.fill: parent
            }
        }

        Label {
            id: lblSubtitle
            width: parent.width
            //Material.foreground: optionsKeeper.accentColor
            Material.foreground:Material.Grey
            font.pointSize: 11
            elide: Text.ElideRight
            Rectangle { // DBG
                color: "#00ff0000"
                anchors.fill: parent
            }
        }
    }
}
