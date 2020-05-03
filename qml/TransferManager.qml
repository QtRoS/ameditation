import QtQuick 2.4
import AMeditation.CppUtils 1.0
import "jsmodule.js" as JS

Item {
    id: transferManagerRoot

    property ListModel transferModel: ListModel { }

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

    function retry(i) {
        if (i >= transferModel.count)
            return

        var itm = transferModel.get(i)
        itm.status = JS.STATUS_REQUESTED
        console.log("---- retry", JSON.stringify(itm))
        d.doDownloadStep()
    }

    function stop(i) {
        if (i >= transferModel.count)
            return

        var itm = transferModel.get(i)
        if (itm.status === JS.STATUS_INPROGRESS)
        {
            networkManager.abortDownload()
            itm.status = JS.STATUS_ERROR
        }
        else itm.status = JS.STATUS_INITIAL
        d.doDownloadStep()
    }

//    function remove(i) {
//        stop(i)
//        transferModel.remove(i, 1)
//    }

    property QtObject d: QtObject {

        property var currentDownload: null

        function doDownloadStep() {
            console.log("doDownloadStep enter")
            // Check if we should pick next task.
            if (!currentDownload || currentDownload.status === JS.STATUS_FINISHED ||
                    currentDownload.status === JS.STATUS_ERROR) {
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
                currentDownload.localUrl = CppUtils.prependWithDownloadsPath(shortName)
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
        }

        function changeDownloadStatus(status) {
            if (currentDownload) {
                currentDownload.status = status
                doDownloadStep()
            }
        }
    } // QtrObject d

//    Connections {
//        target: bridge
//        onJobDone: {
//            if (jobResult.code === "download") {
//                if (jobResult.isError) {
//                    d.changeDownloadStatus(JS.STATUS_ERROR)
//                } else if (!jobResult.meta) {
//                    d.currentDownload.operationUrl = jobResult.href
//                    d.changeDownloadStatus(JS.STATUS_URLRECEIVED)
//                }
//            } else if (jobResult.code === "upload") {
//                if (jobResult.isError) {
//                    d.changeUploadStatus(JS.STATUS_ERROR)
//                } else {
//                    d.currentUpload.operationUrl = jobResult.href
//                    d.changeUploadStatus(JS.STATUS_URLRECEIVED)
//                }
//            }
//        } // jobDone
//    }

    Connections {
        target: networkManager

        onDownloadOperationProgress: {
            d.currentDownload.current = current
            d.currentDownload.total = total
        }
        onDownloadOperationFinished: {
            if (status === "success")
                d.changeDownloadStatus(JS.STATUS_FINISHED)
            else d.changeDownloadStatus(JS.STATUS_ERROR)
        }
    }
}
