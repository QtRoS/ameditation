.pragma library // I hope this will prevent the waste of memory.
.import QtQuick.LocalStorage 2.0 as SQL

/* For internal usage in module.
 */
var gDbCache = undefined
function openStdDataBase() {
    if (gDbCache === undefined) {

        var migrations = [
            {'from': "", 'to': "1.0", 'ops': function(transaction) {
                transaction.executeSql('PRAGMA foreign_keys = ON;')   // enable foreign key support
                transaction.executeSql("CREATE TABLE meditations ( \
                    id	INTEGER PRIMARY KEY AUTOINCREMENT, \
                    title	TEXT NOT NULL, \
                    subtitle	TEXT, \
                    description	TEXT, \
                    icon	TEXT, \
                    meditation	TEXT, \
                    url	TEXT, \
                    localUrl	TEXT, \
                    color	TEXT, \
                    status	TEXT);")
            }}
//            ,{'from': "1.0", 'to': "1.1", 'ops': function(transaction) {
//                transaction.executeSql("CREATE TABLE meditations2 ( \
//                    id	INTEGER PRIMARY KEY AUTOINCREMENT, \
//                    title	TEXT NOT NULL, \
//                    subtitle	TEXT, \
//                    description	TEXT, \
//                    icon	TEXT, \
//                    meditation	TEXT, \
//                    status	TEXT);")
//            }}
        ]

        do {
            var db = SQL.LocalStorage.openDatabaseSync("AMeditation", "", "Main DB", 100000)
            var dbVersion = db.version
            console.log("dbVersion", dbVersion)

            var atLeastOneFired = false
            for (var i = 0; i < migrations.length; i++) {
                var migration = migrations[i]

                if (dbVersion !== migration.from)
                    continue

                console.log('Migrating from v%1 to v%2'.arg(migration.from).arg(migration.to))
                db.changeVersion(migration.from, migration.to, migration.ops);
                console.log('Done')

                atLeastOneFired = true
            }

            gDbCache = db
        } while (atLeastOneFired)
    }

    return gDbCache
}


function getMeditations() {
    var db = openStdDataBase()
    var dbResult

    db.transaction(function(tx) {
        dbResult = tx.executeSql("SELECT * FROM meditations")
        console.log("meditations SELECTED: ", dbResult.rows.length)
    })

    return dbResult;
}

function getFinishedMeditations() {
    var db = openStdDataBase()
    var dbResult

    db.transaction(function(tx) {
        dbResult = tx.executeSql("SELECT * FROM meditations WHERE status = 'finished'")
        console.log("meditations SELECTED: ", dbResult.rows.length)
    })

    return dbResult;
}

// insert
function syncMeditations(objects) {
    var db = openStdDataBase()
    db.transaction(function (tx) {
        for (var i = 0; i < objects.length; i++) {
            var obj = objects[i]
            var dbResult = tx.executeSql("SELECT 1 FROM meditations WHERE meditation=?", [obj.meditation])
            if (dbResult.rows.length > 0) {
                console.log("Database, addMeditations: already exist with meditation: ", obj.meditation)
                dbResult = tx.executeSql('UPDATE meditations SET title=?, subtitle=?, description=?, icon=?, url=?, color=? WHERE meditation=?',
                                         [obj.title, obj.subtitle, obj.description, obj.icon, obj.url, obj.color, obj.meditation])
                console.log("syncMeditations AFFECTED ROWS: ", dbResult.rowsAffected)
            }
            else {
                dbResult = tx.executeSql('INSERT INTO meditations (title, subtitle, description, icon, meditation, url, color, status, localUrl) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                         [obj.title, obj.subtitle, obj.description, obj.icon, obj.meditation, obj.url, obj.color, 'initial', 'file:'])
                console.log("syncMeditations INSERT ID: ", dbResult.insertId)
            }
        }
    })

    // TODO prune non existing
//    db.transaction(function (tx) {
//        for (var i = 0; i < meditations.length; i++) {
//            var obj = objects[i]
//            var dbResult = tx.executeSql("SELECT 1 FROM meditations WHERE meditation=?", [obj.meditation])
//            if (dbResult.rows.length > 0) {
//                console.log("Database, addMeditations: already exist with meditation: ", obj.meditation)
//                continue
//            }

//            dbResult = tx.executeSql('INSERT INTO meditations (title, subtitle, description, icon, meditation, status) VALUES(?, ?, ?, ?, ?, ?)',
//                                     [obj.title, obj.subtitle, obj.description, obj.icon, obj.meditation, 'NEW'])  // TODO status
//            console.log("meditation INSERT ID: ", dbResult.insertId)
//        }
//    })
}

function updateMeditation(meditation, status, localUrl) {
    var db = openStdDataBase()
    var dbResult
    db.transaction(function (tx) {
        dbResult = tx.executeSql('UPDATE meditations SET status=?, localUrl=? WHERE meditation=?',
                                 [status, localUrl, meditation])
        console.log("meditations updateMeditation AFFECTED ROWS: ", dbResult.rowsAffected)
    })
    return dbResult
}












//// select
//function loadFeeds()
//{
//    var db = openStdDataBase()
//    var dbResult
////    var feeds
//    db.transaction(function(tx) {
//        dbResult = tx.executeSql("SELECT * FROM feed")
//        console.log("feed SELECTED: ", dbResult.rows.length)
//    })
//    return dbResult;
//}

//// insert
//function addFeed(title, source)  // from user input
//{
//    var dbResult
//    var db = openStdDataBase()
//    db.transaction(function (tx) {
//        /* Check uniqueness.
//         */
//        dbResult = tx.executeSql("SELECT id FROM feed WHERE source=?", [source])
//        if (dbResult.rows.length > 0) {
//            console.log("Database, addFeed: already exist feed with source: ", source)
//            dbResult = {"error": true, "exist": true}
//            return
//        }

//        dbResult = tx.executeSql('INSERT INTO feed (title, source) VALUES(?, ?)',
//                                 [title , source])
//        console.log("feed INSERT ID: ", dbResult.insertId)

//        dbResult.feedId = tx.executeSql("SELECT * FROM feed WHERE source=?", [source]).rows.item(0).id
//        console.log("dbResult.feedId", dbResult.feedId)
//    })
//    return dbResult;
//}

//// change confirmed
///* Update feed status.
// * 0 - default, 1 - good, 2 - bad url.
// */
//function setFeedStatus(id, status)  // from user input
//{
//    var db = openStdDataBase()
//    var dbResult
//    db.transaction(function (tx) {
//        dbResult = tx.executeSql('UPDATE feed SET status=? WHERE id=?',
//                                 [status, id])
//        console.log("feed setFeedStatus, AFFECTED ROWS: ", dbResult.rowsAffected)
//    })
//    return dbResult
//}

//// update
//function updateFeedByUser(id, title, source)  // from user input
//{
//    var db = openStdDataBase()
//    var dbResult
//    db.transaction(function (tx) {
//        dbResult = tx.executeSql('UPDATE feed SET title=?, source=? WHERE id=?',
//                                 [title, source, id])
//        console.log("feed updateFeedByUser, AFFECTED ROWS: ", dbResult.rowsAffected)
//    })
//    return dbResult
//}

//function updateFeedByXml(id, link, description, title)   // from xml file
//{
//    var db = openStdDataBase()
//    var dbResult
//    db.transaction(function (tx) {
//        dbResult = tx.executeSql('UPDATE feed SET link=?, description=?, title=? WHERE id=?',
//                                 [link, description, title, id])
//        //console.log("feed updateFeedByXml, AFFECTED ROWS: ", dbResult.rowsAffected)
//    }
//    )
//    return dbResult
//}

//// delete
//function deleteFeed(id)
//{
//    var db = openStdDataBase()
//    var dbResult
//    db.transaction(function (tx) {
//        dbResult = tx.executeSql('delete from feed_tag where feed_id=?', [id])
//        dbResult = tx.executeSql('delete from feed where id=?', [id])
//        console.log("feed delete, AFFECTED ROWS: ", dbResult.rowsAffected)
//    })
//    return dbResult
//}

//function deleteFeedByTagId(tagId)
//{
//    var db = openStdDataBase()
//    var dbResult
//    db.transaction(function (tx) {
//        dbResult = tx.executeSql('delete from feed where exists (select 1 from feed_tag where feed_tag.feed_id = feed.id and feed_tag.tag_id = ?)',
//                                 [tagId])
//        console.log("feed delete by tag id, AFFECTED ROWS: ", dbResult.rowsAffected)
//    })
//    return dbResult
//}

//// select feeds without of topic (tag).
//function loadFeedsWithoutTopic()
//{
//    var db = openStdDataBase()
//    var dbResult

//    db.transaction(function(tx) {
//        dbResult = tx.executeSql("SELECT * FROM feed WHERE id NOT IN (SELECT feed_id FROM feed_tag)")
//        console.log("loadFeedsWithoutTopic SELECTED: ", dbResult.rows.length)
//    })
//    return dbResult;  // I suggest that return the whole result in order to know if error occurs
//}

///* article operations
// * include select, insert, update and delete operations
// *
// *
// */
//// select
//function loadArticles(params)   // params = {"isAll": true/false, "feedId": id | "tagId" : id}
//{
//    var db = openStdDataBase()
//    var dbResult

//    //console.log("loadArticles", JSON.stringify(params))

//    db.transaction(function(tx) {
//        if (params == undefined || params.isAll) // miss params
//            dbResult = tx.executeSql('SELECT article.*, feed.title as feed_name FROM article inner join feed on article.feed_id = feed.id ORDER BY article.pubdate DESC')
//        else if (params.feedId)
//            dbResult = tx.executeSql('SELECT article.*, feed.title as feed_name FROM article inner join feed on article.feed_id = feed.id WHERE article.feed_id = ? ORDER BY article.pubdate DESC', [params.feedId])
//        else if (params.tagId)
//            dbResult = tx.executeSql('SELECT article.*, feed.title as feed_name FROM article INNER JOIN feed on article.feed_id = feed.id INNER JOIN feed_tag on feed_tag.feed_id = feed.id WHERE tag_id = ? ORDER BY article.pubdate DESC', [params.tagId])
//            //dbResult = tx.executeSql('SELECT article.*, feed.title as feed_name FROM article inner join feed on article.feed_id = feed.id WHERE article.feed_id IN (SELECT feed_id FROM feed_tag WHERE tag_id = ?) ORDER BY article.pubdate DESC', [params.tagId])
//    })
//    return dbResult;
//}

//// load all favourite articles
//function loadFavouriteArticles()
//{
//    var db = openStdDataBase()
//    var dbResult

//    db.transaction(function(tx) {
//        dbResult = tx.executeSql('  select article.*, \
//                                    feed.title as feed_name, \
//                                    feed_tag.tag_id \
//                                    from article inner join feed on article.feed_id = feed.id \
//                                    join feed_tag on feed_tag.feed_id = feed.id \
//                                    where article.favourite = "1" order by article.pubdate desc')
//    })
//    //console.log("loadFavouriteArticles", dbResult.rows.length)
//    //console.assert(dbResult.rows.length !== 0,  "ERROR: There are no saved articles")
//    return dbResult;
//}

//// Load top for tag.
//function loadTagHighlights(size) {
//    var db = openStdDataBase()
//    var dbResult

//    db.transaction(function(tx) {
//        dbResult = tx.executeSql(  'select a.id, f.id as feed_id, ft.tag_id \
//                                    from article a \
//                                    inner join feed f on f.id = a.feed_id \
//                                    inner join feed_tag ft on ft.feed_id = f.id \
//                                    order by ft.tag_id, a.pubdate desc' )

//        var idArray = []

//        var curTagId = -1
//        var count = 0
//        for (var i = 0; i < dbResult.rows.length; i++) {
//            var c = dbResult.rows.item(i).tag_id

//            if (c != curTagId) {
//                count = 0
//                curTagId = c
//            }

//            if (count < size) {
//                idArray.push(dbResult.rows.item(i).id)
//                count++
//            }
//        }

//        var param = idArray.length ? idArray.join() : "-1" // Empty array guard.
//        dbResult = tx.executeSql('select a.*, f.id as feed_id, f.title as feed_name, t.id as tag_id, t.name as tag_name \
//                                 from article a \
//                                 inner join feed f on a.feed_id = f.id \
//                                 inner join feed_tag ft on ft.feed_id = f.id \
//                                 inner join tag t on t.id = ft.tag_id \
//                                 where a.id in (%1) \
//                                 order by t.id, a.pubdate desc'.arg(param)) // Don't know why, but it doesn't work with commas in param

//        //.console.log(idArray.length, idArray)
//    })
//    //console.log("loadTagHighlights", dbResult.rows.length)
//    return dbResult
//}

///*
//  this function is for avoiding hard drive performance issue,
//  pass model (plain JS array) and feed id as parameters to this function,
//  it will automaticly insert all the articles into database
//  add third pamams which is for restoring articles' properties
// */
//function addArticles(model, feed_id, restoreArray)
//{
//    var dbResult

//    var db = openStdDataBase()
//    db.transaction(function (tx) {

//        var article;
//        for (var i = 0; i < model.length; i++) {

//            article = model[i]
//            var title =  article.title ? article.title : ""
//            var guid =  article.guid ? article.guid : Qt.md5(title)
//            var link =  article.link ? article.link : ""
//            var pubDate =  article.pubDate ? article.pubDate : ""
//            var description =  article.description ? article.description : ""
//            var content =  article.content ? article.content : ""
//            var image =  article.image ? article.image : ""
//            var media_groups = article.media_groups ? JSON.stringify(article.media_groups) : ""
//            var author = article.author ? JSON.stringify(article.author) : ""

//            /* Check uniqueness.
//             */
//            dbResult = tx.executeSql("SELECT 1 FROM article WHERE guid=? AND feed_id=?", [guid, feed_id])
//            if (dbResult.rows.length > 0) {
//                // console.log("Database, add article: already exist article with guid: ", guid)
//                continue;
//            }
//            dbResult = tx.executeSql('INSERT INTO article (title, content, link, description, pubdate, guid, feed_id, image, media_groups, author) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
//                                     [title, content, link, description, pubDate, guid, feed_id, image, media_groups, author])
//        }

//        //console.time("restoreArrayCycle")
//        if (restoreArray) {
//            var BASE_HEURISTIC_CHUNK = 512
//            var arrayLength = restoreArray.length

//            var queryGetFunction = function(paramSize) {
//                var baseQuery = 'UPDATE article SET status="1" WHERE guid IN ('
//                for (var i = 0; i < paramSize; i++)
//                    baseQuery += '?,'
//                baseQuery = baseQuery.substring(0, baseQuery.length - 1) + ') AND status="0"'
//                return baseQuery
//            }

//            var chunkOfData = restoreArray.length > BASE_HEURISTIC_CHUNK ? BASE_HEURISTIC_CHUNK : restoreArray.length
//            var fullQuery = queryGetFunction(chunkOfData)

//            for (var j = 0; j < restoreArray.length; j += chunkOfData) {

//                var limit = Math.min(chunkOfData, restoreArray.length - j)
//                var queryToUse = limit == chunkOfData ? fullQuery : queryGetFunction(limit)

//                var queryData = []
//                for (var k = 0; k < limit; k++)
//                    queryData.push(restoreArray[j + k].guid)

//                dbResult = tx.executeSql(queryToUse, queryData)
//                // console.log("CONSUMED", limit, "Rows affected:", dbResult.rowsAffected)
//            }
//        } // if restore array
//        //console.timeEnd("restoreArrayCycle")
//    })
//    return dbResult;
//}

//function addArticlesEx(entries, feedId)
//{
//    var dbResult

//    var db = openStdDataBase()
//    db.transaction(function (tx) {

//        // 1. Preload details.
//        //.console.time("Preload")
//        var articlePropertiesDb = dbResult = tx.executeSql("select guid, status, favourite \
//                                                            from article \
//                                                            where feed_id = ?", [feedId])
//        // TODO Make readArticles and favArticles arrays.
//        var feedArticles = []
//        for (var j = 0; j < articlePropertiesDb.rows.length; j++) {
//            var itm = articlePropertiesDb.rows.item(j)
//            feedArticles.push({ "guid" : itm.guid, "status" : itm.status, "favourite" : itm.favourite })
//        }
//        console.log("feedArticles.length", feedArticles.length)
//        //.console.timeEnd("Preload")

//        // 2. CleanUp old.
//        //.console.time("DeleteOld")
//        tx.executeSql("delete from article where feed_id = ? and favourite = '0'", [feedId]) //
//        //.console.timeEnd("DeleteOld")

//        // 3. Insert new objects.
//        //.console.time("InsertArticle")
//        var emptyStr = ""
//        for (var i = 0; i < entries.length; i++) {
//            var e = entries[i]

//            var title =  e.title ? e.title : emptyStr
//            var content =  e.content ? e.content : emptyStr
//            var link =  e.link ? e.link : emptyStr
//            var author = e.author ? JSON.stringify(e.author) : emptyStr
//            var description =  e.description ? e.description : emptyStr
//            var pubDate =  e.pubDate ? e.pubDate : 0
//            var guid =  e.guid ? e.guid : Qt.md5(title)
//            var image =  e.image ? e.image : emptyStr
//            var media_groups = e.media_groups ? JSON.stringify(e.media_groups) : emptyStr

//            //  Check uniqueness of favourite articles.
//            if (feedArticles.some(function(v) { return v.guid == guid && v.favourite == '1' } ))
//                continue

//            dbResult = tx.executeSql('insert into article (title, content, link, description, pubdate, guid, feed_id, image, media_groups, author) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
//                                     [title, content, link, description, pubDate, guid, feedId, image, media_groups, author])
//        }
//        //.console.timeEnd("InsertArticle")

//        // 4. Update statuses.
//        //.console.time("UpdateStatuses")
//        var readArticles = feedArticles.filter(function(e) { return e.status == "1" } )
//        if (readArticles.length) {
//            var BASE_HEURISTIC_CHUNK = 512
//            var arrayLength = readArticles.length

//            var queryGetFunction = function(paramSize) {
//                var baseQuery = 'update article set status="1" where guid in ('
//                for (var i = 0; i < paramSize; i++)
//                    baseQuery += '?,'
//                baseQuery = baseQuery.substring(0, baseQuery.length - 1) + ') AND status="0"'
//                return baseQuery
//            }

//            var chunkOfData = readArticles.length > BASE_HEURISTIC_CHUNK ? BASE_HEURISTIC_CHUNK : readArticles.length
//            var fullQuery = queryGetFunction(chunkOfData)

//            for (var j = 0; j < readArticles.length; j += chunkOfData) {

//                var limit = Math.min(chunkOfData, readArticles.length - j)
//                var queryToUse = limit == chunkOfData ? fullQuery : queryGetFunction(limit)

//                var queryData = []
//                for (var k = 0; k < limit; k++)
//                    queryData.push(readArticles[j + k].guid)

//                dbResult = tx.executeSql(queryToUse, queryData)
//                // console.log("CONSUMED", limit, "Rows affected:", dbResult.rowsAffected)
//            }
//        } // if restore array
//        //.console.timeEnd("UpdateStatuses")
//    })
//    return dbResult;
//}

//// update
//function updateArticleStatus(id, status)
//{
//    var db = openStdDataBase()
//    var dbResult
//    db.transaction(function (tx) {
//        dbResult = tx.executeSql('update article set status=? WHERE id=?',
//                                 [status, id])
//        console.log("article status UPDATE, AFFECTED ROWS: ", dbResult.rowsAffected)
//    })
//    return dbResult
//}

//function updateArticleFavourite(id, favourite) {
//    var db = openStdDataBase()
//    var dbResult
//    db.transaction(function (tx) {
////        ensureFeedTableExists(tx)
//        dbResult = tx.executeSql('UPDATE article SET favourite=? WHERE id=?',
//                                 [favourite, id])
//        console.log("article favourite UPDATE, AFFECTED ROWS: ", dbResult.rowsAffected)
//    })
//    return dbResult
//}


//// delete
//function deleteArticle(id)
//{
//    var db = openStdDataBase()
//    var dbResult
//    db.transaction(function (tx) {
////        ensureFeedTableExists(tx)
//        dbResult = tx.executeSql('delete from article WHERE id=?',
//                                 [id])
//        console.log("article delete, AFFECTED ROWS: ", dbResult.rowsAffected)
//    })
//    return dbResult
//}

//// clear article table, only status='2' and favourite='1' remain
//function clearArticles(feed_id)
//{
//    var db = openStdDataBase()
//    var dbResult
//    db.transaction(function (tx) {
////        ensureFeedTableExists(tx)
//        dbResult = tx.executeSql("delete from article WHERE (status='0' OR status='1') AND favourite='0' AND feed_id=?", [feed_id])
//        console.log("article delete, AFFECTED ROWS: ", dbResult.rowsAffected)
//    })
//    return dbResult
//}

