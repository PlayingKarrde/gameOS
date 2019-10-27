import QtQuick 2.8
import QtGraphicalEffects 1.0
import QtMultimedia 5.9
import "qrc:/qmlutils" as PegasusUtils

Item {
  id: root

  signal menuCloseRequested
  signal switchCollection(int collectionIdx)

  property alias menuwidth: menubar.width
  property var collection
  property int collectionIdx
  property bool showSystemMenu: true

  Keys.onLeftPressed: closeMenu()
  Keys.onRightPressed: closeMenu()
  Keys.onUpPressed: gameList.decrementCurrentIndex()
  Keys.onDownPressed: gameList.incrementCurrentIndex()
  //Keys.onUpPressed: api.collections.decrementIndex()
  //Keys.onDownPressed: api.collections.incrementIndex()

  Keys.onPressed: {
      if (event.isAutoRepeat)
          return;

      if (api.keys.isAccept(event)) {
          event.accepted = true;
          switchCollection(gameList.currentIndex);
          closeMenu();
          return;
      }
      if (api.keys.isCancel(event)) {
          if (showSystemMenu) {
            showSystemMenu = false;
          }
          else {
            event.accepted = true;
            closeMenu();
          }
          return;
      }
      if (api.keys.isFilters(event)) {
          event.accepted = true;
          toggleSettings();
          return;
      }
      if (api.keys.isNextPage(event)) {
          event.accepted = true;
          api.collections.incrementIndex();
          return;
      }
      if (api.keys.isPrevPage(event)) {
          event.accepted = true;
          api.collections.decrementIndex();
          return;
      }
  }

  function closeMenu() {
    menuCloseRequested();
    showSystemMenu = true;
  }

  function toggleSettings() {
    if (!settings.visible) {
      // Open settings menu
      gameList.visible = false;
      settings.visible = true;
      settings.focus = true;
      menubar.focus = false;
    } else {
      // Close settings menu
      gameList.visible = true;
      settings.visible = false;
      settings.focus = false;
      menubar.focus = true;
    }
  }

  property var backgroundcontainer

  width: parent.width
  height: parent.height

  /*Item {
    id: bgblur
    anchors.fill: parent
    opacity: 0
    Behavior on opacity {
      OpacityAnimator {
        duration: 100;
        easing.type: Easing.InOutQuad;
      }
    }

    ShaderEffectSource {
      id: effectSource
      sourceItem: backgroundcontainer
      anchors.fill: parent
    }

    FastBlur  {
      id: blur
      anchors.fill: effectSource
      source: effectSource
      radius: 64
    }

  }*/

  Item {
    id: menubg
    x: -width
    Behavior on x {
      PropertyAnimation {
        duration: 300;
        easing.type: Easing.OutQuart;
        easing.amplitude: 2.0;
        easing.period: 1.5
      }
    }

    width: vpx(350)
    height: parent.height
    //source: "../assets/images/defaultbg.jpg"
    //fillMode: Image.PreserveAspectCrop

    PegasusUtils.HorizontalSwipeArea {
        anchors.fill: parent
        onSwipeLeft: closeMenu()
    }

    Rectangle {
      id: menubar
      property real contentWidth: width - vpx(100)

      width: parent.width
      height: parent.height
      color: "#000"
      opacity: 0

      }

      Image {
        id: logo

        width: menubar.contentWidth
        height: vpx(75)

        fillMode: Image.PreserveAspectFit
        source: "../assets/images/logos/" + platformShortname + ".svg"
        asynchronous: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: vpx(80)
        opacity: 0.75
      }

      // Highlight
      Component {
        id: highlight
        Rectangle {
          width: gameList.cellWidth; height: gameList.cellHeight
          color: themeColour
          x: gameList.currentItem.x
          y: gameList.currentItem.y
          Behavior on y { NumberAnimation {
            duration: 300;
            easing.type: Easing.OutQuart;
            easing.amplitude: 2.0;
            easing.period: 1.5}
          }
        }
      }

      // Menu
      ListView {
        id: gameList
        property var collectionList: api.collections
        width: parent.width

        preferredHighlightBegin: vpx(160); preferredHighlightEnd: vpx(160)
        highlightRangeMode: ListView.ApplyRange

        anchors {
          top: logo.bottom; topMargin: vpx(70)
          left: parent.left;
          right: parent.right
          bottom: parent.bottom; bottomMargin: vpx(80)
        }

        model: collectionList

        delegate: collectionListItemDelegate
        currentIndex: collectionIdx
        onCurrentIndexChanged: navSound.play()
        highlight: highlight
        highlightFollowsCurrentItem: true
        focus: true

        Component.onCompleted: {
          positionViewAtIndex(currentIndex, ListView.Contain);
        }
      }

      // Menu item
      Component {
        id: collectionListItemDelegate

        Item {
          id: menuitem
          readonly property bool selected: ListView.isCurrentItem
          width: menubar.width
          height: vpx(40)

          Text {
            text: {
              if (modelData.name == "Super Nintendo Entertainment System")
                "Super NES"
              else if (modelData.name == "Nintendo Entertainment System")
                "NES"
              else if (modelData.name == "Nintendo Game Boy Advance")
                "Nintendo GBA"
              else
                modelData.name
            }

            anchors { left: parent.left; leftMargin: vpx(50)}
            color: selected ? "#fff" : "#666"
            Behavior on color {
              ColorAnimation {
                duration: 200;
                easing.type: Easing.OutQuart;
                easing.amplitude: 2.0;
                easing.period: 1.5
              }
            }
            font.pixelSize: vpx(22)
            font.family: bodyFont.name
            //font.capitalization: Font.AllUppercase
            //font.bold: true//selected
            //width: ListView.view.width
            height: vpx(40)
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

          }

          MouseArea {
            anchors.fill: menuitem
            hoverEnabled: true
            onEntered: {}
            onExited: {}
            onWheel: {}
            onClicked: {
              switchCollection(index);
              closeMenu();
            }
          }
        }
    }

    // Settings screen
    /*Settings {
      id: settings
      visible: false
      focus: false
      property bool active : false
      anchors {
        left: parent.left; right: parent.right
        top: parent.top; bottom: parent.bottom
      }
      width: parent.width
      height: parent.height
      onCloseRequested: toggleSettings()
    }*/

    LinearGradient {
          width: vpx(2)
          height: parent.height
          anchors {
              top: parent.top
              right: parent.right
              bottom: parent.bottom
          }
          //start: Qt.point(0, 0)
          //end: Qt.point(0, height)
          gradient: Gradient {
              GradientStop { position: 0.0; color: "#00ffffff" }
              GradientStop { position: 0.5; color: "#ffffffff" }
              GradientStop { position: 1.0; color: "#00ffffff" }
          }
          opacity: 0.2
      }

  }

  MouseArea {
      anchors {
          top: parent.top; left: menubg.right
          bottom: parent.bottom; right: parent.right

      }
      onClicked: {toggleMenu()}
      visible: parent.focus
  }

  function intro() {
      //bgblur.opacity = 1;
      menubg.x = 0;
      menuIntroSound.play()
  }

  function outro() {
      //bgblur.opacity = 0;
      menubg.x = -menubar.width;
      menuIntroSound.play()
  }

}
