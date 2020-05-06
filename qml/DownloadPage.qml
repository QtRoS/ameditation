import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

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
            iconSource: model.icon
            iconColor: model.color
            title: model.title // + ' ' + model.status
            titleColor: model.color
            subtitle: model.subtitle

            onClicked: {
                dialog.text = model.description
                dialog.title = model.title
                dialog.open()
            }

            Row {
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
