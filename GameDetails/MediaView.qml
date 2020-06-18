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
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0
import QtQml.Models 2.10
import QtMultimedia 5.9
import "../Global"

FocusScope {
id: root

    signal close
    property var mediaModel: []
    property int mediaIndex: 0
    property bool isVideo: mediaModel.length ? mediaModel[mediaIndex].includes(".mp4") || mediaModel[mediaIndex].includes(".webm") : false

    function next() {
        if (mediaIndex == mediaModel.length-1)
            mediaIndex = 0;
        else
            mediaIndex++;
    }
    function prev() {
        if (mediaIndex == 0)
            mediaIndex = mediaModel.length-1;
        else
            mediaIndex--;
    }
    
    Rectangle {
        
        anchors.fill: parent
        color: "black"
        opacity: 0.95
    }

    Component {
    id: videoWrapper

        Video {
            source: isVideo ? mediaModel[mediaIndex] : ""
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectFit
            muted: false
            autoPlay: true
        }

    }

    // Video
    Loader {
    id: videoLoader
        
        sourceComponent: root.focus && isVideo ? videoWrapper : undefined
        asynchronous: true
        anchors { fill: parent }
    }
    
    ListView {
    id: medialist

        focus: true
        currentIndex: mediaIndex
        onCurrentIndexChanged: mediaIndex = currentIndex;
        anchors.fill: parent
        orientation: ListView.Horizontal
        clip: true
        preferredHighlightBegin: vpx(0)
        preferredHighlightEnd: parent.width
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 200
        snapMode: ListView.SnapOneItem
        keyNavigationWraps: true
        model: mediaModel
        delegate: Image {
        id: imageholder

            width: root.width
            height: root.height
            source: modelData.includes(".mp4") || modelData.includes(".webm") ? "" : modelData
            smooth: true
            fillMode: Image.PreserveAspectFit
            visible: !isVideo
        }
        Keys.onLeftPressed: { sfxNav.play(); decrementCurrentIndex() }
        Keys.onRightPressed: { sfxNav.play(); incrementCurrentIndex() }
    }

    Row {
    id: blips

        anchors.horizontalCenter: parent.horizontalCenter
        anchors { bottom: parent.bottom; bottomMargin: vpx(20) }
        spacing: vpx(10)
        Repeater {
            model: medialist.count
            Rectangle {
                width: vpx(10)
                height: width
                color: (medialist.currentIndex == index) ? theme.accent : theme.text
                radius: width/2
                opacity: (medialist.currentIndex == index) ? 1 : 0.5
            }
        }
    }

    // Mouse/touch functionality
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {}
        onExited: {}
        onClicked: close();
    }

    // Input handling
    Keys.onPressed: {
        // Back
        if (api.keys.isCancel(event) && !event.isAutoRepeat) {
            event.accepted = true;
            close();
        }
        // Accept
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            close();
        }
    }

    // Helpbar buttons
    ListModel {
        id: mediaviewHelpModel

        ListElement {
            name: "Back"
            button: "cancel"
        }
    }
    
    onFocusChanged: { 
        if (focus) { 
            currentHelpbarModel = mediaviewHelpModel;
        }
    }
}