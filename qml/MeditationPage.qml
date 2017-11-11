import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import QtMultimedia 5.9

Page {

//    property int modelIndex: -1
//    property var meditation

//    onModelIndexChanged: {
//        var obj = meditationModel.get(modelIndex)
//        meditation = {
//            "meditation": obj.meditation,
//            "title": obj.title,
//            "description": obj.description,
//            "color": obj.color
//        }
//    }
    property string meditId: ""
    property string meditTitle: ""
    property string meditDesc: ""
    property string meditColor: ""

    Audio {
        id: audioPlayback
        property bool isPlaying: audioPlayback.playbackState == Audio.PlayingState
        source: "qrc:/media/%1.mp3".arg(meditId)
        onStatusChanged: {
            console.log("Audio onStatusChanged", status, errorString, error)
            console.log("Audio duration: %1(s) %2(m)".arg(duration / 1000).arg(duration / 1000 / 60))
        }
    }

    Pane {
        id: mainPane

        anchors {
            fill: parent
            margins: 15
        }
        Material.elevation: 2

        Flickable {
            anchors.fill: parent
            clip: true

            contentWidth: parent.width
            contentHeight: innerItem.height

            Column {
                id: innerItem
                spacing: 5
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }

                Label {
                    text: meditTitle
                    color: meditColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.foreground: optionsKeeper.accentColor
                    font.pointSize: 14
                    elide: Text.ElideRight
                }

                Label {
                    text: meditDesc
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignJustify
                    Material.foreground:Material.Grey
                    textFormat: Text.PlainText
                }

                Item {
                    height: 50
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    Slider {
                        anchors {
                            left: parent.left
                            right: playBtn.left
                            verticalCenter: parent.verticalCenter
                        }
                        from: 0
                        to: audioPlayback.duration
                        value: audioPlayback.position
                        onMoved: audioPlayback.seek(value)
                        Material.accent: meditColor
                    }

                    Button {
                        id: playBtn

                        Image {
                            anchors.centerIn: parent
                            width: 24
                            height: width

                            source: Qt.resolvedUrl(audioPlayback.isPlaying ? "qrc:/img/pause-round-button.png" : "qrc:/img/play-round-button.png")
                        }

                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        onClicked: {
                            if (audioPlayback.isPlaying)
                                audioPlayback.pause()
                            else audioPlayback.play()
                        }
                    }
                }

                Label {
                    text: {
                        var positionInSecs = Math.round(audioPlayback.position/1000)
                        var durationInSecs = Math.round(audioPlayback.duration/1000)
                        return "(%1 / %2)".arg(Qt.formatTime(new Date(2017, 0, 0, 0, Math.floor(positionInSecs/60), Math.floor(positionInSecs%60), 0), "mm:ss"))
                                        .arg(Qt.formatTime(new Date(2017, 0, 0, 0, Math.floor(durationInSecs/60), Math.floor(durationInSecs%60), 0), "mm:ss"))
                    }

                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.foreground:Material.Grey
                    textFormat: Text.PlainText
                }
            }
        }
    }
}
