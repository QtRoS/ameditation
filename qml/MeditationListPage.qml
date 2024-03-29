import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import "jsmodule.js" as JS

Page {

    Component.onCompleted: {
        var extendedMeditations = transferManager.getExtendedMeditations()
        meditationModelExtended.append(extendedMeditations)
    }

    ListView {
        anchors {
            fill: parent
            margins: 15
        }

        model: MeditationModel {
            id: meditationModelExtended
        }

        delegate: CommonListItem {
            extendedMode: true
            height: 108
            iconSource: model.icon
            iconColor: model.color
            title: model.title
            titleColor: model.color
            subtitle: model.subtitle

            onClicked: {
                var params = {"meditId": model.meditation, "meditLocalUrl": model.localUrl, "meditDesc": model.description, "meditTitle": model.title,
                    "meditColor": model.color, "meditQuality": model.quality, "meditIsBuiltIn": model.isBuiltIn}
                stackView.push(Qt.resolvedUrl("qrc:/qml/MeditationPage.qml"), params)
            }

            Label {
                Material.foreground: Material.Grey
                font.pixelSize: 11
                text: "Качество: %1, длительность: %2".arg(model.quality).arg(JS.decorateTime(model.duration))

                anchors {
                    left: parent.left
                    leftMargin: 10
                    bottom: parent.bottom
                    bottomMargin: 15
                }
            }
        }
    }
}
