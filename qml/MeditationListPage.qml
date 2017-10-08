import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

Page {
    ListView {
        anchors {
            fill: parent
            margins: 15
        }
        model: meditationModel

        delegate: CommonListItem {
            iconSource: model.icon
            title: model.title
            subtitle: model.subtitle

            onClicked: stackView.push(Qt.resolvedUrl("qrc:/qml/MeditationPage.qml"), {"meditationId": model.meditation, "meditationTitle": model.title})
        }
    }

    ListModel {
        id: meditationModel

        ListElement {
            icon: "file:/home/mrqtros/Downloads/x8PhM.png"
            title: "Relax"
            subtitle: "Bla bla bla"
            meditation: "1"
        }

        ListElement {
            icon: "file:/home/mrqtros/Downloads/x8PhM.png"
            title: "Power"
            subtitle: "About author description"
            meditation: "2"
        }

        ListElement {
            icon: "file:/home/mrqtros/Downloads/x8PhM.png"
            title: "Love"
            subtitle: "Sign up description"
            meditation: "3"
        }

        ListElement {
            icon: "file:/home/mrqtros/Downloads/x8PhM.png"
            title: "Mood"
            subtitle: "Sign up description"
            meditation: "4"
        }
    }
}
