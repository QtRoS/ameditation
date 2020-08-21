import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

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
                    Material.foreground: Material.Grey
                    font.pixelSize: 12
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }
        }

        delegate: CommonListItem {
            iconSource: model.icon
            iconColor: model.color
            title: model.title
            subtitle: model.subtitle

            onClicked: stackView.push(Qt.resolvedUrl(model.page))

            UpdatesMarker { visible: model.updatesPossible && transferManager.hasUnseen }
        }
    }

    ListModel {
        id: mainPageModel

        ListElement {
            icon: "qrc:/img/settings-wheel.png"
            color: "#E91E63" // 2196F3
            title: "Загрузка медитаций"
            subtitle: "Добавление новых медитаций в дополнение к основным"
            page: "qrc:/qml/DownloadPage.qml"
            updatesPossible: true
        }

        ListElement {
            icon: "qrc:/img/dotted-list.png"
            color: "lightgrey"
            title: "Инструкции"
            subtitle: "Настоятельно рекомендуется прочесть перед использованием"
            page: "qrc:/qml/InstructionPage.qml"
            updatesPossible: false
        }

        ListElement {
            icon: "qrc:/img/increase-font-size.png"
            color: "lightgrey"
            title: "Об авторах"
            subtitle: "Информация об авторах приложения"
            page: "qrc:/qml/AboutPage.qml"
            updatesPossible: false
        }

        ListElement {
            icon: "qrc:/img/complete.png"
            color: "lightgrey"
            title: "Записаться на прием"
            subtitle: "Информация по поводу записи на прием"
            page: "qrc:/qml/SignUpPage.qml"
            updatesPossible: false
        }
    }
}
