// vgOS Frontend

import QtQuick 2.8
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

  function toggleMenu() {

    if (platformmenu.focus) {
      // Close the menu
      gamegrid.focus = true
      platformmenu.outro()
      content.opacity = 1
      contentcontainer.opacity = 1
      contentcontainer.x = 0
      collectiontitle.opacity = 1
    } else {
      // Open the menu
      platformmenu.focus = true
      platformmenu.intro()
      content.opacity = 0.3
      contentcontainer.opacity = 0.3
      contentcontainer.x = platformmenu.menuwidth
      collectiontitle.opacity = 0
    }

  }

  function toggleDetails() {
    if (gamedetails.active) {
      // Close the details
      gamegrid.focus = true
      gamegrid.visible = true
      content.opacity = 1
      backgroundimage.dimopacity = 0.97
      gamedetails.active = false
      gamedetails.outro()
    } else {
      // Open details panel
      gamedetails.focus = true
      gamedetails.active = true
      gamegrid.visible = false
      content.opacity = 0
      backgroundimage.dimopacity = 0
      gamedetails.intro()
    }
  }

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

    Item {
      id: contentcontainer

      width: parent.width
      height: parent.height

      Behavior on x {
        PropertyAnimation {
          duration: 300;
          easing.type: Easing.OutQuart;
          easing.amplitude: 2.0;
          easing.period: 1.5
        }
      }

      Image {
        id: menuicon
        source: "assets/images/menuicon.svg"
        width: vpx(24)
        height: vpx(24)
        anchors { top: parent.top; topMargin: vpx(32); left: parent.left; leftMargin: vpx(32) }
        visible: gamegrid.focus
      }

      Text {
        id: collectiontitle

        anchors {
          top: parent.top; topMargin: vpx(35);
          //horizontalCenter: menuicon.horizontalCenter
          left: menuicon.right; leftMargin: vpx(35)
        }

        Behavior on opacity { NumberAnimation { duration: 100 } }

        width: parent.width
        text: (api.filters.current.enabled) ? api.currentCollection.name + " | Favorites" : api.currentCollection.name
        color: "white"
        font.pixelSize: vpx(16)
        font.family: globalFonts.sans
        //font.capitalization: Font.AllUppercase
        elide: Text.ElideRight
        //opacity: 0.5

        // DropShadow
        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8.0
            samples: 17
            color: "#80000000"
            transparentBorder: true
        }
      }

      // Game details
      GameGridDetails {
        id: content

        height: vpx(200)//vpx(280)
        width: parent.width - vpx(182)
        anchors { top: menuicon.bottom; topMargin: vpx(-20)}

        // Text doesn't look so good blurred so fade it out when blurring
        opacity: 1
        Behavior on opacity { OpacityAnimator { duration: 100 } }
      }

      // Game grid
      Item {
        id: gridcontainer
        clip: true

        width: parent.width
        //height: parent.height * 0.1

        anchors {
          top: content.bottom; //topMargin: vpx(75)
          bottom: parent.bottom;
          left: parent.left; right: parent.right
        }

        GameGrid {
          id: gamegrid

          focus: true
          Behavior on opacity { OpacityAnimator { duration: 100 } }
          gridWidth: parent.width - vpx(164)
          height: parent.height

          anchors {
            top: parent.top; topMargin: vpx(10)
            bottom: parent.bottom;
            left: parent.left; right: parent.right
          }

          detailsActive: gamedetails.active

          onLaunchRequested: api.currentGame.launch()
          onNextCollection: api.collections.incrementIndex()
          onPrevCollection: api.collections.decrementIndex()
          onMenuRequested: toggleMenu()
          onDetailsRequested: toggleDetails()
        }
      }

      GameDetails {
        id: gamedetails

        property bool active : false

        anchors {
          left: parent.left; right: parent.right
          top: parent.top; bottom: parent.bottom
        }
        width: parent.width
        height: parent.height

        onDetailsCloseRequested: toggleDetails()

      }

    }


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

  // Switch collection overlay
  GameGridSwitcher {
    id: switchoverlay
    anchors.fill: parent
    width: parent.width
    height: parent.height
  }

  // Empty area for swiping on touch
  Item {
    anchors { top: parent.top; left: parent.left; bottom: parent.bottom; }
    width: vpx(75)
    PegasusUtils.HorizontalSwipeArea {
        anchors.fill: parent
        visible: gamegrid.focus
        onSwipeRight: toggleMenu()
        //onSwipeLeft: closeRequested()
        onClicked: toggleMenu()
    }
  }

  ///////////////////
  // SOUND EFFECTS //
  ///////////////////
  SoundEffect {
      id: navSound
      source: "assets/audio/tap-mellow.wav"
      volume: 1.0
  }

  SoundEffect {
      id: menuIntroSound
      source: "assets/audio/slide-scissors.wav"
      volume: 1.0
  }

  SoundEffect {
      id: toggleSound
      source: "assets/audio/tap-sizzle.wav"
      volume: 1.0
  }

}
