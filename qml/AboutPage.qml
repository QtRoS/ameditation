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
                    text: qsTr("Антонов Александр")
                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.foreground: Material.Amber
                    font.pointSize: 14
                    elide: Text.ElideRight
                }

                Label {
                    text: "<b>Профессиональный психолог и психотерапевт</b>"
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    Material.foreground:Material.Grey
                }

                Label {
                    text: "<p>Я, на сегодняшний день, обладаю богатым опытом психологической и психотерапевтической работы \
(с 2006 года). Долгое время моя практика индивидуальных консультаций и групповых занятий охватывала \
разные города России. В течение 6 лет клиенты в 13 городах и прилегающих к ним областях обращались ко мне для получения профессиональной помощи.</p><br>\
<p>На сегодняшний день очный прием я веду только в Санкт-Петербурге. В других городах России, а так же Европы и ближайшего зарубежья, с появившейся возможностью \
онлайн консультирования, провожу консультации по видеосвязи. Этот вид консультирования оказывается достойной альтернативой, имеющей лишь малые ограничения, по сравнению с очной встречей.</p><br>\
<p>В своей работе я активно использую различные методы: гипноз, медитации, \
дыхательные практики, НЛП, техники саморегуляции и другие. Подробную информацию обо мне и \
контакты для записи на прием ищите на моем личном сайте: \
<a href='http://antonovpsy.ru/' target='_blank'>сайт психолога</a></p><br>\
<p>По просьбам желающих оставляю ниже ссылку на страницу с пожертвованиями (благодарностями) автору проекта: \
<a href='http://antonovpsy.ru/donate.php' target='_blank'>БЛАГОДАРНОСТЬ АВТОРУ</a></p><br>"
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignJustify
                    Material.foreground:Material.Grey
                    onLinkActivated: Qt.openUrlExternally(link)
                }

                Label {
                    text: qsTr("Роман Щекин")
                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.foreground: Material.Amber
                    font.pointSize: 14
                    elide: Text.ElideRight
                }

                Label {
                    text: "<b>Разработчик программного обеспечения</b>"
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    Material.foreground:Material.Grey
                }

                Label {
                    text: "<p>Я присоединился к разработке приложения после того, как сам воспользовался им впервые, оказавшись в непростой жизненной ситуации. \
В приложении был и остается поистине уникальный контент, однако в плане удобства пользования было куда расти. Мобильная разработка не мой основной профиль, \
однако определенный опыт создания приложений все же был, поэтому я предложил Александру полностью переписать приложение. Улучшенная и обновленная версия сейчас перед Вами.</p><br>
По всем вопросам и пожеланиям Вы всегда можете связаться со мной по адресу (<a href='mailto:qtros@yandex.ru'>qtros@yandex.ru</a>) или найдя меня как @<b>QtRoS</b>"
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
