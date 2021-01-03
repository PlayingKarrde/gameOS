// gameOS theme
// Copyright (C) 2018-2020 Seth Powell 
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.0
import "../utils.js" as Utils
import QtGraphicalEffects 1.0


FocusScope {
id: root

    property var game: currentGame
    focus: true

    // Background
    Image {
    id: screenshot

        anchors.fill: parent
        asynchronous: true
        property int randoScreenshotNumber: {
            if (game && settings.GameRandomBackground === "Yes")
                return Math.floor(Math.random() * game.assets.screenshotList.length);
            else
                return 0;
        }
        property int randoFanartNumber: {
            if (game && settings.GameRandomBackground === "Yes")
                return Math.floor(Math.random() * game.assets.backgroundList.length);
            else
                return 0;
        }

        property var randoScreenshot: game ? game.assets.screenshotList[randoScreenshotNumber] : ""
        property var randoFanart: game ? game.assets.backgroundList[randoFanartNumber] : ""
        property var actualBackground: (settings.GameBackground === "Screenshot") ? randoScreenshot : Utils.fanArt(game) || randoFanart;
        source: actualBackground || ""
        fillMode: Image.PreserveAspectCrop
        smooth: true
        Behavior on opacity { NumberAnimation { duration: 500 } }
    }

    // Scanlines
    Image {
    id: scanlines

        anchors.fill: parent
        source: "../assets/images/scanlines_v3.png"
        asynchronous: true
        opacity: 0.2
        visible: (settings.ShowScanlines == "Yes")
    }

    // Clear logo
    Image {
    id: logo

        width: vpx(500)
        height: vpx(500)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        sourceSize: Qt.size(parent.width, parent.height)
        source: game ? Utils.logo(game) : ""
        fillMode: Image.PreserveAspectFit
        asynchronous: true
    }

    DropShadow {
    id: logoshadow

        anchors.fill: logo
        horizontalOffset: 0
        verticalOffset: 0
        radius: 8.0
        samples: 12
        color: "#000000"
        source: logo
        opacity: 1
    }

    Item {
    id: container

        width: launchText.width + vpx(50)
        height: launchText.height + vpx(50)

        property real centerOffset: logo.paintedHeight/2
        
        anchors {
            top: logo.verticalCenter; topMargin: centerOffset + vpx(50)
            horizontalCenter: logo.horizontalCenter
        }
        
        //color: theme.secondary

        Rectangle {
        id: regborder

            anchors.fill: parent
            color: "black"
            border.width: vpx(1)
            border.color: "white"
            opacity: 0.2
            radius: height/2
        }

        Text {
        id: launchText

            text: "Press any button to return"//"Launching " + currentGame.title
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

    // Input handling
    Keys.onPressed: {

        // Back
        if (api.keys.isCancel(event) && !event.isAutoRepeat) {
            event.accepted = true;
            previousScreen();
        } else {
            previousScreen();
        }
    }

    // Mouse/touch functionality
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            previousScreen();
        }
    }
}