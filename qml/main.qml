import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ApplicationWindow {
    visible: true
    width: 400
    height: 640
    title: qsTr("Meditations")

    header: CommonHeader {
        id: commonHeader
        customColor: optionsKeeper.isNightMode ? "#222222" : (stackView.currentItem && stackView.currentItem.hasOwnProperty("meditColor")) ?
                         stackView.currentItem.meditColor : Material.Amber
    }

    StackView {
        id: stackView

        anchors.fill: parent
        Component.onCompleted: {
            push(mainPage)
            transferManager.refresh()
        }

        MainPage { id: mainPage }

        Keys.onBackPressed: {
            event.accepted = stackView.depth > 1
            stackView.pop()
            console.log("stackView.depth", stackView.depth, event.accepted)
        }

        // Night mode staff.
        background: Rectangle { anchors.fill: parent; color: "white" }
        layer.effect: DarkModeShader { }
        layer.enabled: optionsKeeper.isNightMode
    }

    MeditationModel {
        id: meditationModel
    }

    OptionsKeeper {
        id: optionsKeeper
    }

    TransferManager {
        id: transferManager
    }
}
