import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Dialog {
    //id: infoDialogInternal
    property alias text: internalLabel.text
    modal: true
    clip: true
    standardButtons: Dialog.Ok

    contentItem: Rectangle {
        implicitWidth: 400
        implicitHeight: 640
        Label {
            id: internalLabel
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignJustify
            Material.foreground:Material.Grey
        }
    }
}
