import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

ApplicationWindow {
    visible: true
    width: 400
    height: 640
    title: qsTr("Meditations")

    header: CommonHeader {
        id: commonHeader
        customColor: (stackView.currentItem && stackView.currentItem.hasOwnProperty("meditation")) ?
                         stackView.currentItem.meditation.color : "#ffffff"
    }

    // Material.theme: optionsKeeper.appTheme
    //Material.theme: Material.Light

    Component.onCompleted: {
        //optionsKeeper.appTheme = Material.Light

        optionsKeeper.contrastColor = "white"
        optionsKeeper.accentColor = Material.Amber

        //optionsKeeper.contrastColor = "black"
        //optionsKeeper.accentColor = Material.DeepPurple

        console.log("optionsKeeper.accentColor", optionsKeeper.accentColor)
    }

    StackView {
        id: stackView

        anchors.fill: parent
        Component.onCompleted: push(mainPage)
        MainPage { id: mainPage }

        //onCurrentItemChanged: commonHeader.customColor = currentItem.hasOwnProperty("meditation") ? currentItem.meditation.color : "#ffffff"
    }

    OptionsKeeper {
        id: optionsKeeper
    }

    MeditationModel {
        id: meditationModel
    }
}
