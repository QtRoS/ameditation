import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Rectangle {
    property alias source: innerImage.source
    color: "#FFC107"
    radius: width/2

    Image {
        id: innerImage
        width: parent.width
        height: parent.height
        smooth: true
    }
}
