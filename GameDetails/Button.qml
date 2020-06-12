import QtQuick 2.0

FocusScope {
id: root

    property bool selected
    property alias text: buttonlabel.text
    property alias icon: buttonicon.source
    property alias buttonWidth: container.width
    property real buttonMargin: vpx(25)
    width: container.width

    signal activated
    signal highlighted

    Rectangle {
    id: container

        width: (buttonlabel.text !== "") ? buttonlabel.x + buttonlabel.contentWidth + buttonMargin : height
        Behavior on width { NumberAnimation { duration: 100 } }
        height: vpx(50)
        color: selected ? theme.accent : "transparent"
        radius: height/2
        border.width: selected ? 0 : 2
        border.color: "white"
        opacity: selected ? 1 : 0.2
        
        Image {
        id: buttonicon

            source: "../assets/images/icon_play.svg"
            width: parent.height - vpx(30)
            height: parent.height - vpx(30)
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            //opacity: selected ? 1 : 0.2
            Behavior on opacity { NumberAnimation { duration: 100 } }
            scale: selected ? 1.2 : 1
            Behavior on scale { NumberAnimation { duration: 100 } }
            
            property real iconMargin: (buttonlabel.text === "") ? vpx(15) : buttonMargin
            anchors { left: parent.left; leftMargin: iconMargin }
            //anchors.horizontalCenter: (buttonlabel.text === "") ? parent.horizontalCenter : parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Text {
        id: buttonlabel

            font.family: subtitleFont.name
            font.pixelSize: vpx(16)
            font.bold: true
            color: theme.text
            //opacity: selected ? 1 : 0.2
            visible: text !== ""
            
            anchors { left: buttonicon.right; leftMargin: vpx(15) }
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Input handling
    Keys.onPressed: {
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
