import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
id: root

    signal activated
    signal highlighted

    property string mediaItem: ""
    property bool selected
    property bool isVideo: mediaItem.includes(".mp4") || mediaItem.includes(".webm")

    scale: selected ? 1.05 : 1
    Behavior on scale { NumberAnimation { duration: 100 } }
    z: selected ? 10 : 1

    Image {
    id: border

        anchors.fill: parent
        source: "../assets/images/gradient.png"
        visible: selected

        Rectangle {
        id: titlecontainer

            width: bubbletitle.contentWidth + vpx(20)
            height: bubbletitle.contentHeight + vpx(8)
            color: theme.secondary
            anchors {
                top: border.bottom; topMargin: vpx(5)
            }
            anchors.horizontalCenter: parent.horizontalCenter
            radius: height/2

            Text {
            id: bubbletitle

                text: isVideo ? "Video" : "Screenshot"
                color: theme.text
                font {
                    family: subtitleFont.name
                    pixelSize: vpx(14)
                    bold: true
                }
                elide: Text.ElideRight
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Image {
    id: bg

        anchors.fill: parent
        anchors.margins: vpx(4)
        source: isVideo ? "" : mediaItem
        fillMode: Image.PreserveAspectCrop

        Rectangle {
        id: videopreview

            anchors.fill: parent
            color: theme.secondary
            visible: isVideo
        }

        Image {
        id: iconFill

            anchors.fill: parent
            source: "../assets/images/gradient.png"
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        Image {
        id: mask

            source: "../assets/images/icon_mediaplayer.svg"
            anchors.centerIn: parent
            width: vpx(150); height: width
            sourceSize: Qt.size(parent.width, parent.height)
            smooth: true
            fillMode: Image.PreserveAspectFit
            visible: false
        }

        OpacityMask {
            anchors.fill: mask
            anchors.margins: vpx(30)
            source: iconFill
            maskSource: mask
            visible: isVideo
        }

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: selected ? 0 : 0.7
            z: selected ? 0 : 10
        }
        
    }
    
    // List specific input
    Keys.onPressed: {
        // Accept
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            activated();        
        }
    }

    // Mouse/touch functionality
    MouseArea {
        anchors.fill: parent
        hoverEnabled: settings.MouseHover == "Yes"
        onEntered: { sfxNav.play(); highlighted(); }
        onExited: {}
        onClicked: activated();
    }
}