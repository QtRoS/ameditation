import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import AMeditation.CppUtils 1.0
import "jsmodule.js" as JS

Page {

    property var downloadModel: transferManager.transferModel

    Component.onCompleted: transferManager.refresh()
    property bool listRequestInProgress: true

    ListView {
        anchors {
            fill: parent
            margins: 15
        }
        model: downloadModel

        delegate: CommonListItem {
            extendedMode: true
            height: 120
            iconSource: model.icon
            iconColor: model.color
            title: model.title
            titleColor: model.color
            subtitle: model.subtitle

            onClicked: {
                dialog.text = model.description
                dialog.title = model.title
                dialog.open()
            }

            Row {
                id: buttonsRow

                spacing: 15
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 5
                    right: parent.right
                    rightMargin: 5
                }

                Button {
                    flat: true
                    text: (model.status === JS.STATUS_INPROGRESS || model.status === JS.STATUS_REQUESTED) ? "Отмена" : "Скачать"
                    Material.foreground: "#424242"
                    enabled: model.status !== JS.STATUS_FINISHED // && model.status !== JS.STATUS_REQUESTED
                    onClicked: {
                        if (model.status === JS.STATUS_INPROGRESS || model.status === JS.STATUS_REQUESTED)
                            transferManager.stop(model.index)
                        else
                            transferManager.start(model.index)
                    }
                }

                Button {
                    property bool warnState: false

                    flat: !warnState
                    text: warnState ? "Удалить?" : "Удалить"
                    Material.foreground: warnState ? Material.Red : "#424242"
                    enabled: model.status === JS.STATUS_FINISHED
                    onClicked: {
                        if (!warnState) {
                            internalTimer.start()
                            warnState = true
                        } else {
                            transferManager.remove(model)
                            warnState = false
                        }
                    }

                    Timer {
                        id: internalTimer
                        interval: 2000
                        repeat: false
                        running: false
                        onTriggered: parent.warnState = false
                    }
                }
            }

            Label {
                Material.foreground: Material.Grey
                font.pixelSize: 11
                text: "Качество: %1\nРазмер: %2".arg(model.quality).arg(model.size)

                //text: "Качество: %1, %2".arg(model.quality).arg(model.size)
                //horizontalAlignment: Text.AlignHCenter

                anchors {
                    left: parent.left
                    leftMargin: 10
                    //bottom: parent.bottom
                    //bottomMargin: 10
                    verticalCenter: buttonsRow.verticalCenter
                }
            }

            ProgressBar {
                from: 0
                to: model.total
                value: model.current
                visible: model.status === JS.STATUS_INPROGRESS || model.status === JS.STATUS_REQUESTED
                indeterminate: model.status === JS.STATUS_REQUESTED
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 6
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }

    Dialog {
        id: dialog
        property alias text: internalLabel.text
        modal: true
        standardButtons: Dialog.Ok
        title: "Детали"

        contentItem: Rectangle {
            //color: "lightskyblue"
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


    BusyIndicator {
        z: 10
        anchors.centerIn: parent
        running: transferManager.theTask
    }
}
