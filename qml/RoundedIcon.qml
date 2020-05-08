import QtQuick 2.12
import QtQuick.Controls 2.12

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
