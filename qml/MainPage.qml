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
            height: btnLayout.height + 30
            Material.background: "white" //optionsKeeper.contrastColor
            onClicked: stackView.push(Qt.resolvedUrl("qrc:/qml/MeditationListPage.qml"))

            Column {
                id: btnLayout
                spacing: 10
                anchors {
                    top: parent.top
                    topMargin: 15
                    left: parent.left
                    right: parent.right
                    margins: 10
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: (mainButton.width - 4 * 50) / 6
                    Repeater {
                        model: meditationModel

                        RoundedIcon {
                            source: Qt.resolvedUrl("qrc:/img/my%1.png".arg(model.index))
                            color: model.color
                            width: 50
                            height: 50
                        }
                    }
                }

                Label {
                    text: qsTr("Медитации")
                    font.pointSize: 14
                    Material.foreground: optionsKeeper.accentColor
                    color: "dimgrey"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    text: "В данном разделе Вы можете ознакомиться со списком медитаций, чтобы затем выбрать себе подходящую"
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    horizontalAlignment: Text.AlignHCenter
                    Material.foreground:Material.Grey
                    font.pointSize: 11
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }
        }

        delegate: CommonListItem {
            iconSource: model.icon
            iconColor: "lightgrey"
            title: model.title
            subtitle: model.subtitle

            onClicked: stackView.push(Qt.resolvedUrl(model.page))
        }
    }

    ListModel {
        id: mainPageModel

        ListElement {
            icon: "qrc:/img/dotted-list.png"
            title: "Инструкции"
            subtitle: "Настоятельно рекомендуется прочесть перед использованием"
            page: "qrc:/qml/InstructionPage.qml"
        }

        ListElement {
            icon: "qrc:/img/increase-font-size.png"
            title: "Об авторе"
            subtitle: "Информация об авторе методик"
            page: "qrc:/qml/AboutPage.qml"
        }

        ListElement {
            icon: "qrc:/img/complete.png"
            title: "Записаться на прием"
            subtitle: "Информация по поводу записи на прием"
            page: "qrc:/qml/SignUpPage.qml"
        }
    }
}
