import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import QtMultimedia 5.9

Page {
    Pane {
        id: mainPane

        anchors {
            fill: parent
            margins: 15
        }
        Material.elevation: 2

        Flickable {
            anchors.fill: parent
            clip: true

            contentWidth: parent.width
            contentHeight: innerItem.height

            Column {
                id: innerItem
                spacing: 5
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }

                Label {
                    text: qsTr("About")
                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.foreground: Material.LightGreen
                    font.pointSize: 14
                    elide: Text.ElideRight
                }

                Label {
                    text: "Работа с РСУБД является одной из важнейших частей разработки веб-приложений. Дискусcии о том, как правильно представить данные из БД в приложении ведутся давно. Существует два основных паттерна для работы с БД: ActiveRecord и DataMapper. ActiveRecord считается многими программистами антипаттерном. Утверждается, что объекты ActiveRecord нарушают принцип единственной обязанности (SRP). DataMapper считается единственно верным подходом к обеспечению персистентности в ООП. Первая часть статьи посвящена тому, что DataMapper далеко не идеален как концептуально, так и на практике. Вторая часть статьи показывает, как можно улучшить свой код используя существующие реализации ActiveRecord и несколько простых правил. Представленный материал относится главным образом к РСУБД, поддерживающим транзакции."
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignJustify
                    Material.foreground: Material.Grey
                    textFormat: Text.PlainText
                }
            }
        }
    }
}
