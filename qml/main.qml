import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 400
    height: 640
    title: qsTr("Meditations")

    header: CommonHeader { }

    StackView {
        id: stackView

        anchors.fill: parent
        Component.onCompleted: push(mainPage)
        MainPage { id: mainPage }
    }
}
