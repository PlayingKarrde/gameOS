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
import QtGraphicalEffects 1.0

Item {
id: root

    Image {
    id: border

        anchors.fill: parent
        source: "../assets/images/gradient.png"
        asynchronous: true
        visible: false
        
        // Highlight animation (ColorOverlay causes graphical glitches on W10)
        Rectangle {
            anchors.fill: parent
            color: "#fff"
            visible: settings.AnimateHighlight === "Yes"
            SequentialAnimation on opacity {
            id: colorAnim

                running: true
                loops: Animation.Infinite
                NumberAnimation { to: 1; duration: 200; }
                NumberAnimation { to: 0; duration: 500; }
                PauseAnimation { duration: 200 }
            }
        }
    }

    BorderImage {
    id: mask

        anchors.fill: parent
        source: "../assets/images/borderimage.gif"
        border { left: vpx(5); right: vpx(5); top: vpx(5); bottom: vpx(5);}
        smooth: false
        visible: false
    }

    OpacityMask {
        anchors.fill: border
        source: border
        maskSource: mask
        visible: selected
    }

    Rectangle {
    id: titlecontainer

        width: bubbletitle.contentWidth + vpx(20)
        height: bubbletitle.contentHeight + vpx(8)
        color: theme.secondary
        anchors {
            top: border.bottom; topMargin: vpx(7)
        }
        anchors.horizontalCenter: parent.horizontalCenter
        radius: height/2
        opacity: selected ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }
        visible: opacity !== 0

        Text {
        id: bubbletitle

            text: modelData.title
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