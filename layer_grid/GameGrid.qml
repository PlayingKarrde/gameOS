import QtQuick 2.8
import QtMultimedia 5.9
import QtGraphicalEffects 1.12

FocusScope {
  id: root

  // SETTINGS
  property int numColumns : api.memory.get('settingGridNumColumns') || 4

  property alias gridWidth: grid.width
  property int gridItemSpacing: (numColumns == 4) ? vpx(10) : vpx(15) // it will double this
  property int gridItemHeight: (numColumns == 4) ? vpx(180) : vpx(230)
  property var collectionData: currentCollection
  property var gameData: currentGame
  property bool mainScreenDetails
  property int currentGameIdx: currentGameIndex
  property string jumpToPattern: ''
  property real cornerradius: vpx(4)
  property real borderWidth: vpx(5)
  property real itemBottomMargin: vpx(40)

  signal launchRequested
  signal menuRequested
  signal detailsRequested
  signal filtersRequested
  signal collectionNext
  signal collectionPrev
  signal toggleFilter
  signal gameChanged(int currentIdx)

  Keys.onPressed: {
      if (event.isAutoRepeat)
          return;

      if (api.keys.isDetails(event)) {
          event.accepted = true;
          //toggleFilters();
          //toggleFav();
          return;
      }
      if (api.keys.isCancel(event)) {
          event.accepted = true;
          menuRequested();
          return;
        }
      if (api.keys.isFilters(event)) {
          event.accepted = true;
          toggleFilter();
          //toggleFilters()
          //filtersRequested();
          return;
      }
  }

  //property bool isFavorite: (gameData && gameData.favorite) || false
  /*function toggleFav() {
      if (gameData)
          gameData.favorite = !gameData.favorite;

      toggleSound.play()

  }*/

  /*function toggleFilters() {
    if (api.filters.favorite) {
      api.filters.playerCount = 1
      api.filters.favorite = false
      api.filters.current.enabled = false
    } else {
      api.filters.playerCount = 1
      api.filters.favorite = true
      api.filters.current.enabled = true
    }

  }*/

  onCurrentGameIdxChanged: {
    grid.currentIndex = currentGameIdx
  }

  // Highlight
  // NOTE: Used to show the video player
  Component {
    id: highlight
    Rectangle {
      id: highlightBorder
      width: GridView.view.cellWidth + (borderWidth*2)
      height: grid.currentItem.height - vpx(30)

      x: grid.currentItem.x - borderWidth
      y: grid.currentItem.y - borderWidth
      Behavior on x { SmoothedAnimation { duration: 100 } }
      Behavior on y { SmoothedAnimation { duration: 100 } }
      color: themeColour
      radius: cornerradius + vpx(3)

      //scale: grid.currentItem.scale
      Behavior on scale { NumberAnimation { duration: 100} }

      // Highlight animation (ColorOverlay causes graphical glitches on W10)
      Rectangle {
        anchors.fill: parent
        color: "#fff"
        radius: cornerradius + vpx(3)
        SequentialAnimation on opacity {
          id: colorAnim
          running: true
          loops: Animation.Infinite
          NumberAnimation { to: 1; duration: 200; }
          NumberAnimation { to: 0; duration: 500; }
          PauseAnimation { duration: 200 }
        }
      }


      // DropShadow
      layer.enabled: true
      layer.effect: DropShadow {
          horizontalOffset: 0
          verticalOffset: 0
          radius: 10.0
          samples: 17
          color: "#80000000"
          transparentBorder: true
      }

      Video {
        id: videoThumb
        property bool playVideo: stateHome
        source: gameData.assets.videos.length ? gameData.assets.videos[0] : ""
        anchors.fill: parent
        anchors.margins: borderWidth
        fillMode: VideoOutput.PreserveAspectCrop
        muted: true
        volume: playVideo ? 0.5 : 0
        //Behavior on volume { NumberAnimation { duration: 200 } }
        onPlayVideoChanged: {
          if (stateHome)
            play();
          else
            pause();
        }
        loops: MediaPlayer.Infinite
        autoPlay: true

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: videoThumb.width
                height: videoThumb.height
                Rectangle {
                    anchors.centerIn: parent
                    width: videoThumb.width
                    height: videoThumb.height
                    radius: cornerradius
                }
            }
        }//OpacityMask

      }//Video

    }

  }


  GridView {
    id: grid

    focus: true

    anchors {
      top: parent.top; topMargin: - gridItemSpacing
      bottom: parent.bottom
    }

    anchors.horizontalCenter: parent.horizontalCenter

    cellWidth: grid.width/numColumns
    cellHeight: gridItemHeight
    header: headerSpace
    preferredHighlightBegin: vpx(0)
    preferredHighlightEnd: mainScreenDetails ? gridItemHeight * 2 : gridItemHeight * 3
    highlightRangeMode: GridView.ApplyRange
    //displayMarginBeginning: vpx(300)
    highlight: highlight
    snapMode: GridView.SnapOneRow
    highlightFollowsCurrentItem: false
    cacheBuffer: 9000

    model: collectionData ? collectionData.games : []
    onCurrentIndexChanged: {
      //if (api.currentCollection) api.currentCollection.games.index = currentIndex;
      navSound.play()
      changeGameTimer.restart();
      return;
    }

    Timer {
      id: changeGameTimer
      running: true
      repeat: false
      interval: 200
      onTriggered: { gameChanged(grid.currentIndex); }
    }

    Component.onCompleted: {
      startupTimer.restart();
    }

    Timer {
      id: startupTimer
      running: true
      repeat: false
      interval: 200
      onTriggered: {

        grid.positionViewAtIndex(grid.currentIndex, GridView.Contain);
      }
    }

    Keys.onPressed: {
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            root.detailsRequested()
        }
        if (api.keys.isPageUp(event) || api.keys.isPageDown(event)) {
            event.accepted = true;
            var rows_to_skip = Math.max(1, Math.round(grid.height / cellHeight));
            var games_to_skip = rows_to_skip * numColumns;
            if (api.keys.isPageUp(event))
                currentIndex = Math.max(currentIndex - games_to_skip, 0);
            else
                currentIndex = Math.min(currentIndex + games_to_skip, model.count - 1);
        }
        else if (event.key == Qt.Key_Home) {
            currentIndex = 0
        }
        else if (event.key == Qt.Key_End) {
            currentIndex = model.count  - 1
        }
        if (api.keys.isPrevPage(event)) {
            collectionPrev()
        }
        if (api.keys.isNextPage(event)) {
            collectionNext()
        }
        if (event.key == Qt.Key_Alt) { // single Alt key
          jumpToPattern = ''
        }
        if ((event.modifiers & Qt.AltModifier) && event.text) {
          event.accepted = true;
          jumpToPattern += event.text.toLowerCase();
          var match = false;
          for (var idx = 0; idx < model.count; idx++) { // search title starting-with pattern
            var lowTitle = model.get(idx).title.toLowerCase();
            if (lowTitle.indexOf(jumpToPattern) == 0) {
              currentIndex = idx;
              match = true;
              break;
            }
          }
          if (!match) { // no match - try to search title containing pattern
            for (var idx = 0; idx < model.count; idx++) {
              var lowTitle = model.get(idx).title.toLowerCase();
              if (lowTitle.indexOf(jumpToPattern) != -1) {
                currentIndex = idx;
                break;
              }
            }
          }
        }
    }



    delegate: GameGridItem {
      width: GridView.view.cellWidth
      height: GridView.view.cellHeight
      selected: GridView.isCurrentItem
      //collection: api.currentCollection
      videoBorderWidth: borderWidth
      titleBottomMargin: itemBottomMargin

      game: modelData
      collection: collectionData
      z: (selected) ? 100 : 1

      onDetails: detailsRequested();
      onClicked: GridView.view.currentIndex = index

    }
    Component {
      id: headerSpace
      Item {
        width: vpx(1)
        height: vpx(5)
      }
    }
    // Removal animation
    remove: Transition {
      NumberAnimation { property: "opacity"; to: 0; duration: 100 }
    }
  }
}
