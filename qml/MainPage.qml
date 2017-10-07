import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

Page {
    id: mainpage

    ListView {
        anchors {
            fill: parent
            margins: 15
        }
        model: mainPageModel

        header: Button {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: 160
            Material.background: "transparent" //Material.LightGreen
            onClicked: stackView.push(Qt.resolvedUrl("qrc:/qml/MeditationListPage.qml"))

            Column {
                id: btnLayout
                anchors.centerIn: parent

                Image {
                    source: Qt.resolvedUrl("file:/home/mrqtros/Downloads/x8PhM.png")
                    width: 70
                    height: 70
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    text: qsTr("Meditations")
                    font.pointSize: 14
                    Material.foreground: Material.LightGreen
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        delegate: CommonListItem {
            iconSource: model.icon
            title: model.title
            subtitle: model.subtitle

            onClicked: stackView.push(Qt.resolvedUrl(model.page))
        }
    }

    ListModel {
        id: mainPageModel

        ListElement {
            icon: "file:/home/mrqtros/Downloads/x8PhM.png"
            title: "Instruction"
            subtitle: "Bla bla bla"
            page: "qrc:/qml/InstructionPage.qml"
        }

        ListElement {
            icon: "file:/home/mrqtros/Downloads/x8PhM.png"
            title: "About author"
            subtitle: "About author description"
            page: "qrc:/qml/AboutPage.qml"
        }

        ListElement {
            icon: "file:/home/mrqtros/Downloads/x8PhM.png"
            title: "Sign up"
            subtitle: "Sign up description"
            page: "qrc:/qml/SignUpPage.qml"
        }
    }
}
