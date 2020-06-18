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
import "../Lists"

FocusScope {
id: root

    property var collectionData
    property int itemWidth: vpx(150)
    property int itemHeight: itemWidth*1.5
    property alias currentIndex: collectionList.currentIndex
    property alias savedIndex: collectionList.savedIndex
    property alias title: collectiontitle.text
    property alias model: collectionList.model
    property alias delegate: collectionList.delegate
    property alias collectionList: collectionList
    property var search

    signal activate(int activeIndex)
    signal activateSelected
    signal listHighlighted

    Text {
    id: collectiontitle

        text: collectionData.name
        font.family: subtitleFont.name
        font.pixelSize: vpx(18)
        font.bold: true
        color: theme.text
        opacity: root.focus ? 1 : 0.2
        anchors { left: parent.left; leftMargin: vpx(10) }
    }

    ListView {
    id: collectionList

        focus: root.focus
        anchors {
            top: collectiontitle.bottom; topMargin: vpx(10)
            left: parent.left; 
            right: parent.right;
            bottom: parent.bottom
        }
        spacing: vpx(5)
        orientation: ListView.Horizontal
        preferredHighlightBegin: vpx(0)
        preferredHighlightEnd: parent.width - vpx(60)
        highlightRangeMode: ListView.ApplyRange
        snapMode: ListView.SnapOneItem 
        highlightMoveDuration: 100
        highlight: highlightcomponent
        displayMarginEnd: itemWidth*2
        keyNavigationWraps: true
        
        property int savedIndex: 0
        onFocusChanged: {
            if (focus)
                currentIndex = savedIndex;
            else {
                savedIndex = currentIndex;
                currentIndex = -1;
            }
                
        }

        currentIndex: focus ? savedIndex : -1
        Component.onCompleted: positionViewAtIndex(savedIndex, ListView.Visible)

        model: search.games ? search.games : api.allGames
        delegate: DynamicGridItem {
            selected: ListView.isCurrentItem && collectionList.focus
            width: itemWidth
            height: itemHeight
            
            onHighlighted: {
                collectionList.savedIndex = index;
                collectionList.currentIndex = index;
                listHighlighted();
            }

            onActivated: {
                if (selected) {
                    activateSelected();
                    gameDetails(search.currentGame(currentIndex));
                } else {
                    activate(index);
                    collectionList.currentIndex = index;
                }
            }
        }

        Component {
        id: highlightcomponent

            ItemHighlight {
                width: collectionList.cellWidth
                height: collectionList.cellHeight
                game: search ? search.currentGame(collectionList.currentIndex) : ""
                selected: collectionList.focus
            }
        }

        Keys.onLeftPressed: { sfxNav.play(); collectionList.decrementCurrentIndex() }
        Keys.onRightPressed: { sfxNav.play(); collectionList.incrementCurrentIndex() }
    }

}