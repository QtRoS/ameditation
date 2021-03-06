import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import AMeditation.CppUtils 1.0

import "jsmodule.js" as JS
import "databasemodule.js" as DB

Item {
    id: transferManagerRoot

    property ListModel transferModel: ListModel { }
    property var theTask: null
    property bool wasSuccessfulWebRequest: false
    property bool hasUnseen: false

    function refresh() {
        // Shortcut: data changes not so frequently, one request per app launch is enough.
        if (wasSuccessfulWebRequest) {
            loadFromDb()
            return
        }

        theTask = webApi.getWebMeditations()
    }

    function handleResponse(resObj) {
        //console.log('handleResponse')
        theTask = null

        if (resObj.isError) {
             // TODO handle error
            return
        }

        wasSuccessfulWebRequest = true
        var webItems = resObj.response.meditations

        DB.syncMeditations(webItems)
        loadFromDb()
    }

    function loadFromDb() {
        //console.log('loadFromDb')

        var existingMap = { }
        for (var j = 0; j < transferModel.count; j++) {
            var modelItem = transferModel.get(j)
            existingMap[modelItem.meditation] = j
        }

        var syncedItems = DB.getMeditations()
        var itemsToAppend = []
        for (var i = 0; i < syncedItems.rows.length; i++) {
            var syncedItem = syncedItems.rows.item(i)

            // Just update existing model item with the new params from synchronized DB.
            if (syncedItem.meditation in existingMap) {
                var index = existingMap[syncedItem.meditation]
                transferModel.setProperty(index, "title", syncedItem.title)
                transferModel.setProperty(index, "subtitle", syncedItem.subtitle)
                transferModel.setProperty(index, "description", syncedItem.description)
                transferModel.setProperty(index, "color", syncedItem.color)
                transferModel.setProperty(index, "size", syncedItem.size)
                transferModel.setProperty(index, "quality", syncedItem.quality)
                transferModel.setProperty(index, "duration", syncedItem.duration)
                continue
            }

            // Add new object to model.
            var artObj = {
                "title": syncedItem.title,
                "subtitle": syncedItem.subtitle,
                "description": syncedItem.description,
                "meditation": syncedItem.meditation,
                "color": syncedItem.color,
                "localUrl" : syncedItem.localUrl,
                "status": syncedItem.status,
                "size" : syncedItem.size,
                "quality": syncedItem.quality,
                "duration": syncedItem.duration,
                "seen": syncedItem.seen === 1,

                // UI only.
                "icon": "http://antonovpsy.ru/app/%1.png".arg(syncedItem.meditation),
                "current" : 0,
                "total" : 0
            }

            itemsToAppend.push(artObj)
        }

        //console.log('itemsToDisplay', JSON.stringify(itemsToDisplay))
        transferModel.append(itemsToAppend)

        var hasUnseenLocal = false
        for (var k = 0; k < transferModel.count; k++)
            hasUnseenLocal = hasUnseenLocal || !transferModel.get(k).seen
        hasUnseen = hasUnseenLocal
    }

    function start(i) {
        if (i >= transferModel.count)
            return

        var itm = transferModel.get(i)
        if (itm.status !== JS.STATUS_INITIAL && itm.status !== JS.STATUS_ERROR)
            return

        itm.status = JS.STATUS_REQUESTED
        //console.log("---- start", JSON.stringify(itm))
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
                "meditation": dbItem.meditation,
                "color": dbItem.color,
                "quality": dbItem.quality,
                "duration": dbItem.duration,
                "localUrl" : dbItem.localUrl,
                //"seen": dbItem.seen === 1,

                // UI only.
                "isBuiltIn": false,
                "icon": "http://antonovpsy.ru/app/%1.png".arg(dbItem.meditation)
            }

            itemsToDisplay.push(obj)
        }

        return itemsToDisplay
    }

    function markAllAsSeen() {
        DB.setMedatationsSeen(1)
        hasUnseen = false
        // Redundant for now.
        for (var i = 0; i < transferModel.count; i++)
            transferModel.setProperty(i, "seen", true)
    }

    property QtObject d: QtObject {

        property var currentDownload: null

        function doDownloadStep() {
            // Check if we should pick next task.
            if (!currentDownload || currentDownload.status === JS.STATUS_FINISHED || currentDownload.status === JS.STATUS_ERROR) {
                currentDownload = getNextDownload()

                // Nothing to do.
                if (!currentDownload)
                    return
            }
            //console.log("doDownloadStep", JSON.stringify(currentDownload))

            switch (currentDownload.status)
            {
            case JS.STATUS_REQUESTED:
                var downloadUrl = "http://antonovpsy.ru/app/snd/%1.mp3".arg(currentDownload.meditation)
                var shortName = JS.getFileName(downloadUrl)
                currentDownload.localUrl = CppUtils.prependWithDownloadsPath(shortName)
                var isSucces = networkManager.download(downloadUrl, currentDownload.localUrl)
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
                //console.log("onDownloadOperationFinished updateMeditation")
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
            var baseUrl = "http://antonovpsy.ru/app/json_for_meditations"
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
                    if (doc.status !== 200 && doc.status !== 201 && doc.status !== 202 && doc.status !== 204  ) {
                        resObj.isError = true
                        resObj.response = { "statusText" : doc.statusText, "status" : doc.status}
                    } else {
                        var parsedResponse = {}
                        try {
                            parsedResponse = JSON.parse(__preProcessData(code, doc.responseText))
                            //console.log("parsedResponse", parsedResponse)
                        } catch (e) {
                            console.log(e)
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
        onResponseReceived: handleResponse(resObj)
    }
}
