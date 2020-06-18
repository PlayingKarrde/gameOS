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