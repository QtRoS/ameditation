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
            ,{'from': "1.0", 'to': "1.1", 'ops': function(transaction) {
                transaction.executeSql("ALTER TABLE meditations ADD size TEXT;")
                transaction.executeSql("ALTER TABLE meditations ADD quality TEXT;")
            }}
            ,{'from': "1.1", 'to': "1.2", 'ops': function(transaction) {
                transaction.executeSql("ALTER TABLE meditations ADD duration INTEGER;")
            }}
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
    if (objects.length === 0)
        return

    var db = openStdDataBase()

    db.transaction(function (tx) {
        for (var i = 0; i < objects.length; i++) {
            var obj = objects[i]
            var dbResult = tx.executeSql("SELECT 1 FROM meditations WHERE meditation=?", [obj.meditation])
            if (dbResult.rows.length > 0) {
                console.log("Database, addMeditations: already exist with meditation: ", obj.meditation)
                dbResult = tx.executeSql("UPDATE meditations SET title=?, subtitle=?, description=?, icon=?, url=?, color=?, size=?, quality=?, duration=? WHERE meditation=?",
                                         [obj.title, obj.subtitle, obj.description, obj.icon, obj.url, obj.color, obj.size, obj.quality, obj.duration, obj.meditation])
                console.log("syncMeditations UPDATED: ", dbResult.rowsAffected)
            }
            else {
                dbResult = tx.executeSql('INSERT INTO meditations (title, subtitle, description, icon, meditation, url, color, status, localUrl, size, quality) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                         [obj.title, obj.subtitle, obj.description, obj.icon, obj.meditation, obj.url, obj.color, 'initial', 'file:', obj.size, obj.quality, obj.duration])
                console.log("syncMeditations INSERT ID: ", dbResult.insertId)
            }
        }
    })

    db.transaction(function (tx) {
        var sqlIds = objects.map(function(v) { return "'%1'".arg(v.meditation) }).join(',')
        console.log('sqlIds', sqlIds)
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
