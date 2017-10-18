import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import QtMultimedia 5.9

Page {

    property int modelIndex: -1
    property var meditation

    onModelIndexChanged: {
        console.log("modelIndex", modelIndex)
        meditation = meditationModel.get(modelIndex)
    }

    Audio {
        id: audioPlayback
        property bool isPlaying: audioPlayback.playbackState == Audio.PlayingState
        source: "qrc:/media/%1.mp3".arg(meditation.meditation)
        onStatusChanged: console.log("onStatusChanged", status, errorString, error)
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
                    text: meditation.title
                    color: meditation.color
                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.foreground: optionsKeeper.accentColor
                    font.pointSize: 14
                    elide: Text.ElideRight
                }

                Label {
                    text: meditation.description
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignJustify
                    Material.foreground: Material.Grey
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
                        Material.accent: meditation.color //optionsKeeper.accentColor
                    }

                    Button {
                        id: playBtn

                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        text: audioPlayback.isPlaying ? qsTr("⏸️") : qsTr("▶️")
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
                    Material.foreground: Material.Grey
                    textFormat: Text.PlainText
                }
            }
        }
    }
}
