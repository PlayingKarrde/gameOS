import QtQuick 2.0

FocusScope {
id: root
    
    Rectangle {
    id: container

        width: launchText.width + vpx(100)
        height: launchText.height + vpx(100)
        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        
        color: theme.secondary

        Rectangle {
        id: regborder

            anchors.fill: parent
            color: "transparent"
            border.width: vpx(1)
            border.color: "white"
            opacity: 0.1
        }

        Text {
        id: launchText

            text: "Launching " + currentGame.title
            width: contentWidth
            height: contentHeight
            font.family: titleFont.name
            font.pixelSize: vpx(24)
            color: theme.text
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    

    // Helpbar buttons
    ListModel {
        id: launchGameHelpModel

        ListElement {
            name: "Back"
            button: "cancel"
        }
    }
    
    onFocusChanged: { if (focus) currentHelpbarModel = launchGameHelpModel; }

    // Mouse/touch functionality
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            previousScreen();
        }
    }
}