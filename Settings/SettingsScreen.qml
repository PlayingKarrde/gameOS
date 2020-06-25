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

FocusScope {
id: root

    ListModel {
    id: settingsModel

        /*ListElement {
            settingName: "Game View"
            setting: "Grid,Vertical List"
        }*/
        ListElement {
            settingName: "Allow video thumbnails"
            setting: "Yes,No"
        }
        ListElement {
            settingName: "Play video thumbnail audio"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Hide logo when thumbnail video plays"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Animate highlight"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Enable mouse hover"
            setting: "No,Yes"
        }
    }

    property var generalPage: {
        return {
            pageName: "General",
            listmodel: settingsModel
        }
    }

    ListModel {
        id: advancedSettingsModel
        ListElement {
            settingName: "Wide - Ratio"
            setting: "0.64,0.65,0.66,0.67,0.68,0.69,0.70,0.71,0.72,0.73,0.74,0.75,0.76,0.77,0.78,0.79,0.80,0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.20,0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.30,0.31,0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.40,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.50,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.60,0.61,0.62,0.63"
        }
        ListElement {
            settingName: "Tall - Ratio"
            setting: "0.66,0.67,0.68,0.69,0.7,0.71,0.72,0.73,0.74,0.75,0.76,0.77,0.78,0.79,0.80,0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.20,0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.30,0.31,0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.40,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.50,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.60,0.61,0.62,0.63,0.64,0.65"
        }
    }

    property var advancedPage: {
        return {
            pageName: "Advanced",
            listmodel: advancedSettingsModel
        }
    }

    ListModel {
    id: showcaseSettingsModel
        ListElement {
            settingName: "Number of games showcased"
            setting: "15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,1,2,3,4,5,6,7,8,9,10,11,12,13,14"
        }
        ListElement {
            settingName: "Collection 1"
            setting: "Recently Played,Most Played,Recommended,Top by Publisher,Top by Genre,None,Favorites"
        }
        ListElement {
            settingName: "Collection 1 - Thumbnail"
            setting: "Wide,Tall,Square"
        }
        ListElement {
            settingName: "Collection 2"
            setting: "Most Played,Recommended,Top by Publisher,Top by Genre,None,Favorites,Recently Played"
        }
        ListElement {
            settingName: "Collection 2 - Thumbnail"
            setting: "Tall,Square,Wide"
        }
        ListElement {
            settingName: "Collection 3"
            setting: "Top by Publisher,Top by Genre,None,Favorites,Recently Played,Most Played,Recommended"
        }
        ListElement {
            settingName: "Collection 3 - Thumbnail"
            setting: "Wide,Tall,Square"
        }
        ListElement {
            settingName: "Collection 4"
            setting: "Top by Genre,None,Favorites,Recently Played,Most Played,Recommended,Top by Publisher"
        }
        ListElement {
            settingName: "Collection 4 - Thumbnail"
            setting: "Tall,Square,Wide"
        }
        ListElement {
            settingName: "Collection 5"
            setting: "None,Favorites,Recently Played,Most Played,Recommended,Top by Publisher,Top by Genre"
        }
        ListElement {
            settingName: "Collection 5 - Thumbnail"
            setting: "Wide,Tall,Square"
        }

    }

    property var showcasePage: {
        return {
            pageName: "Home page",
            listmodel: showcaseSettingsModel
        }
    }

    ListModel {
    id: gridSettingsModel

        ListElement {
            settingName: "Grid Thumbnail"
            setting: "Wide,Tall,Square,Box Art"
        }
        ListElement {
            settingName: "Number of columns"
            setting: "3,4,5,6,7,8"
        }
    }

    property var gridPage: {
        return {
            pageName: "Platform page",
            listmodel: gridSettingsModel
        }
    }

    ListModel {
    id: gameSettingsModel

        ListElement {
            settingName: "Game Background"
            setting: "Screenshot,Fanart"
        }
        ListElement {
            settingName: "Game Logo"
            setting: "Show,Text only,Hide"
        }
        ListElement {
            settingName: "Default to full details"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Video preview"
            setting: "Yes,No"
        }
        ListElement {
            settingName: "Video preview audio"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Randomize Background"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Blur Background"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Show scanlines"
            setting: "Yes,No"
        }
    }

    property var gamePage: {
        return {
            pageName: "Game details",
            listmodel: gameSettingsModel
        }
    }

    property var settingsArr: [generalPage, showcasePage, gridPage, gamePage, advancedPage]

    property real itemheight: vpx(50)

    Rectangle {
    id: header

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: vpx(75)
        color: theme.main
        z: 5

        // Platform title
        Text {
        id: headertitle
            
            text: "Settings"
            
            anchors {
                top: parent.top;
                left: parent.left; leftMargin: globalMargin
                right: parent.right
                bottom: parent.bottom
            }
            
            color: theme.text
            font.family: titleFont.name
            font.pixelSize: vpx(30)
            font.bold: true
            horizontalAlignment: Text.AlignHLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

            // Mouse/touch functionality
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    previousScreen();
                }
            }
        }
    }

    ListView {
    id: pagelist
    
        focus: true
        anchors {
            top: header.bottom
            bottom: parent.bottom; bottomMargin: helpMargin
            left: parent.left; leftMargin: globalMargin
        }
        width: vpx(300)
        model: settingsArr
        delegate: Component {
        id: pageDelegate
        
            Item {
            id: pageRow

                property bool selected: ListView.isCurrentItem

                width: ListView.view.width
                height: itemheight

                // Page name
                Text {
                id: oageNameText
                
                    text: modelData.pageName
                    color: theme.text
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(22)
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    opacity: selected ? 1 : 0.2

                    width: contentWidth
                    height: parent.height
                    anchors {
                        left: parent.left; leftMargin: vpx(25)
                    }
                }

                // Mouse/touch functionality
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: settings.MouseHover == "Yes"
                    onEntered: { sfxNav.play(); }
                    onClicked: {
                        sfxNav.play();
                        pagelist.currentIndex = index;
                        settingsList.focus = true;
                    }
                }

            }
        } 

        Keys.onUpPressed: { sfxNav.play(); decrementCurrentIndex() }
        Keys.onDownPressed: { sfxNav.play(); incrementCurrentIndex() }
        Keys.onPressed: {
            // Accept
            if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                event.accepted = true;
                sfxAccept.play();
                settingsList.focus = true;
            }
            // Back
            if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                event.accepted = true;
                previousScreen();
            }
        }

    }

    Rectangle {
        anchors {
            left: pagelist.right;
            top: pagelist.top; bottom: pagelist.bottom
        }
        width: vpx(1)
        color: theme.text
        opacity: 0.1
    }

    ListView {
    id: settingsList

        model: settingsArr[pagelist.currentIndex].listmodel
        delegate: settingsDelegate
        
        anchors {
            top: header.bottom; bottom: parent.bottom; 
            left: pagelist.right; leftMargin: globalMargin
            right: parent.right; rightMargin: globalMargin
        }
        width: vpx(500)

        spacing: vpx(0)
        orientation: ListView.Vertical

        preferredHighlightBegin: settingsList.height / 2 - itemheight
        preferredHighlightEnd: settingsList.height / 2
        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 100
        clip: true

        Component {
        id: settingsDelegate
        
            Item {
            id: settingRow

                property bool selected: ListView.isCurrentItem && settingsList.focus
                property variant settingList: setting.split(',')
                property int savedIndex: api.memory.get(settingName + 'Index') || 0

                function saveSetting() {
                    api.memory.set(settingName + 'Index', savedIndex);
                    api.memory.set(settingName, settingList[savedIndex]);
                }

                function nextSetting() {
                    if (savedIndex != settingList.length -1)
                        savedIndex++;
                    else
                        savedIndex = 0;
                }

                function prevSetting() {
                    if (savedIndex > 0)
                        savedIndex--;
                    else
                        savedIndex = settingList.length -1;
                }

                width: ListView.view.width
                height: itemheight

                // Setting name
                Text {
                id: settingNameText
                
                    text: settingName + ": "
                    color: theme.text
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(20)
                    verticalAlignment: Text.AlignVCenter
                    opacity: selected ? 1 : 0.2

                    width: contentWidth
                    height: parent.height
                    anchors {
                        left: parent.left; leftMargin: vpx(25)
                    }
                }
                // Setting value
                Text { 
                id: settingtext; 
                
                    text: settingList[savedIndex]; 
                    color: theme.text
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(20)
                    verticalAlignment: Text.AlignVCenter
                    opacity: selected ? 1 : 0.2

                    height: parent.height
                    anchors {
                        right: parent.right; rightMargin: vpx(25)
                    }
                }

                Rectangle {
                    anchors { 
                        left: parent.left; leftMargin: vpx(25)
                        right: parent.right; rightMargin: vpx(25)
                        bottom: parent.bottom
                    }
                    color: theme.text
                    opacity: selected ? 0.1 : 0
                    height: vpx(1)
                }

                // Input handling
                // Next setting
                Keys.onRightPressed: {
                    sfxToggle.play()
                    nextSetting();
                    saveSetting();
                }
                // Previous setting
                Keys.onLeftPressed: {
                    sfxToggle.play();
                    prevSetting();
                    saveSetting();
                }

                Keys.onPressed: {
                    // Accept
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        sfxToggle.play()
                        nextSetting();
                        saveSetting();
                    }
                    // Back
                    if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        sfxBack.play()
                        pagelist.focus = true;
                    }
                }

                // Mouse/touch functionality
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: settings.MouseHover == "Yes"
                    onEntered: { sfxNav.play(); }
                    onClicked: {
                        sfxToggle.play();
                        if(selected){ 
                            nextSetting();
                            saveSetting();
                        } else {
                            settingsList.focus = true;
                            settingsList.currentIndex = index;
                        }
                    }
                }
            }
        } 

        Keys.onUpPressed: { sfxNav.play(); decrementCurrentIndex() }
        Keys.onDownPressed: { sfxNav.play(); incrementCurrentIndex() }
    }

    // Helpbar buttons
    ListModel {
        id: settingsHelpModel

        ListElement {
            name: "Back"
            button: "cancel"
        }
    }
    
    onFocusChanged: { if (focus) currentHelpbarModel = settingsHelpModel; }

}