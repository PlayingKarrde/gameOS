import QtQuick 2.8
import QtMultimedia 5.9

FocusScope {
  id: root

  // Options
  property int numColumns: 4

  property alias gridWidth: grid.width
  property int gridItemSpacing: (numColumns == 4) ? vpx(7) : vpx(5) // it will double this
  property var platformData: api.currentCollection
  property var platformModel: api.collections.model

  signal launchRequested
  signal menuRequested
  signal detailsRequested
  //signal filtersRequested
  signal nextCollection
  signal prevCollection

  Keys.onPressed: {
      if (event.isAutoRepeat)
          return;

      if (api.keys.isDetails(event.key)) {
          event.accepted = true;
          detailsRequested();
          return;
      }
      if (api.keys.isCancel(event.key)) {
          event.accepted = true;
          menuRequested();
          return;
        }
      if (api.keys.isFilters(event.key)) {
          event.accepted = true;
          toggleFav();
          //filtersRequested();
          return;
      }
  }

  //property bool isFavorite: (gameData && gameData.favorite) || false
  function toggleFav() {
      if (api.currentGame)
          api.currentGame.favorite = !api.currentGame.favorite;
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
    cellHeight: (numColumns == 4) ? vpx(157) : vpx(210)

    //highlightFollowsCurrentItem: false
    preferredHighlightBegin: vpx(0); preferredHighlightEnd: vpx(314)
    highlightRangeMode: GridView.StrictlyEnforceRange
    displayMarginBeginning: 300
    //snapMode: GridView.SnapOneItem

    model: platformData ? platformData.games.model : []
    currentIndex: platformData ? platformData.games.index : 0
    onCurrentIndexChanged: {
      if (api.currentCollection) api.currentCollection.games.index = currentIndex;
      navSound.play()

    }

    Keys.onPressed: {
        if (api.keys.isAccept(event.key) && !event.isAutoRepeat) {
            event.accepted = true;
            root.detailsRequested()
        }
        if (api.keys.isPageUp(event.key) || api.keys.isPageDown(event.key)) {
            event.accepted = true;
            var rows_to_skip = Math.max(1, Math.round(grid.height / cellHeight));
            var games_to_skip = rows_to_skip * numColumns;
            if (api.keys.isPageUp(event.key))
                currentIndex = Math.max(currentIndex - games_to_skip, 0);
            else
                currentIndex = Math.min(currentIndex + games_to_skip, model.length - 1);
        }
        if (api.keys.isPrevPage(event.key))
        {
          prevCollection()
        }
        if (api.keys.isNextPage(event.key))
        {
          nextCollection()
        }
        if (event.modifiers === Qt.AltModifier && event.text) {
            event.accepted = true;
            api.currentCollection.games.jumpToLetter(event.text);
        }
    }



    delegate: GameGridItem {
      width: GridView.view.cellWidth
      height: GridView.view.cellHeight
      selected: GridView.isCurrentItem
      //collection: api.currentCollection

      game: modelData
      z: (selected) ? 100 : 1

      onClicked: GridView.view.currentIndex = index

    }

    // Removal animation
    remove: Transition {
      NumberAnimation { property: "opacity"; to: 0; duration: 100 }
    }
  }
}
