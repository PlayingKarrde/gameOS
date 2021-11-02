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
import SortFilterProxyModel 0.2
import QtMultimedia 5.9
import "VerticalList"
import "GridView"
import "Global"
import "GameDetails"
import "ShowcaseView"
import "Settings"

FocusScope {
id: root

    FontLoader { id: titleFont; source: "assets/fonts/SourceSansPro-Bold.ttf" }
    FontLoader { id: subtitleFont; source: "assets/fonts/OpenSans-Bold.ttf" }
    FontLoader { id: bodyFont; source: "assets/fonts/OpenSans-Semibold.ttf" }

    // Load settings
    property var settings: {
        return {
            PlatformView:                  api.memory.has("Game View") ? api.memory.get("Game View") : "Grid",
            GridThumbnail:                 api.memory.has("Grid Thumbnail") ? api.memory.get("Grid Thumbnail") : "Dynamic Wide",
            GridColumns:                   api.memory.has("Number of columns") ? api.memory.get("Number of columns") : "3",
            GameBackground:                api.memory.has("Game Background") ? api.memory.get("Game Background") : "Screenshot",
            GameLogo:                      api.memory.has("Game Logo") ? api.memory.get("Game Logo") : "Show",
            GameRandomBackground:          api.memory.has("Randomize Background") ? api.memory.get("Randomize Background") : "No",
            GameBlurBackground:            api.memory.has("Blur Background") ? api.memory.get("Blur Background") : "No",
            VideoPreview:                  api.memory.has("Video preview") ? api.memory.get("Video preview") : "Yes",
            AllowThumbVideo:               api.memory.has("Allow video thumbnails") ? api.memory.get("Allow video thumbnails") : "Yes",
            AllowThumbVideoAudio:          api.memory.has("Play video thumbnail audio") ? api.memory.get("Play video thumbnail audio") : "No",
            HideLogo:                      api.memory.has("Hide logo when thumbnail video plays") ? api.memory.get("Hide logo when thumbnail video plays") : "No",
            HideButtonHelp:                api.memory.has("Hide button help") ? api.memory.get("Hide button help") : "No",
            MouseHover:                    api.memory.has("Enable mouse hover") ? api.memory.get("Enable mouse hover") : "No",
            AlwaysShowTitles:              api.memory.has("Always show titles") ? api.memory.get("Always show titles") : "No",
            AnimateHighlight:              api.memory.has("Animate highlight") ? api.memory.get("Animate highlight") : "No",
            AllowVideoPreviewAudio:        api.memory.has("Video preview audio") ? api.memory.get("Video preview audio") : "No",
            ShowScanlines:                 api.memory.has("Show scanlines") ? api.memory.get("Show scanlines") : "Yes",
            DetailsDefault:                api.memory.has("Default to full details") ? api.memory.get("Default to full details") : "No",
            ShowcaseColumns:               api.memory.has("Number of games showcased") ? api.memory.get("Number of games showcased") : "15",
            ShowcaseFeaturedCollection:    api.memory.has("Featured collection") ? api.memory.get("Featured collection") : "Favorites",
            ShowcaseCollection1:           api.memory.has("Collection 1") ? api.memory.get("Collection 1") : "Recently Played",
            ShowcaseCollection1_Thumbnail: api.memory.has("Collection 1 - Thumbnail") ? api.memory.get("Collection 1 - Thumbnail") : "Wide",
            ShowcaseCollection2:           api.memory.has("Collection 2") ? api.memory.get("Collection 2") : "Most Played",
            ShowcaseCollection2_Thumbnail: api.memory.has("Collection 2 - Thumbnail") ? api.memory.get("Collection 2 - Thumbnail") : "Tall",
            ShowcaseCollection3:           api.memory.has("Collection 3") ? api.memory.get("Collection 3") : "Top by Publisher",
            ShowcaseCollection3_Thumbnail: api.memory.has("Collection 3 - Thumbnail") ? api.memory.get("Collection 3 - Thumbnail") : "Wide",
            ShowcaseCollection4:           api.memory.has("Collection 4") ? api.memory.get("Collection 4") : "Top by Genre",
            ShowcaseCollection4_Thumbnail: api.memory.has("Collection 4 - Thumbnail") ? api.memory.get("Collection 4 - Thumbnail") : "Tall",
            ShowcaseCollection5:           api.memory.has("Collection 5") ? api.memory.get("Collection 5") : "None",
            ShowcaseCollection5_Thumbnail: api.memory.has("Collection 5 - Thumbnail") ? api.memory.get("Collection 5 - Thumbnail") : "Wide",
            WideRatio:                     api.memory.has("Wide - Ratio") ? api.memory.get("Wide - Ratio") : "0.64",
            TallRatio:                     api.memory.has("Tall - Ratio") ? api.memory.get("Tall - Ratio") : "0.66"
            
        }
    }

    // Collections
    property int currentCollectionIndex: 0
    property int currentGameIndex: 0
    property var currentCollection: api.collections.get(currentCollectionIndex)    
    property var currentGame

    // Stored variables for page navigation
    property int storedHomePrimaryIndex: 0
    property int storedHomeSecondaryIndex: 0
    property int storedCollectionIndex: 0
    property int storedCollectionGameIndex: 0

    // Reset the stored game index when changing collections
    onCurrentCollectionIndexChanged: storedCollectionGameIndex = 0

    // Filtering options
    property bool showFavs: false
    property var sortByFilter: ["sortBy", "lastPlayed", "playCount", "rating"]
    property int sortByIndex: 0
    property var orderBy: Qt.AscendingOrder
    property string searchTerm: ""
    property bool steam: currentCollection.name === "Steam"
    function steamExists() {
        for (i = 0; i < api.collections.count; i++) {
            if (api.collections.get(i).name === "Steam") {
                return true;
            }
            return false;
        }
    }

    // Functions for switching currently active collection
    function toggleFavs() {
        showFavs = !showFavs;
    }

    function cycleSort() {
        if (sortByIndex < sortByFilter.length - 1)
            sortByIndex++;
        else
            sortByIndex = 0;
    }

    function toggleOrderBy() {
        if (orderBy === Qt.AscendingOrder)
            orderBy = Qt.DescendingOrder;
        else
            orderBy = Qt.AscendingOrder;
    }

    // Launch the current game
    function launchGame(game) {
        if (game !== null) {
            //if (game.collections.get(0).name === "Steam")
                launchGameScreen();

            saveCurrentState(game);
            game.launch();
        } else {
            //if (currentGame.collections.get(0).name === "Steam")
                launchGameScreen();

            saveCurrentState(currentGame);
            currentGame.launch();
        }
    }

    // Save current states for returning from game
    function saveCurrentState(game) {
        api.memory.set('savedState', root.state);
        api.memory.set('savedCollection', currentCollectionIndex);
        api.memory.set('lastState', JSON.stringify(lastState));
        api.memory.set('lastGame', JSON.stringify(lastGame));
        api.memory.set('storedHomePrimaryIndex', storedHomePrimaryIndex);
        api.memory.set('storedHomeSecondaryIndex', storedHomeSecondaryIndex);
        api.memory.set('storedCollectionIndex', currentCollectionIndex);
        api.memory.set('storedCollectionGameIndex', storedCollectionGameIndex);

        const savedGameIndex = api.allGames.toVarArray().findIndex(g => g === game);
        api.memory.set('savedGame', savedGameIndex);

        api.memory.set('To Game', 'True');
    }

    // Handle loading settings when returning from a game
    property bool fromGame: api.memory.has('To Game');
    function returnedFromGame() {
        lastState                   = JSON.parse(api.memory.get('lastState'));
        lastGame                    = JSON.parse(api.memory.get('lastGame'));
        currentCollectionIndex      = api.memory.get('savedCollection');
        storedHomePrimaryIndex      = api.memory.get('storedHomePrimaryIndex');
        storedHomeSecondaryIndex    = api.memory.get('storedHomeSecondaryIndex');
        currentCollectionIndex      = api.memory.get('storedCollectionIndex');
        storedCollectionGameIndex   = api.memory.get('storedCollectionGameIndex');

        currentGame                 = api.allGames.get(api.memory.get('savedGame'));
        root.state                  = api.memory.get('savedState');

        // Remove these from memory so as to not clog it up
        api.memory.unset('savedState');
        api.memory.unset('savedGame');
        api.memory.unset('lastState');
        api.memory.unset('lastGame');
        api.memory.unset('storedHomePrimaryIndex');
        api.memory.unset('storedHomeSecondaryIndex');
        api.memory.unset('storedCollectionIndex');
        api.memory.unset('storedCollectionGameIndex');

        // Remove this one so we only have it when we come back from the game and not at Pegasus launch
        api.memory.unset('To Game');
    }

    // Theme settings
    property var theme: {
        return {
            main:           "#1d253d",
            secondary:      "#202a44",
            accent:         "#f00980",
            highlight:      "#f00980",
            text:           "#ececec",
            button:         "#f00980",
            gradientstart:  "#000d111d",
            gradientend:    "#FF0d111d"
        }
    }

    property real globalMargin: vpx(30)
    property real helpMargin: buttonbar.height
    property int transitionTime: 100

    // State settings
    states: [
        State {
            name: "softwarescreen";
        },
        State {
            name: "softwaregridscreen";
        },
        State {
            name: "showcasescreen";
        },
        State {
            name: "gameviewscreen";
        },
        State {
            name: "settingsscreen";
        },
        State {
            name: "launchgamescreen";
        }
    ]

    property var lastState: []
    property var lastGame: []

    // Screen switching functions
    function softwareScreen() {
        sfxAccept.play();
        lastState.push(state);
        searchTerm = "";
        switch(settings.PlatformView) {
            case "Grid":
                root.state = "softwaregridscreen";
                break;
            default:
                root.state = "softwarescreen";
        }
    }

    function showcaseScreen() {
        sfxAccept.play();
        lastState.push(state);
        root.state = "showcasescreen";
    }

    function gameDetails(game) {
        sfxAccept.play();
        // As long as there is a state history, save the last game
        if (lastState.length != 0)
            lastGame.push(currentGame);

        // Push the new game
        if (game !== null)
            currentGame = game;

        // Save the state before pushing the new one
        lastState.push(state);
        root.state = "gameviewscreen";
    }

    function settingsScreen() {
        sfxAccept.play();
        lastState.push(state);
        root.state = "settingsscreen";
    }

    function launchGameScreen() {
        sfxAccept.play();
        lastState.push(state);
        root.state = "launchgamescreen";
    }

    function previousScreen() {
        sfxBack.play();
        if (state == lastState[lastState.length-1])
            popLastGame();

        state = lastState[lastState.length - 1];
        lastState.pop();
    }

    function popLastGame() {
        if (lastGame.length) {
            currentGame = lastGame[lastGame.length-1];
            lastGame.pop();
        }
    }

    // Set default state to the platform screen
    Component.onCompleted: { 
        root.state = "showcasescreen";

        if (fromGame)
            returnedFromGame();
    }

    // Background
    Rectangle {
    id: background
        
        anchors.fill: parent
        color: theme.main
    }

    Loader  {
    id: showcaseLoader

        focus: (root.state === "showcasescreen")
        active: opacity !== 0
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: showcaseview
        asynchronous: true
    }

    Loader  {
    id: gridviewloader

        focus: (root.state === "softwaregridscreen")
        active: opacity !== 0
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: gridview
        asynchronous: true
    }

    Loader  {
    id: listviewloader

        focus: (root.state === "softwarescreen")
        active: opacity !== 0
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: listview
        asynchronous: true
    }

    Loader  {
    id: gameviewloader

        focus: (root.state === "gameviewscreen")
        active: opacity !== 0
        onActiveChanged: if (!active) popLastGame();
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: gameview
        asynchronous: true
        //game: currentGame
    }

    Loader  {
    id: launchgameloader

        focus: (root.state === "launchgamescreen")
        active: opacity !== 0
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: launchgameview
        asynchronous: true
    }

    Loader  {
    id: settingsloader

        focus: (root.state === "settingsscreen")
        active: opacity !== 0
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: settingsview
        asynchronous: true
    }

    Component {
    id: showcaseview

        ShowcaseViewMenu { focus: true }
    }

    Component {
    id: gridview

        GridViewMenu { focus: true }
    }

    Component {
    id: listview

        SoftwareListMenu { focus: true }
    }

    Component {
    id: gameview

        GameView {
            focus: true
            game: currentGame
        }
    }

    Component {
    id: launchgameview

        LaunchGame { focus: true }
    }

    Component {
    id: settingsview

        SettingsScreen { focus: true }
    }

    
    // Button help
    property var currentHelpbarModel
    ButtonHelpBar {
    id: buttonbar

        height: vpx(50)
        anchors {
            left: parent.left; right: parent.right; rightMargin: globalMargin
            bottom: parent.bottom
        }
        visible: settings.HideButtonHelp === "No"
    }

    ///////////////////
    // SOUND EFFECTS //
    ///////////////////
    SoundEffect {
        id: sfxNav
        source: "assets/sfx/navigation.wav"
        volume: 1.0
    }

    SoundEffect {
        id: sfxBack
        source: "assets/sfx/back.wav"
        volume: 1.0
    }

    SoundEffect {
        id: sfxAccept
        source: "assets/sfx/accept.wav"
    }

    SoundEffect {
        id: sfxToggle
        source: "assets/sfx/toggle.wav"
    }
    
}

