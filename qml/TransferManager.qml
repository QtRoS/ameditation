import QtQuick 2.4
import AMeditation.CppUtils 1.0

import "jsmodule.js" as JS
import "databasemodule.js" as DB

Item {
    id: transferManagerRoot

    property ListModel transferModel: ListModel { }
    property var theTask: null

    function refresh() {
        if (transferModel.count > 0)
            return

//      theTask = webApi.getWebMeditations()

        // TODO TMP vvvv
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

        handleWebItems(webItems)
        // TODO TMP ^^^^
    }

    function handleWebItems(webItems) { // TODO rename handleResponse

        theTask = null

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

    // Utility functions
    function remove(cd) {
        CppUtils.removeFile(cd.localUrl)
        cd.status = JS.STATUS_INITIAL
        DB.updateMeditation(cd.meditation, cd.status, cd.localUrl)
    }

    function getExtendedMeditations() {
        var dbItems = DB.getFinishedMeditations()

        var itemsToDisplay = []
        for (var i = 0; i < dbItems.rows.length; i++) {
            var dbItem = dbItems.rows.item(i)

            var obj = {
                "title": dbItem.title,
                "subtitle": dbItem.subtitle,
                "description": dbItem.description,
                "icon": dbItem.icon,
                "meditation": dbItem.meditation,
                "color": dbItem.color,
                "isBuiltIn": false,
                "localUrl" : dbItem.localUrl
            }

            itemsToDisplay.push(obj)
        }

        return itemsToDisplay
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

            return null
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

    QtObject {
        id: webApi

        /*
            This signal emitted when result is received.
            # resObj
                @ task
                    @ code
                    @ doc
                    @ id
                @ response
                    !status
                    !statusText
                !isError
            # code
         */
        signal responseReceived(var resObj, string code)
        readonly property bool requestLogEnabled: true

        function getWebMeditations() {
            var baseUrl = "https://cloud-api.yandex.net/v1/disk/" // TODO url
            return __makeRequest(baseUrl, "getWebMeditations")
        }

        /* Private */
        function __makeRequest(request, code, method) {
            method = method || "GET"

            if (requestLogEnabled)
                console.log("__makeRequest", request, code, method)

            var doc = new XMLHttpRequest()
            var task = {"code" : code, "doc" : doc, "id" : __requestIdCounter++,
                "setMeta" : function(key, meta) { this[key] = meta; return this; }}

            doc.onreadystatechange = function() {
                if (doc.readyState === XMLHttpRequest.DONE) {

                    var resObj = { "task" : task, "isError": false}

                    if (doc.status != 200 && doc.status != 201 && doc.status != 202 && doc.status != 204  ) {
                        resObj.isError = true
                        resObj.response = { "statusText" : doc.statusText, "status" : doc.status}
                    } else {
                        var parsedResponse = {}
                        try {
                            parsedResponse = JSON.parse(__preProcessData(code, doc.responseText))
                        } catch (e) { }
                        if (parsedResponse.error) {
                            resObj.isError = true
                        }
                        resObj.response = parsedResponse
                    }

                    __emitSignal(resObj, code)
                }
            }

            doc.open(method, request, true)
            //doc.setRequestHeader("Authorization", "OAuth " + accessToken)
            doc.send()

            return task
        }

        function __preProcessData(code, data) {
            return data
        }

        function __emitSignal(resObj, operationCode) {
            responseReceived(resObj, operationCode)
        }

        property int __requestIdCounter: 0
    } // API

    Connections {
        target: webApi

        onResponseReceived: {
            //var r = resObj.response
            //handleWebItems(webItems)
            //OR
            //handleResponse(resObj)
        }
    }
}
