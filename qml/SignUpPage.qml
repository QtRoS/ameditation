import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

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
                    text: qsTr("Записться на прием")
                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.foreground: Material.Amber
                    font.pointSize: 14
                    elide: Text.ElideRight
                }

                Label {
                    text: "<p>Запись на индивидуальный прием к Антонову Александру возможна в \
разных городах России. Я предлагаю психологическую помощь по следующим направлениям:</p><br>\
<ul>\
<li>решение жизненных трудностей</li>\
<li>нормализация отношений</li>\
<li>сексуальные затруднения</li>\
<li>личностный рост</li>\
<li>эмоциональные проблемы (депрессия, вина и т.п.)</li>\
<li>и другим...</li>\
</ul>\

<p>Запишитесь через контакты на моем сайте: \
<a href='http://antonovpsy.ru/' target='_blank'>сайт психолога</a> или форму онлайн записи: \
<a href='http://antonovpsy.ru/zapis_na_priem/' target='_blank'>форма онлайн записи</a>.</p>"
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignJustify
                    Material.foreground:Material.Grey
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }
    }
}

