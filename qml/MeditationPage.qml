import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Page {

    property string meditation: ""

    Label {
        text: qsTr("MeditationPage")
        anchors.centerIn: parent
    }

    Component.onCompleted: console.log("meditation", meditation)
}
