import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

import "databasemodule.js" as DB

Page {

    Component.onCompleted: {

        // TODO make web request
        var webItems = [
            {
                "title": "M1",
                "subtitle": "Some extra medit 1",
                "description": "Bla bla",
                "icon": "",
                "meditation": "m1",
                "url": "http://localhost:80/m1.mp3"
            },
            {
                "title": "M2",
                "subtitle": "Some extra medit 2",
                "description": "Xxxxx sa dddddd",
                "icon": "",
                "meditation": "m2",
                "url": "http://localhost:80/m2.mp3"
            }
        ]

        DB.syncMeditations(webItems)
        var syncedItems = DB.getMeditations()

        var itemsToDisplay = []
        for (var i = 0; i < syncedItems.rows.length; i++) {
            var syncedItem = syncedItems.rows.item(i)

            var artObj = {
                "title": syncedItem.title,
                "subtitle": syncedItem.subtitle,
                "description": syncedItem.description,
                "icon": syncedItem.icon,
                "meditation": syncedItem.meditation,
                "url": syncedItem.url,
                "status": syncedItem.status,
                "progress": 0.0
            }

            itemsToDisplay.push(artObj)
        }

        console.log("itemsToDisplay", itemsToDisplay)
        downloadModel.append(itemsToDisplay)
    }

    property bool listRequestInProgress: true

    ListView {
        anchors {
            fill: parent
            margins: 15
        }
        model: downloadModel

        delegate: CommonListItem {
            extendedMode: true
            iconSource: "qrc:/img/my1.png"
//            iconColor: model.color
            title: model.title
//            titleColor: model.color
            subtitle: model.subtitle

            onClicked: console.log('CLICKED')


            Row {
                spacing: 15
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 10
                    right: parent.right
                    rightMargin: 10
                }

                Button {
                    text: model.status === "PENDING" ? "Отмена" : "Скачать" // TODO delete
                    flat: true
                    enabled: model.status === "PENDING" || model.status === "NEW"
                    onPressed: {
                        console.log("model.status", model.status)
                        model.status = model.status === "NEW" ? "PENDING" : "NEW"
                    }
                }

                Button {
                    text: "Детали"
                    flat: true
                }
            }

            ProgressBar {
                from: 0
                to: 100
                value: 50 // TODO From model
                visible:  model.status === "PENDING"
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 6
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }

    ListModel {
        id: downloadModel
    }

    BusyIndicator {
        z: 10
        anchors.centerIn: parent
        running: listRequestInProgress
    }
}
