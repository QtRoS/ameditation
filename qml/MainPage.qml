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
            id: mainButton
            anchors {
                left: parent.left
                right: parent.right
            }
            height: 120
            Material.background: "white"
            onClicked: stackView.push(Qt.resolvedUrl("qrc:/qml/MeditationListPage.qml"))

            Column {
                id: btnLayout
                spacing: 10
                anchors.centerIn: parent

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: (mainButton.width - 4 * 50) / 6
                    Repeater {
                        model: 4

                        Image {
                            source: Qt.resolvedUrl("file:/home/mrqtros/Downloads/x8PhM.png")
                            width: 50
                            height: 50
                        }
                    }
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
