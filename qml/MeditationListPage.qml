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
            iconColor: model.color
            title: model.title
            titleColor: model.color
            subtitle: model.subtitle

            onClicked: stackView.push(Qt.resolvedUrl("qrc:/qml/MeditationPage.qml"),
                                      {"modelIndex": model.index}) // , "meditationTitle": model.title, "meditationDetails": model.description
        }
    }
}
