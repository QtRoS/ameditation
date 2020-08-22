import QtQuick 2.12

Rectangle {
    id: internalUpdateMarkerId

    readonly property int __maxSize: 12
    readonly property int __minSize: 9
    readonly property int __defSize: 10
    property int __size: __defSize

    color: "steelblue"
    width: __size
    height: __size
    radius: __size
    anchors {
        top: parent.top
        topMargin: 10 + (__maxSize - __maxSize)
        right: parent.right
        rightMargin: 5 + (__maxSize - __maxSize)
    }

    //    SequentialAnimation {
    //        running: true
    //        loops: Animation.Infinite;
    //        SmoothedAnimation { target: internalUpdateMarkerId; property: "__size"; to: __minSize; velocity: 8 }
    //        SmoothedAnimation { target: internalUpdateMarkerId; property: "__size"; to: __maxSize; velocity: 8 }
    //    }
}
