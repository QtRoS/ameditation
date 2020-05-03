import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

import AMeditation.CppUtils 1.0
import "databasemodule.js" as DB
import "jsmodule.js" as JS

Page {

    property var downloadModel: transferManager.transferModel

    Component.onCompleted: {

        // TODO make web request
        var webItems = [
            {
                "title": "Транс - мотивация",
                "subtitle": "Позволяет получить отдых и расслабление, а так же укрепить мотивацию для достижения целей",
                "description": "Предлагаю вашему вниманию транс (медитацию), который вы можете слушать раз в два, три дня. Он будет полезен каждому, поскольку позволяет получить отдых и расслабление, а так же укрепить мотивацию для достижения целей. В результате прослушивания этого транса (медитации), вы сможете получить эффект глубокого физического и эмоционального расслабления, который сравним с тремя - четырьмя часами ночного сна.",
                "icon": "",
                "meditation": "trans_motivation",
                "url": "http://antonovpsy.ru//trans/mp3/trans_motivation.mp3"
            }
            ,{
                "title": "Медитативный настрой",
                "subtitle": "Всего лишь 20 минут, проведённых в спокойной обстановке и прослушивание данного настроя дадут возможность получить отдых, зарядиться ресурсом как после 2-3 часового дневного сна",
                "description": "Поэтому методики самовосстановления (трансы и медитации), которые можно отнести к психогигиене, становятся очень востребованными. Всего лишь 20 минут, проведённых в спокойной обстановке и прослушивание данного настроя дадут возможность получить отдых, зарядиться ресурсом как после 2-3 часового дневного сна. Кроме того, данные образы обладают выраженным лечебным эффектом, что очень рекомендовано применять пациентам с хроническими заболеваниями. Для эффективного прослушивания позаботьтесь о том, чтобы вам никто не мешал. Найдите удобное место, устройтесь поудобнее и включите аудиозапись. Лучше всего это сделать через наушники.",
                "icon": "",
                "meditation": "med_mood",
                "url": "http://www.psy-syzran.ru/audio/audio.mp3"
            }
        ]

        DB.syncMeditations(webItems)
        var syncedItems = DB.getMeditations()

        var itemsToDisplay = []
        for (var i = 0; i < syncedItems.rows.length; i++) {
            var syncedItem = syncedItems.rows.item(i)

            var artObj = {
                "title": syncedItem.title,
                "subtitle": syncedItem.subtitle,
                "description": syncedItem.description,
                "icon": syncedItem.icon,
                "meditation": syncedItem.meditation,
                "url": syncedItem.url,

                "status": JS.STATUS_INITIAL,
                "localUrl" : "",
                "current" : 0,
                "total" : 0
            }

            itemsToDisplay.push(artObj)
        }

        console.log("itemsToDisplay", JSON.stringify(itemsToDisplay))
        downloadModel.append(itemsToDisplay)
    }

    property bool listRequestInProgress: true

    ListView {
        anchors {
            fill: parent
            margins: 15
        }
        model: downloadModel

        delegate: CommonListItem {
            extendedMode: true
            iconSource: "qrc:/img/my1.png"
//            iconColor: model.color
            title: model.title + ' ' + model.status
//            titleColor: model.color
            subtitle: model.subtitle

            Row {
                spacing: 15
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 10
                    right: parent.right
                    rightMargin: 10
                }

                Button {
                    text: (model.status === JS.STATUS_INPROGRESS || model.status === JS.STATUS_REQUESTED) ? "Отмена" : "Скачать" // TODO delete
                    flat: true
                    enabled: model.status !== JS.STATUS_FINISHED // && model.status !== JS.STATUS_REQUESTED
                    onPressed: {
                        if (model.status === JS.STATUS_INPROGRESS || model.status === JS.STATUS_REQUESTED)
                            transferManager.stop(model.index)
                        else
                            transferManager.start(model.index)
                    }
                }

                Button {
                    text: "Детали"
                    flat: true
                }
            }

            ProgressBar {
                from: 0
                to: model.total
                value: model.current
                visible: model.status === JS.STATUS_INPROGRESS || model.status === JS.STATUS_REQUESTED
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 6
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }


//    BusyIndicator {
//        z: 10
//        anchors.centerIn: parent
//        running: listRequestInProgress
//    }
}
