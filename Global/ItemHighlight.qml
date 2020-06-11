import QtQuick 2.8
import QtGraphicalEffects 1.0
import QtMultimedia 5.9

Item {
id: root

    property var game
    property bool selected
    property bool playVideo: (settings.AllowThumbVideo === "Yes")// && selected

    onGameChanged: {
        videoPreviewLoader.sourceComponent = undefined;
        if (playVideo) {
            videoDelay.restart();
        }
    }

    onSelectedChanged: {
        if (!selected) {
            videoPreviewLoader.sourceComponent = undefined;
            videoDelay.stop();
        }
    }

    // Timer to show the video
    Timer {
    id: videoDelay

        interval: 600
        onTriggered: {
            if (game && game.assets.videos.length) {
                videoPreviewLoader.sourceComponent = videoPreviewWrapper;
            }
        }
    }

    Timer {
    id: stopvideo

        interval: 1000
        onTriggered: {
            videoPreviewLoader.sourceComponent = undefined;
            videoDelay.stop();
        }
    }

    // NOTE: Video Preview
    Component {
    id: videoPreviewWrapper

        Video {
        id: videocomponent

            anchors.fill: parent
            source: game.assets.videoList.length ? game.assets.videoList[0] : ""
            fillMode: VideoOutput.PreserveAspectCrop
            muted: settings.AllowThumbVideoAudio === "No"
            loops: MediaPlayer.Infinite
            autoPlay: true

            //onPlaying: videocomponent.seek(5000)
        }

    }

    DropShadow {
    id: outershadow

        anchors.fill: videocontainer
        horizontalOffset: 0
        verticalOffset: 0
        radius: 20.0
        samples: 15
        color: "#000000"
        source: videocontainer
        opacity: selected ? 0.5 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }
        z: -5
    }

    Item {
    id: videocontainer

        anchors.fill: parent

        // Video
        Loader {
        id: videoPreviewLoader

            asynchronous: true
            anchors { fill: parent }
        }
    }
}