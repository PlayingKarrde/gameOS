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
import SortFilterProxyModel 0.2
import QtGraphicalEffects 1.0
import QtMultimedia 5.9
import QtQml.Models 2.10
import "../Global"
import "../GridView"
import "../Lists"
import "../utils.js" as Utils

FocusScope {
id: root

    // Pull in our custom lists and define
    ListAllGames    { id: listNone;        max: 0 }
    ListAllGames    { id: listAllGames;    max: settings.ShowcaseColumns }
    ListFavorites   { id: listFavorites;   max: settings.ShowcaseColumns }
    ListLastPlayed  { id: listLastPlayed;  max: settings.ShowcaseColumns }
    ListMostPlayed  { id: listMostPlayed;  max: settings.ShowcaseColumns }
    ListRecommended { id: listRecommended; max: settings.ShowcaseColumns }
    ListPublisher   { id: listPublisher;   max: settings.ShowcaseColumns; publisher: randoPub }
    ListGenre       { id: listGenre;       max: settings.ShowcaseColumns; genre: randoGenre }

    property var featuredCollection: listFavorites
    property var collection1: getCollection(settings.ShowcaseCollection1, settings.ShowcaseCollection1_Thumbnail)
    property var collection2: getCollection(settings.ShowcaseCollection2, settings.ShowcaseCollection2_Thumbnail)
    property var collection3: getCollection(settings.ShowcaseCollection3, settings.ShowcaseCollection3_Thumbnail)
    property var collection4: getCollection(settings.ShowcaseCollection4, settings.ShowcaseCollection4_Thumbnail)
    property var collection5: getCollection(settings.ShowcaseCollection5, settings.ShowcaseCollection5_Thumbnail)

    function getCollection(collectionName, collectionThumbnail) {
        var collection = {
            enabled: true,
        };

        var width = root.width - globalMargin * 2;

        switch (collectionThumbnail) {
            case "Square":
                collection.itemWidth = (width / 6.0);
                collection.itemHeight = collection.itemWidth;
                break;
            case "Tall":
                collection.itemWidth = (width / 8.0);
                collection.itemHeight = collection.itemWidth / settings.TallRatio;
                break;
            case "Wide":
            default:
                collection.itemWidth = (width / 4.0);
                collection.itemHeight = collection.itemWidth * settings.WideRatio;
                break;
            
        }

        collection.height = collection.itemHeight + vpx(40) + globalMargin

        switch (collectionName) {
            case "Favorites":
                collection.search = listFavorites;
                break;
            case "Recently Played":
                collection.search = listLastPlayed;
                break;
            case "Most Played":
                collection.search = listMostPlayed;
                break;
            case "Recommended":
                collection.search = listRecommended;
                break;
            case "Top by Publisher":
                collection.search = listPublisher;
                break;
            case "Top by Genre":
                collection.search = listGenre;
                break;
            case "None":
                collection.enabled = false;
                collection.height = 0;

                collection.search = listNone;
                break;
            default:
                collection.search = listAllGames;
                break;
        }

        collection.title = collection.search.collection.name;
        return collection;
    }

    property string randoPub: (Utils.returnRandom(Utils.uniqueValuesArray('publisher')) || '')
    property string randoGenre: (Utils.returnRandom(Utils.uniqueValuesArray('genreList'))[0] || '').toLowerCase()

    property bool ftue: featuredCollection.games.count == 0

    function storeIndices(secondary) {
        storedHomePrimaryIndex = mainList.currentIndex;
        if (secondary)
            storedHomeSecondaryIndex = secondary;
    }

    Component.onDestruction: storeIndices();
    
    anchors.fill: parent

    Item {
    id: ftueContainer

        width: parent.width
        height: vpx(360)
        visible: ftue
        opacity: {
            switch (mainList.currentIndex) {
                case 0:
                    return 1;
                case 1:
                    return 0.3;
                case 2:
                    return 0.1;
                case -1:
                    return 0.3;
                default:
                    return 0
            }
        }
        Behavior on opacity { PropertyAnimation { duration: 1000; easing.type: Easing.OutQuart; easing.amplitude: 2.0; easing.period: 1.5 } }

        /*Image {
            anchors.fill: parent
            source: "../assets/images/ftueBG01.jpeg"
            sourceSize { width: root.width; height: root.height}
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: true
        }*/

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.5
        }

        Video {
        id: videocomponent

            anchors.fill: parent
            source: "../assets/video/ftue.mp4"
            fillMode: VideoOutput.PreserveAspectCrop
            muted: true
            loops: MediaPlayer.Infinite
            autoPlay: true

            OpacityAnimator {
                target: videocomponent;
                from: 0;
                to: 1;
                duration: 1000;
                running: true;
            }

        }

        Image {
        id: ftueLogo

            width: vpx(350)
            anchors { left: parent.left; leftMargin: globalMargin }
            source: "../assets/images/gameOS-logo.png"
            sourceSize { width: 350; height: 250}
            fillMode: Image.PreserveAspectFit
            smooth: true
            asynchronous: true
            anchors.centerIn: parent
        }

        Text {
            text: "Try adding some favorite games"
            
            horizontalAlignment: Text.AlignHCenter
            anchors { bottom: parent.bottom; bottomMargin: vpx(75) }
            width: parent.width
            height: contentHeight
            color: theme.text
            font.family: subtitleFont.name
            font.pixelSize: vpx(16)
            opacity: 0.5
            visible: false
        }
    }

    Item {
    id: header

        width: parent.width
        height: vpx(70)
        z: 10
        Image {
        id: logo

            width: vpx(150)
            anchors { left: parent.left; leftMargin: globalMargin }
            source: "../assets/images/gameOS-logo.png"
            sourceSize { width: 150; height: 100}
            fillMode: Image.PreserveAspectFit
            smooth: true
            asynchronous: true
            anchors.verticalCenter: parent.verticalCenter
            visible: !ftueContainer.visible
        }

        Rectangle {
        id: settingsbutton

            width: height
            height: vpx(40)
            anchors { right: parent.right; rightMargin: globalMargin }
            color: focus ? theme.accent : "white"
            radius: height/2
            opacity: focus ? 1 : 0.2
            anchors.verticalCenter: parent.verticalCenter
            onFocusChanged: {
                sfxNav.play()
                if (focus)
                    mainList.currentIndex = -1;
                else
                    mainList.currentIndex = 0;
            }

            Keys.onDownPressed: mainList.focus = true;
            Keys.onPressed: {
                // Accept
                if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                    event.accepted = true;
                    settingsScreen();            
                }
                // Back
                if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                    event.accepted = true;
                    mainList.focus = true;
                }
            }
            // Mouse/touch functionality
            MouseArea {
                anchors.fill: parent
                hoverEnabled: settings.MouseHover == "Yes"
                onEntered: settingsbutton.focus = true;
                onExited: settingsbutton.focus = false;
                onClicked: settingsScreen();
            }
        }

        Image {
        id: settingsicon

            width: height
            height: vpx(24)
            anchors.centerIn: settingsbutton
            smooth: true
            asynchronous: true
            source: "../assets/images/settingsicon.svg"
            opacity: root.focus ? 0.8 : 0.5
        }
    }

    // Using an object model to build the list
    ObjectModel {
    id: mainModel

        ListView {
        id: featuredlist

            property bool selected: ListView.isCurrentItem
            focus: selected
            width: parent.width
            height: vpx(360)
            spacing: vpx(0)
            orientation: ListView.Horizontal
            clip: true
            preferredHighlightBegin: vpx(0)
            preferredHighlightEnd: parent.width
            highlightRangeMode: ListView.StrictlyEnforceRange
            //highlightMoveDuration: 200
            highlightMoveVelocity: -1
            snapMode: ListView.SnapOneItem
            keyNavigationWraps: true
            currentIndex: (storedHomePrimaryIndex == 0) ? storedHomeSecondaryIndex : 0
            Component.onCompleted: positionViewAtIndex(currentIndex, ListView.Visible)
            
            model: !ftue ? featuredCollection.games : 0
            delegate: featuredDelegate

            Component {
            id: featuredDelegate

                Image {
                id: background

                    property bool selected: ListView.isCurrentItem && featuredlist.focus
                    width: featuredlist.width
                    height: featuredlist.height
                    source: Utils.fanArt(modelData);
                    sourceSize { width: featuredlist.width; height: featuredlist.height }
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                        
                    onSelectedChanged: {
                        if (selected)
                            logoAnim.start()
                    }

                    Rectangle {
                        
                        anchors.fill: parent
                        color: "black"
                        opacity: featuredlist.focus ? 0 : 0.5
                        Behavior on opacity { PropertyAnimation { duration: 150; easing.type: Easing.OutQuart; easing.amplitude: 2.0; easing.period: 1.5 } }
                    }

                    Image {
                    id: specialLogo

                        width: parent.height - vpx(20)
                        height: width
                        source: Utils.logo(modelData)
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        sourceSize { width: 256; height: 256 }
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: featuredlist.focus ? 1 : 0.5

                        PropertyAnimation { 
                        id: logoAnim; 
                            target: specialLogo; 
                            properties: "y"; 
                            from: specialLogo.y-vpx(50); 
                            duration: 100
                        }
                    }

                    // Mouse/touch functionality
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: settings.MouseHover == "Yes"
                        onEntered: { sfxNav.play(); mainList.currentIndex = 0; }
                        onClicked: {
                            if (selected)
                                gameDetails(modelData);  
                            else
                                mainList.currentIndex = 0;
                        }
                    }
                }
            }
            
            Row {
            id: blips

                anchors.horizontalCenter: parent.horizontalCenter
                anchors { bottom: parent.bottom; bottomMargin: vpx(20) }
                spacing: vpx(10)
                Repeater {
                    model: featuredlist.count
                    Rectangle {
                        width: vpx(10)
                        height: width
                        color: (featuredlist.currentIndex == index) && featuredlist.focus ? theme.accent : theme.text
                        radius: width/2
                        opacity: (featuredlist.currentIndex == index) ? 1 : 0.5
                    }
                }
            }

            // List specific input
            Keys.onUpPressed: settingsbutton.focus = true;
            Keys.onLeftPressed: { sfxNav.play(); decrementCurrentIndex() }
            Keys.onRightPressed: { sfxNav.play(); incrementCurrentIndex() }
            Keys.onPressed: {
                // Accept
                if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                    event.accepted = true;
                    storedHomeSecondaryIndex = featuredlist.currentIndex;
                    if (!ftue)
                        gameDetails(featuredCollection.currentGame(currentIndex));            
                }
            }
        }
        
        // Collections list
        ListView {
        id: platformlist

            property bool selected: ListView.isCurrentItem
            property int myIndex: ObjectModel.index
            focus: selected
            width: root.width
            height: vpx(100) + globalMargin * 2
            anchors {
                left: parent.left; leftMargin: globalMargin
                right: parent.right; rightMargin: globalMargin
            }
            spacing: vpx(10)
            orientation: ListView.Horizontal
            preferredHighlightBegin: vpx(0)
            preferredHighlightEnd: parent.width - vpx(60)
            highlightRangeMode: ListView.StrictlyEnforceRange
            snapMode: ListView.SnapOneItem
            highlightMoveDuration: 100
            keyNavigationWraps: true
            
            property int savedIndex: currentCollectionIndex
            onFocusChanged: {
                if (focus)
                    currentIndex = savedIndex;
                else {
                    savedIndex = currentIndex;
                    currentIndex = -1;
                }
            }

            Component.onCompleted: positionViewAtIndex(savedIndex, ListView.End)

            model: Utils.reorderCollection(api.collections);
            delegate: Rectangle {
                property bool selected: ListView.isCurrentItem && platformlist.focus
                width: (root.width - globalMargin * 2) / 7.0
                height: width * settings.WideRatio
                color: selected ? theme.accent : theme.secondary
                scale: selected ? 1.1 : 1
                Behavior on scale { NumberAnimation { duration: 100 } }
                border.width: vpx(1)
                border.color: "#19FFFFFF"

                anchors.verticalCenter: parent.verticalCenter

                Image {
                id: collectionlogo

                    anchors.fill: parent
                    anchors.centerIn: parent
                    anchors.margins: vpx(15)
                    source: "../assets/images/logospng/" + Utils.processPlatformName(modelData.shortName) + ".png"
                    sourceSize { width: 256; height: 128 }
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                    opacity: selected ? 1 : 0.2
                    scale: selected ? 1.1 : 1
                    Behavior on scale { NumberAnimation { duration: 100 } }
                }

                Text {
                id: platformname

                    text: modelData.name
                    anchors { fill: parent; margins: vpx(10) }
                    color: theme.text
                    opacity: selected ? 1 : 0.2
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                    font.pixelSize: vpx(18)
                    font.family: subtitleFont.name
                    font.bold: true
                    style: Text.Outline; styleColor: theme.main
                    visible: collectionlogo.status == Image.Error
                    anchors.centerIn: parent
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    lineHeight: 0.8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                // Mouse/touch functionality
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: settings.MouseHover == "Yes"
                    onEntered: { sfxNav.play(); mainList.currentIndex = platformlist.ObjectModel.index; platformlist.savedIndex = index; platformlist.currentIndex = index; }
                    onExited: {}
                    onClicked: {
                        if (selected)
                        {
                            currentCollectionIndex = index;
                            softwareScreen();
                        } else {
                            mainList.currentIndex = platformlist.ObjectModel.index;
                            platformlist.currentIndex = index;
                        }
                        
                    }
                }
            }

            // List specific input
            Keys.onLeftPressed: { sfxNav.play(); decrementCurrentIndex() }
            Keys.onRightPressed: { sfxNav.play(); incrementCurrentIndex() }
            Keys.onPressed: {
                // Accept
                if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                    event.accepted = true;
                    currentCollectionIndex = platformlist.currentIndex;
                    softwareScreen();            
                }
            }

        }

        HorizontalCollection {
        id: list1
            property bool selected: ListView.isCurrentItem
            property var currentList: list1
            property var collection: collection1

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: storedHomeSecondaryIndex = currentIndex;
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

        HorizontalCollection {
        id: list2
            property bool selected: ListView.isCurrentItem
            property var currentList: list2
            property var collection: collection2

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: storedHomeSecondaryIndex = currentIndex;
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

        HorizontalCollection {
        id: list3
            property bool selected: ListView.isCurrentItem
            property var currentList: list3
            property var collection: collection3

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: storedHomeSecondaryIndex = currentIndex;
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

        HorizontalCollection {
        id: list4
            property bool selected: ListView.isCurrentItem
            property var currentList: list4
            property var collection: collection4

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: storedHomeSecondaryIndex = currentIndex;
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

        HorizontalCollection {
        id: list5
            property bool selected: ListView.isCurrentItem
            property var currentList: list5
            property var collection: collection5

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: storedHomeSecondaryIndex = currentIndex;
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

    }

    ListView {
    id: mainList

        anchors.fill: parent
        model: mainModel
        focus: true
        highlightMoveDuration: 200
        highlightRangeMode: ListView.ApplyRange 
        preferredHighlightBegin: header.height
        preferredHighlightEnd: parent.height - (helpMargin * 2)
        snapMode: ListView.SnapOneItem
        keyNavigationWraps: true
        currentIndex: storedHomePrimaryIndex
        
        cacheBuffer: 1000
        footer: Item { height: helpMargin }

        Keys.onUpPressed: {
            sfxNav.play();
            do {
                decrementCurrentIndex();
            } while (!currentItem.enabled);
        }
        Keys.onDownPressed: {
            sfxNav.play();
            do {
                incrementCurrentIndex();
            } while (!currentItem.enabled);
        }
    }

    // Global input handling for the screen
    Keys.onPressed: {
        // Settings
        if (api.keys.isFilters(event) && !event.isAutoRepeat) {
            event.accepted = true;
            settingsScreen();
        }
    }

    // Helpbar buttons
    ListModel {
        id: gridviewHelpModel

        ListElement {
            name: "Settings"
            button: "filters"
        }
        ListElement {
            name: "Select"
            button: "accept"
        }
    }

    onFocusChanged: { 
        if (focus)
            currentHelpbarModel = gridviewHelpModel;
    }

}