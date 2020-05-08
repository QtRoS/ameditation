import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import Qt.labs.settings 1.0


QtObject {

    property bool isNightMode

    Component.onCompleted: {
        isNightMode = getIsNightMode()
    }

    onIsNightModeChanged: {
        setIsNightMode(isNightMode)
    }

    function getIsNightMode() {
        return settings.isNightMode
    }

    function setIsNightMode(value) {
        settings.isNightMode = value
    }

    property Settings settings: Settings {
        property bool isNightMode: false
    }
}
