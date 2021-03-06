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
                    meditation	TEXT, \
                    localUrl	TEXT, \
                    color	TEXT, \
                    size TEXT, \
                    quality TEXT, \
                    duration INTEGER, \
                    status	TEXT);")
            }}
            ,{'from': "1.0", 'to': "1.1", 'ops': function(transaction) {
                transaction.executeSql("ALTER TABLE meditations ADD seen INTEGER;")
                transaction.executeSql("UPDATE meditations SET seen=1;")
            }}
//            ,{'from': "1.1", 'to': "1.2", 'ops': function(transaction) {
//                transaction.executeSql("ALTER TABLE meditations ADD size TEXT;")
//                transaction.executeSql("ALTER TABLE meditations ADD quality TEXT;")
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
        console.log("meditations SELECTED: %1".arg(dbResult.rows.length))
    })

    return dbResult;
}

// Obsolete.
//function getMeditationsExcept(exceptList) {
//    var db = openStdDataBase()
//    var dbResult

//    db.transaction(function(tx) {
//        // First call goes this shortcut.
//        if (exceptList.length === 0)
//            dbResult = tx.executeSql("SELECT * FROM meditations")
//        else
//        {
//            var questions = exceptList.map(function (v) { return '?' }).join(',')
//            var query = "SELECT * FROM meditations WHERE meditation NOT IN (%1)".arg(questions)
//            dbResult = tx.executeSql(query, exceptList)
//        }

//        console.log("meditations SELECTED: %1 (exceptList %2)".arg(dbResult.rows.length).arg(exceptList.length))
//    })

//    return dbResult;
//}


function getFinishedMeditations() {
    var db = openStdDataBase()
    var dbResult

    db.transaction(function(tx) {
//        tx.executeSql("delete from meditations");console.log('BUUUUUUUUUUG'); // (JUST FOR DEBUG)
        dbResult = tx.executeSql("SELECT * FROM meditations WHERE status = 'finished'")
        console.log("finished meditations SELECTED: ", dbResult.rows.length)
    })

    return dbResult;
}

// insert
function syncMeditations(objects) {
    if (objects.length === 0)
        return

    var db = openStdDataBase()

    db.transaction(function (tx) {
        for (var i = 0; i < objects.length; i++) {
            var obj = objects[i]
            var dbResult = tx.executeSql("SELECT 1 FROM meditations WHERE meditation=?", [obj.meditation])
            if (dbResult.rows.length > 0) {
                //console.log("Database, addMeditations: row already exist with meditation:", obj.meditation)
                dbResult = tx.executeSql("UPDATE meditations SET title=?, subtitle=?, description=?, color=?, size=?, quality=?, duration=? WHERE meditation=?",
                                         [obj.title, obj.subtitle, obj.description, obj.color, obj.size, obj.quality, obj.duration, obj.meditation])
                console.log("syncMeditations UPDATED:", obj.meditation)
            }
            else {
                dbResult = tx.executeSql('INSERT INTO meditations (title, subtitle, description, meditation, color, status, localUrl, size, quality, duration, seen) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                         [obj.title, obj.subtitle, obj.description, obj.meditation, obj.color, 'initial', 'file:', obj.size, obj.quality, obj.duration, 0])
                console.log("syncMeditations INSERT ID:", dbResult.insertId)
            }
        }
    })

    db.transaction(function (tx) {
        var sqlIds = objects.map(function(v) { return "'%1'".arg(v.meditation) }).join(',')
        //console.log('sqlIds', sqlIds)
        var dbResult = tx.executeSql("DELETE FROM meditations WHERE meditation not in (%1) AND status <> 'finished'".arg(sqlIds), [])
        console.log("syncMeditations DELETED: ", dbResult.rowsAffected)
    })
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

function setMedatationsSeen(value) {
    var db = openStdDataBase()
    var dbResult
    db.transaction(function (tx) {
        dbResult = tx.executeSql('UPDATE meditations SET seen=? WHERE seen<>?', [value, value])
        console.log("meditations markAllAsSeen AFFECTED ROWS: ", dbResult.rowsAffected)
    })
    return dbResult
}
