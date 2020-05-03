import QtQuick 2.4
import AMeditation.CppUtils 1.0

import "jsmodule.js" as JS
import "databasemodule.js" as DB

Item {
    id: transferManagerRoot

    property ListModel transferModel: ListModel { }

    function refresh() {

        if (transferModel.count > 0)
            return

        // TODO make web request
        var webItems = [
            {
                "title": "Транс - мотивация",
                "subtitle": "Позволяет получить отдых и расслабление, а так же укрепить мотивацию для достижения целей",
                "description": "Предлагаю вашему вниманию транс (медитацию), который вы можете слушать раз в два, три дня. Он будет полезен каждому, поскольку позволяет получить отдых и расслабление, а так же укрепить мотивацию для достижения целей. В результате прослушивания этого транса (медитации), вы сможете получить эффект глубокого физического и эмоционального расслабления, который сравним с тремя - четырьмя часами ночного сна.",
                "icon": "qrc:/img/my0.png",
                "meditation": "trans_motivation",
                "url": "http://antonovpsy.ru//trans/mp3/trans_motivation.mp3",
                "color": "#673AB7",
            }
            ,{
                "title": "Медитативный настрой",
                "subtitle": "Всего лишь 20 минут, проведённых в спокойной обстановке и прослушивание данного настроя дадут возможность получить отдых, зарядиться ресурсом как после 2-3 часового дневного сна",
                "description": "Поэтому методики самовосстановления (трансы и медитации), которые можно отнести к психогигиене, становятся очень востребованными. Всего лишь 20 минут, проведённых в спокойной обстановке и прослушивание данного настроя дадут возможность получить отдых, зарядиться ресурсом как после 2-3 часового дневного сна. Кроме того, данные образы обладают выраженным лечебным эффектом, что очень рекомендовано применять пациентам с хроническими заболеваниями. Для эффективного прослушивания позаботьтесь о том, чтобы вам никто не мешал. Найдите удобное место, устройтесь поудобнее и включите аудиозапись. Лучше всего это сделать через наушники.",
                "icon": "qrc:/img/my1.png",
                "meditation": "med_mood",
                "url": "http://www.psy-syzran.ru/audio/audio.mp3",
                "color": "#FF5722",
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
                "color": syncedItem.color,
                "localUrl" : syncedItem.localUrl,
                "status": syncedItem.status,

                // UI only.
                "current" : 0,
                "total" : 0
            }

            itemsToDisplay.push(artObj)
        }

        console.log('itemsToDisplay', JSON.stringify(itemsToDisplay))
        transferModel.append(itemsToDisplay)
    }

    function start(i) {
        if (i >= transferModel.count)
            return

        var itm = transferModel.get(i)
        if (itm.status !== JS.STATUS_INITIAL && itm.status !== JS.STATUS_ERROR)
            return

        itm.status = JS.STATUS_REQUESTED
        console.log("---- start", JSON.stringify(itm))
        d.doDownloadStep()
    }

    function stop(i) {
        if (i >= transferModel.count)
            return

        var itm = transferModel.get(i)
        if (itm.status === JS.STATUS_INPROGRESS) {
            networkManager.abortDownload()
            itm.status = JS.STATUS_ERROR
        }
        else itm.status = JS.STATUS_INITIAL
        d.doDownloadStep()
    }

    function remove(cd) {
        CppUtils.removeFile(cd.localUrl)
        cd.status = JS.STATUS_INITIAL
        DB.updateMeditation(cd.meditation, cd.status, cd.localUrl)
    }

    property QtObject d: QtObject {

        property var currentDownload: null

        function doDownloadStep() {
            console.log("doDownloadStep enter")
            // Check if we should pick next task.
            if (!currentDownload || currentDownload.status === JS.STATUS_FINISHED || currentDownload.status === JS.STATUS_ERROR) {
                currentDownload = getNextDownload()

                // Nothing to do.
                if (!currentDownload)
                    return
            }
            console.log("doDownloadStep", JSON.stringify(currentDownload))

            switch (currentDownload.status)
            {
            case JS.STATUS_REQUESTED:
                var shortName = JS.getFileName(currentDownload.url) // TODO meditation?
                console.log("currentDownload.localUrl 1", currentDownload.localUrl)
                currentDownload.localUrl = CppUtils.prependWithDownloadsPath(shortName)
                console.log("currentDownload.localUrl 2", currentDownload.localUrl)
                var isSucces = networkManager.download(currentDownload.url, currentDownload.localUrl)
                if (!isSucces) {
                    changeDownloadStatus(JS.STATUS_ERROR)
                    return
                }
                changeDownloadStatus(JS.STATUS_INPROGRESS)
                break;
            case JS.STATUS_INPROGRESS:
                break;
            case JS.STATUS_FINISHED:
                doDownloadStep()
                break;
            case JS.STATUS_ERROR:
                break;
            }

            console.log(" -=-=-= DOWNLOAD STATUS", currentDownload.status)
        }

        function getNextDownload() {
            for (var i = 0; i < transferModel.count; i++) {
                var itm = transferModel.get(i)
                if (itm.status === JS.STATUS_REQUESTED)
                    return itm
            }

            return null // TODO CHECK
        }

        function changeDownloadStatus(status) {
            if (currentDownload) {
                currentDownload.status = status
                doDownloadStep()
            }
        }
    } // QtrObject d

    Connections {
        target: networkManager

        onDownloadOperationProgress: {
            d.currentDownload.current = current
            d.currentDownload.total = total
        }

        onDownloadOperationFinished: {
            if (status === "success") {
                var cd = d.currentDownload
                d.changeDownloadStatus(JS.STATUS_FINISHED)
                console.log("onDownloadOperationFinished updateMeditation")
                DB.updateMeditation(cd.meditation, cd.status, cd.localUrl)
            }
            else d.changeDownloadStatus(JS.STATUS_ERROR)
        }
    }
}
