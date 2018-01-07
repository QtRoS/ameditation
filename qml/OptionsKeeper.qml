import QtQuick 2.7
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.2

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
