// vgOS Frontend

import QtQuick 2.11
import QtGraphicalEffects 1.0
import QtMultimedia 5.9
import "qrc:/qmlutils" as PegasusUtils
import "layer_grid"
import "layer_menu"
import "layer_details"

FocusScope {
  // Loading the fonts here makes them usable in the rest of the theme
  // and can be referred to using their name and weight.
  FontLoader { id: titleFont; source: "fonts/AkzidenzGrotesk-BoldCond.otf" }
  FontLoader { id: subtitleFont; source: "fonts/Gotham-Bold.otf" }

  property bool menuactive: false

  Item {
    id: everythingcontainer
    anchors {
      left: parent.left; right: parent.right
      top: parent.top; bottom: parent.bottom
    }
    width: parent.width
    height: parent.height

    BackgroundImage {
      id: backgroundimage
      anchors {
        left: parent.left; right: parent.right
        top: parent.top; bottom: parent.bottom
      }
    }

    Image {
      id: menuicon
      source: "assets/images/menuicon.svg"
      width: vpx(24)
      height: vpx(24)
      anchors { top: parent.top; topMargin: vpx(32); left: parent.left; leftMargin: vpx(32) }
      visible: gamegrid.focus

      MouseArea {
          anchors.fill: menuicon
          cursorShape: Qt.PointingHandCursor
          hoverEnabled: true
          onClicked: {toggleMenu()}
      }
    }

    GameGridDetails {
      id: content

      height: vpx(280)
      width: parent.width - vpx(182)

      // Text doesn't look so good blurred so fade it out when blurring
      opacity: 1
      Behavior on opacity { OpacityAnimator { duration: 100 } }
    }

    Item {
      id: gridcontainer
      clip: true

      width: parent.width
      height: parent.height * 0.65

      anchors {
        top: content.bottom; bottom: parent.bottom
        left: parent.left; right: parent.right
      }

      GameGrid {
        id: gamegrid

        focus: true

        gridWidth: parent.width - vpx(164)
        height: parent.height

        anchors {
          top: parent.top; topMargin: vpx(10)
          bottom: parent.bottom;
          left: parent.left; right: parent.right
        }

        onLaunchRequested: api.currentGame.launch()
        onNextCollection: api.collections.incrementIndex()
        onPrevCollection: api.collections.decrementIndex()
        onMenuRequested: toggleMenu()
      }
    }

  }

  GameDetails {
    id: gamedetails
    anchors {
      left: parent.left; right: parent.right
      top: parent.top; bottom: parent.bottom
    }
    width: parent.width
    height: parent.height

  }

  PlatformMenu {
    id: platformmenu
    anchors {
      left: parent.left; right: parent.right
      top: parent.top; bottom: parent.bottom
    }
    width: parent.width
    height: parent.height
    backgroundcontainer: everythingcontainer
    onMenuCloseRequested: toggleMenu()
  }

  function toggleMenu() {

    if (platformmenu.focus) {
      // Close the menu
      gamegrid.focus = true
      platformmenu.outro()
      content.opacity = 1
    } else {
      // Open the menu
      platformmenu.focus = true
      platformmenu.intro()
      content.opacity = 0
    }

  }

  // Switch collection overlay
  GameGridSwitcher {
    id: switchoverlay
    anchors.fill: parent
    width: parent.width
    height: parent.height
  }

  ///////////////////
  // SOUND EFFECTS //
  ///////////////////
  SoundEffect {
      id: navSound
      source: "assets/audio/tap-mellow.wav"
      volume: 0.2
  }

  SoundEffect {
      id: menuIntroSound
      source: "assets/audio/slide-scissors.wav"
      volume: 0.2
  }

}
