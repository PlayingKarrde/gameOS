import QtQuick 2.0

Item {
id: root

    // NOTE: This is technically duplicated from utils.js but importing that file into every delegate causes crashes
    function steamAppID (gameData) {
        var str = gameData.assets.boxFront.split("header");
        return str[0];
    }
    function steamBoxArt(gameData) {
        return steamAppID(gameData) + '/library_600x900_2x.jpg';
    }
    function boxArt(data) {
        if (data != null) {
            if (data.assets.boxFront.includes("/header.jpg")) 
            return steamBoxArt(data);
            else {
            if (data.assets.boxFront != "")
                return data.assets.boxFront;
            else if (data.assets.poster != "")
                return data.assets.poster;
            else if (data.assets.banner != "")
                return data.assets.banner;
            else if (data.assets.tile != "")
                return data.assets.tile;
            else if (data.assets.cartridge != "")
                return data.assets.cartridge;
            else if (data.assets.logo != "")
                return data.assets.logo;
            }
        }
        return "";
    }

    property bool selected
    Behavior on scale { NumberAnimation { duration: 100 } }
    property var gameData
    property int columns: 6

    scale: selected ? 1.1 : 1
    z: selected ? 10 : 1

    signal activate()
    signal highlighted()
                       
    Image {
    id: screenshot
   
        anchors.fill: parent
        anchors.margins: vpx(6)

        asynchronous: true
        source: boxArt(gameData)
        sourceSize { width: 1920/columns; height: 1920/columns }
        fillMode: Image.PreserveAspectFit
        smooth: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
        id: favicon

            anchors { 
                right: parent.right; rightMargin: vpx(7); 
                top: parent.top; topMargin: vpx(7) 
            }
            width: vpx(20)
            height: width
            radius: width/2
            color: theme.accent
            visible: gameData.favorite
            Image {
                source: "../assets/images/favicon.svg"
                asynchronous: true
                anchors.fill: parent
                anchors.margins: vpx(4)            
            }
        }
    }

    Loader {
        active: selected
        width: screenshot.paintedWidth + vpx(4)
        height: screenshot.paintedHeight + vpx(4)
        anchors.centerIn: screenshot
        sourceComponent: border
        asynchronous: true
    }

    Component {
    id: border

        ItemBorder { }
    }

    Text {
    id: platformname

        text: modelData.title
        anchors { fill: parent; margins: vpx(10) }
        color: "white"
        scale: selected ? 1.1 : 1
        Behavior on opacity { NumberAnimation { duration: 100 } }
        font.pixelSize: vpx(18)
        font.family: subtitleFont.name
        font.bold: true
        style: Text.Outline; styleColor: theme.main
        visible: screenshot.paintedWidth === 0
        anchors.centerIn: parent
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
        lineHeight: 0.8
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    // List specific input
    Keys.onPressed: {
        // Accept
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            activate();        
        }
    }

    // Mouse/touch functionality
    MouseArea {
        anchors.fill: parent
        hoverEnabled: settings.MouseHover == "Yes"
        onEntered: { sfxNav.play(); highlighted(); }
        onClicked: {
            sfxNav.play();
            activate();
        }
    }
    
    /*// Mouse/touch functionality
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {}
        onExited: {}
        onClicked: {
            if (selected)
            {
                activate();
            }
            else
            {
                currentGameIndex = index
            }
        }
    }*/
}