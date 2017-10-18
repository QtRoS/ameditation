import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

Rectangle {
    property alias source: innerImage.source
    color: "#FFC107"
    radius: width/2

    Image {
        id: innerImage
        //source: Qt.resolvedUrl("file:/home/mrqtros/Downloads/my%1.png".arg(index))// cutmypic Qt.resolvedUrl("file:/home/mrqtros/Downloads/x8PhM.png")
        width: parent.width
        height: parent.height
        smooth: true
    }
}
