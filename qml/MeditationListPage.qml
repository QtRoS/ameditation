import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

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
            iconSource: model.icon
            iconColor: model.color
            title: model.title
            titleColor: model.color
            subtitle: model.subtitle

            onClicked: {
                var audioSource = model.isBuiltIn ? "qrc:/media/%1.mp3".arg(meditation) : "file:%1".arg(model.localUrl)
                var params = {"meditAudioSource": audioSource, "meditDesc": model.description,
                    "meditTitle": model.title, "meditColor": model.color}
                console.log("audioSource", audioSource)
                stackView.push(Qt.resolvedUrl("qrc:/qml/MeditationPage.qml"), params)
            }
        }
    }
}
