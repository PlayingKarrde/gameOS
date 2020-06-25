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

import QtQuick 2.3
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.12
import "../Global"
import "../Lists"
import "../utils.js" as Utils

FocusScope {
id: root

    // While not necessary to do it here, this means we don't need to change it in both
    // touch and gamepad functions each time
    function gameActivated() {
        storedCollectionGameIndex = gamegrid.currentIndex
        gameDetails(list.currentGame(gamegrid.currentIndex));
    }

    ListCollectionGames { id: list; }
    
    // Load settings
    property bool showBoxes: settings.GridThumbnail === "Box Art"
    property int numColumns: settings.GridColumns ? settings.GridColumns : 6

    GridSpacer {
    id: fakebox
        
        width: vpx(100); height: vpx(100)
        games: list.games
    }

    Rectangle {
    id: header

        anchors {
            top:    parent.top
            left:   parent.left
            right:  parent.right
        }
        height: vpx(75)
        color: theme.main
        z: 5

        HeaderBar {
        id: headercontainer
            
            anchors.fill: parent
        }
        Keys.onDownPressed: {
            sfxNav.play();
            gamegrid.focus = true;
            gamegrid.currentIndex = 0;
        }
    }

    Item {
    id: gridContainer
        
        anchors {
            top: header.bottom; topMargin: globalMargin
            left: parent.left; leftMargin: globalMargin
            right: parent.right; rightMargin: globalMargin
            bottom: parent.bottom; bottomMargin: globalMargin
        }        
        
        GridView {
        id: gamegrid
            
            // Figuring out the aspect ratio for box art
            property real cellHeightRatio: fakebox.paintedHeight / fakebox.paintedWidth
            property real savedCellHeight: {
                if (settings.GridThumbnail == "Tall") {
                    return cellWidth / settings.TallRatio;
                } else if (settings.GridThumbnail == "Square") {
                    return cellWidth;
                } else {
                    return cellWidth * settings.WideRatio;
                }
            }
            property var sourceThumbnail: showBoxes ? "BoxArtGridItem.qml" : "../Global/DynamicGridItem.qml"

            Component.onCompleted: {
                currentIndex = storedCollectionGameIndex;
                positionViewAtIndex(currentIndex, ListView.Visible);
            }

            populate: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
            }
                        
            anchors {
                top: parent.top; left: parent.left; right: parent.right;
                bottom: parent.bottom; bottomMargin: helpMargin + vpx(40)
            }
            cellWidth: width / numColumns
            cellHeight: (showBoxes) ? cellWidth * cellHeightRatio : savedCellHeight
            preferredHighlightBegin: vpx(0)
            preferredHighlightEnd: gamegrid.height - helpMargin - vpx(40)
            highlightRangeMode: GridView.ApplyRange  
            highlightMoveDuration: 200
            highlight: highlightcomponent
            keyNavigationWraps: false
            displayMarginBeginning: cellHeight * 2
            displayMarginEnd: cellHeight * 2

            model: list.games
            delegate: (showBoxes) ? boxartdelegate : dynamicDelegate

            Component {
            id: boxartdelegate
                
                BoxArtGridItem {
                    selected: GridView.isCurrentItem && root.focus
                    gameData: modelData
                    
                    width:      GridView.view.cellWidth
                    height:     GridView.view.cellHeight
                    
                    onActivate: {
                        if (selected)
                            gameActivated();
                        else
                            gamegrid.currentIndex = index;
                    }
                    onHighlighted: {
                        gamegrid.currentIndex = index;
                    }
                    Keys.onPressed: {
                        // Toggle favorite
                        if (api.keys.isDetails(event) && !event.isAutoRepeat) {
                            event.accepted = true;
                            sfxToggle.play();   
                            modelData.favorite = !modelData.favorite;
                        }
                    }

                }
            }

            Component {
            id: dynamicDelegate

                DynamicGridItem {
                id: dynamicdelegatecontainer

                    selected: GridView.isCurrentItem && root.focus
                    
                    width:      GridView.view.cellWidth
                    height:     GridView.view.cellHeight
                    
                    onActivated: {
                        if (selected)
                            gameActivated();
                        else
                            gamegrid.currentIndex = index;
                    }
                    onHighlighted: {
                        gamegrid.currentIndex = index;
                    }
                    Keys.onPressed: {
                        // Toggle favorite
                        if (api.keys.isDetails(event) && !event.isAutoRepeat) {
                            event.accepted = true;
                            sfxToggle.play();   
                            modelData.favorite = !modelData.favorite;
                        }
                    }
                }
            }

            Component {
            id: highlightcomponent

                ItemHighlight {
                    width: gamegrid.cellWidth
                    height: gamegrid.cellHeight
                    game: list.currentGame(gamegrid.currentIndex)
                    selected: gamegrid.focus
                    boxArt: showBoxes 
                }
            }

            // Manually set the navigation this way so audio can play without performance hits
            Keys.onUpPressed: { 
                sfxNav.play();
                if (currentIndex < numColumns) {
                    headercontainer.focus = true;
                    gamegrid.currentIndex = -1; 
                } else {
                    moveCurrentIndexUp();
                }
            }
            Keys.onDownPressed:     { sfxNav.play(); moveCurrentIndexDown() }
            Keys.onLeftPressed:     { sfxNav.play(); moveCurrentIndexLeft() }
            Keys.onRightPressed:    { sfxNav.play(); moveCurrentIndexRight() }
        }
        
    }

    Keys.onPressed: {
        // Accept
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (gamegrid.focus) {
                gameActivated();
            } else {
                gamegrid.currentIndex = 0;
                gamegrid.focus = true;
            }
            
        }
        // Back
        if (api.keys.isCancel(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (gamegrid.focus) {
                previousScreen();
            } else {
                gamegrid.focus = true;
            }
        }
        // Details
        if (api.keys.isFilters(event) && !event.isAutoRepeat) {
            event.accepted = true;
            sfxToggle.play();
            cycleSort();
        }
        // Next collection
        if (api.keys.isNextPage(event) && !event.isAutoRepeat) {
            event.accepted = true; 
            if (currentCollectionIndex < api.collections.count-1)
                currentCollectionIndex++;
            else
                currentCollectionIndex = 0;

            gamegrid.currentIndex = 0;
            sfxToggle.play();
        }
        // Previous collection
        if (api.keys.isPrevPage(event) && !event.isAutoRepeat) {
            event.accepted = true; 
            if (currentCollectionIndex > 0)
                currentCollectionIndex--;
            else
                currentCollectionIndex = api.collections.count-1;

            gamegrid.currentIndex = 0;
            sfxToggle.play();
        }
    }

    // Helpbar buttons
    ListModel {
        id: gridviewHelpModel

        ListElement {
            name: "Back"
            button: "cancel"
        }
        ListElement {
            name: "Toggle favorite"
            button: "details"
        }
        ListElement {
            name: "Filters"
            button: "filters"
        }
        ListElement {
            name: "View details"
            button: "accept"
        }
    }
    
    onFocusChanged: { 
        if (focus) {
            currentHelpbarModel = gridviewHelpModel; 
            gamegrid.focus = true;
        }
    }

}
