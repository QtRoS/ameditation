import QtQuick 2.7
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.2

QtObject {

    property int appTheme
    property int accentColor
    property color contrastColor

    Component.onCompleted: {
        appTheme = getAppTheme()
        accentColor = getAccentColor()
        contrastColor = getContrastColor()
    }

    onAppThemeChanged: {
        setAppTheme(appTheme)
    }

    onAccentColorChanged: {
        setAccentColor(accentColor)
    }

    onContrastColorChanged: {
        setContrastColor(contrastColor)
    }

    function getAppTheme() {
        return settings.appTheme
    }

    function setAppTheme(value) {
        settings.appTheme = value
    }

    function getAccentColor() {
        return settings.accentColor
    }

    function setAccentColor(value) {
        settings.accentColor = value
    }

    function getContrastColor() {
        return settings.contrastColor
    }

    function setContrastColor(value) {
        settings.contrastColor = value
    }

    property Settings settings: Settings {
        property int appTheme: 0
        property int accentColor: 14
        property color contrastColor: "white"
    }
}
