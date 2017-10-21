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
                    text: qsTr("Инструкции")
                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.foreground: optionsKeeper.accentColor
                    font.pointSize: 14
                    elide: Text.ElideRight
                }

                Label {
                    text: "Для прослушивания медитаций предпочтительно использовать наушники. \
Выберите медитацию из списка. Обязательно прочтите аннотацию. Включите запись. \
Когда услышите голос, настройте громкость кнопками вашего устройства. Позаботьтесь о том, \
чтобы вас ничто не отвлекало, во время прослушивания. Если вам покажется, что вы \
уснули и какое-то время не слышали мой голос, не волнуйтесь - все в порядке. Это говорит \
о высокой степени расслабления, что хорошо, вне сомнений. \
<font color='red'>Запрещено прослушивать медитации во время ответственной \
деятельности: вождение автомобиля, работа на сложном оборудовании и т.п. </font>\
Позаботьтесь о себе и уделите для медитации отдельное время."
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignJustify
                    Material.foreground:Material.Grey
                    //textFormat: Text.PlainText
                }
            }
        }
    }
}
