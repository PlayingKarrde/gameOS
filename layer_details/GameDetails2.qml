import QtQuick 2.8
import QtGraphicalEffects 1.0
import QtMultimedia 5.9
import QtQuick.Layouts 1.11
import "qrc:/qmlutils" as PegasusUtils
import "../layer_grid"
import "../utils.js" as Utils

Item {
  id: root

  property var gameData: currentGame//: api.currentGame
  property bool isSteam: false
  property int padding: vpx(50)
  property int cornerradius: vpx(8)
  property bool showVideo: false
  property bool boxAvailable: gameData.assets.boxFront != null
  property bool moreDetailsToggle: false
  property int videooffset: vpx(330)
  property int numbuttons: (gameData.assets.videos.length != null) ? 4 : 3

  signal launchRequested
  signal detailsCloseRequested
  signal filtersRequested
  signal videoPreview
  signal moreDetails
  signal switchCollection(int collectionIdx)


  function boxArtWidth()
  {
    if (boxart.width > boxart.height)
      return vpx(350)
    else
      return vpx(275)
  }

  onFocusChanged: {
    if(focus) {
      launchBtn.focus = true
    }
  }

  onMoreDetailsToggleChanged: {
    if (moreDetailsToggle)
    {
      console.log("moreDetailsToggle: False");
      moreDetailsToggle = false;
    }
    else
    {
      console.log("moreDetailsToggle: True");
      moreDetailsToggle = true;
    }
  }

  visible: (backgroundbox.opacity == 0) ? false : true
  opacity: 1
  Behavior on opacity { NumberAnimation { duration: 100 } }

  // Empty area for closing out of bounds
  Item {
    anchors.fill: parent
    PegasusUtils.HorizontalSwipeArea {
        anchors.fill: parent
        onClicked: closedetails()
    }

  }

  Keys.onPressed: {
    if (event.isAutoRepeat)
      return;

    if (api.keys.isAccept(event)) {
      event.accepted = true;
      root.launchRequested()
      return;
    }
    if (api.keys.isDetails(event)) {
      event.accepted = true;
      if (gameData)
          gameData.favorite = !gameData.favorite;

      toggleSound.play()
      return;
    }
    if (api.keys.isCancel(event)) {
      event.accepted = true;
      if (showVideo)
        toggleVideo();
      else
        closedetails();

      return;
    }
    if (api.keys.isNextPage(event) || api.keys.isPrevPage(event)) {
      event.accepted = true;

      return;
    }
    if (api.keys.isPageDown(event) || api.keys.isPageUp(event)) {
      event.accepted = true;
      toggleVideo();

      return;
    }
  }

  function toggleVideo() {
    if (gameData.assets.videos.length && (boxart.opacity == 0 || boxart.opacity == 1)) {
      if (showVideo) {
        // BOXART
        showVideo = false
        root.videoPreview();
        //root.opacity = 1;
        //boxart.x = boxart.x + videooffset
        boxart.opacity = 1
        gameTitle.opacity = 1;
        metadata.opacity = 1;
        infoContainer.opacity = 1;
        gameDescription.opacity = 1;
        videoBtn.focus = true
      } else {
        // VIDEO
        showVideo = true
        root.videoPreview();
        //root.opacity = 0.05;
        //boxart.x = boxart.x - videooffset
        boxart.opacity = 0
        gameTitle.opacity = 0;
        metadata.opacity = 0;
        infoContainer.opacity = 0;
        gameDescription.opacity = 0;
        videoBackBtn.focus = true
      }
    }
  }

  function closedetails() {
    if (showVideo)
      toggleVideo();

    detailsCloseRequested();
  }

  function intro() {
      backgroundbox.opacity = 1;
      //backgroundbox.scale = 1;
      menuIntroSound.play()
  }

  function outro() {
      backgroundbox.opacity = 0;
      //backgroundbox.scale = 1.03;
      menuIntroSound.play()
  }

  Item {
    id: backgroundbox
    anchors {
      horizontalCenter: parent.horizontalCenter
      verticalCenter: parent.verticalCenter
    }
    width: parent.width - vpx(182);
    height: parent.height;
    opacity: 0
    Behavior on opacity { NumberAnimation { duration: 100 } }


    // NOTE: Boxart
    Item {
      // NOTE: Need the container for the dropshadow (until I figure out how to combine layer styles)
      id: boxContainer

      width: vpx(300)
      height: boxart.height
      //width: (boxart.width > boxart.height) ? vpx(350) : vpx(275)


      anchors {
        bottom: parent.bottom; bottomMargin: vpx(80);
      }

      Image {
        id: boxart
        width: parent.width
        source: gameData.assets.boxFront || gameData.assets.poster || ""
        sourceSize { width: vpx(512); height: vpx(512) }
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        visible: gameData.assets.boxFront || ""
        smooth: true
        Behavior on opacity { NumberAnimation { duration: 100 } }
        Behavior on x { NumberAnimation { duration: 100;  easing.type: Easing.InQuad } }


        // NOTE: Favourite tag
        Item {
          id: favetag
          anchors { fill: parent; }
          opacity: gameData.favorite ? 1 : 0
          Behavior on opacity { NumberAnimation { duration: 100 } }

          Image {
            id: favebg
            source: "../assets/images/favebg.svg"
            width: vpx(32)
            height: vpx(32)
            sourceSize { width: vpx(32); height: vpx(32)}
            anchors { top: parent.top; topMargin: vpx(0); right: parent.right; rightMargin: vpx(0) }
            visible: false

          }
          ColorOverlay {
              anchors.fill: favebg
              source: favebg
              color: themeColour
              z: 10
          }

          Image {
            id: star
            source: "../assets/images/star.svg"
            width: vpx(13)
            height: vpx(13)
            sourceSize { width: vpx(32); height: vpx(32)}
            anchors { top: parent.top; topMargin: vpx(3); right: parent.right; rightMargin: vpx(3) }
            smooth: true
            z: 11
          }
          z: 12
        }

        // NOTE: Round the corners
        layer.enabled: true
        layer.effect: OpacityMask {
          maskSource: Item {
            width: boxart.width
            height: boxart.height
            Rectangle {
              anchors.centerIn: parent
              width: boxart.width
              height: boxart.height
              radius: vpx(3)
            }
          }
        }

      }


      layer.enabled: true;
      layer.effect: DropShadow {
          horizontalOffset: 0
          verticalOffset: 0
          radius: 20.0
          samples: 17
          color: "#80000000"
          transparentBorder: true
      }
    }

    // NOTE: infoContainer
    ColumnLayout {
      id: infoContainer
      spacing: 4
      width: parent.width - boxart.width
      opacity: 1
      Behavior on opacity { NumberAnimation { duration: 100 } }
      anchors {
        left: (gameData.assets.boxFront != null) ? boxContainer.right : parent.left;
        leftMargin: (gameData.assets.boxFront != null) ? vpx(25) : vpx(0);
        bottom: boxContainer.bottom;
      }

      Text {
        id: gameTitle

        Layout.fillWidth: true;
        text: gameData.title
        color: "white"
        font.pixelSize: vpx(40)
        font.family: subtitleFont.name
        font.bold: true
        //font.capitalization: Font.AllUppercase
        elide: Text.ElideRight
        opacity: 1
        Behavior on opacity { NumberAnimation { duration: 100 } }
      }

      // NOTE: Play data
      RowLayout {
        id: metadata
        //anchors { top: gameTitle.bottom; topMargin: vpx(0) }
        height: vpx(1)
        spacing: vpx(6)

        // Developer
        GameGridMetaBox {
          metatext: (gameData.developerList[0] != undefined) ? gameData.developerList[0] : "Unknown"
        }

        // Release year
        GameGridMetaBox {
          metatext: (gameData.release != "" ) ? gameData.release.getFullYear() : ""
        }

        // Players
        GameGridMetaBox {
          metatext: if (gameData.players > 1)
            gameData.players + " players"
          else
            gameData.players + " player"
        }

        // Spacer
        Item {
          Layout.preferredWidth: vpx(5)
        }

        Rectangle {
          id: spacer2
          Layout.preferredWidth: vpx(2)
          Layout.fillHeight: true
          opacity: 0.5
        }

        Item {
          Layout.preferredWidth: vpx(5)
        }

        // Times played
        GameGridMetaBox {
          metatext: (gameData.playCount > 0) ? gameData.playCount + " times" : "Never played"
          icon: "../assets/images/gamepad.svg"
        }

        // Play time (if it has been played)
        GameGridMetaBox {
          metatext: Utils.formatPlayTime(gameData.playTime)
          icon: "../assets/images/clock.svg"
          visible: (gameData.playTime > 0)
        }
      }


      // NOTE: Spacer between details and description
      Item { height: vpx(10) }

      // description
      Text {
        id: gameDescription
        //Layout.maximumWidth: parent.width
        Layout.maximumHeight: vpx(100)
        Layout.fillWidth: true;
        horizontalAlignment: Text.AlignJustify
        text: (gameData.summary != null || gameData.description != null) ? gameData.summary || gameData.description : "No description available"
        font.pixelSize: vpx(16)
        font.family: subtitleFont.name
        font.bold: true
        //textFormat: Text.RichText
        color: "#fff"
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
        //opacity: showVideo ? 0.1 : 1.0
        Behavior on opacity { NumberAnimation { duration: 100 } }
      }

      // NOTE: Spacer between description and buttons
      Item { height: vpx(20) }

      // NOTE: Navigation buttons
      RowLayout {
        id: navigationbox
        spacing: vpx(15)
        width: parent.width
        height: vpx(35)

        // Launch button
        GamePanelButton2 {
          id: launchBtn
          text: "Launch"
          width: vpx(90)
          height: parent.height

          onFocusChanged: {
            if (focus) {
              navSound.play()
            }
          }

          KeyNavigation.left: backBtn
          KeyNavigation.right: (numbuttons == 4) ? videoBtn : faveBtn
          Keys.onPressed: {
            if (api.keys.isAccept(event) && !event.isAutoRepeat) {
              event.accepted = true;
              root.launchRequested();
            }
          }

          onClicked: {
            focus = true;
            root.launchRequested();
          }

          // Round the corners
          layer.enabled: true
          layer.effect: OpacityMask {
            maskSource: Item {
              width: launchBtn.width
              height: launchBtn.height
              Rectangle {
                anchors.centerIn: parent
                width: launchBtn.width
                height: launchBtn.height
                radius: vpx(3)
              }
            }
          } //OpacityMask

        } //launchBtn

        // Video button
        GamePanelButton2 {
          id: videoBtn
          text: "Preview"
          width: vpx(96)
          height: parent.height
          visible: (numbuttons == 4)

          onFocusChanged: {
            if (focus)
              navSound.play()
          }

          KeyNavigation.left: launchBtn
          KeyNavigation.right: faveBtn
          Keys.onPressed: {
            if (api.keys.isAccept(event) && !event.isAutoRepeat) {
              event.accepted = true;
              toggleVideo();
            }
          }
          onClicked: {
            //focus = true
            toggleVideo();
          }

          // Round the corners
          layer.enabled: true
          layer.effect: OpacityMask {
            maskSource: Item {
              width: videoBtn.width
              height: videoBtn.height
              Rectangle {
                anchors.centerIn: parent
                width: videoBtn.width
                height: videoBtn.height
                radius: vpx(3)
              }
            }
          } //OpacityMask
        }

        // Favourite button
        GamePanelButton2 {
          id: faveBtn
          property bool isFavorite: (gameData && gameData.favorite) || false
          text: isFavorite ? "Unfavorite" : "Add Favorite"
          width: vpx(125)
          height: parent.height

          onFocusChanged: {
            if (focus)
              navSound.play()
          }

          function toggleFav() {
              if (gameData)
                  gameData.favorite = !gameData.favorite;

              toggleSound.play()
          }

          KeyNavigation.left: (numbuttons == 4) ? videoBtn : launchBtn
          KeyNavigation.right: backBtn
          Keys.onPressed: {
              if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                  event.accepted = true;
                  toggleFav();
              }
          }

          onClicked: {
              focus = true;
              toggleFav();
          }

          // Round the corners
          layer.enabled: true
          layer.effect: OpacityMask {
            maskSource: Item {
              width: faveBtn.width
              height: faveBtn.height
              Rectangle {
                anchors.centerIn: parent
                width: faveBtn.width
                height: faveBtn.height
                radius: vpx(3)
              }
            }
          } //OpacityMask
        }

        // Back button
        GamePanelButton2 {
          id: backBtn
          text: "Back"
          width: vpx(70)
          height: parent.height
          onFocusChanged: {
            if (focus)
              navSound.play()
          }

          KeyNavigation.left: faveBtn
          KeyNavigation.right: launchBtn
          Keys.onPressed: {
            if (api.keys.isAccept(event) && !event.isAutoRepeat) {
              event.accepted = true;
              closedetails();
            }
          }
          onClicked: {
            focus = true;
            closedetails();
          }

          // Round the corners
          layer.enabled: true
          layer.effect: OpacityMask {
            maskSource: Item {
              width: backBtn.width
              height: backBtn.height
              Rectangle {
                anchors.centerIn: parent
                width: backBtn.width
                height: backBtn.height
                radius: vpx(3)
              }
            }
          } //OpacityMask
        }
      } //navigationBox
    } //infoContainer

    // NOTE: Preview video back button
    // Back button
    GamePanelButton2 {
      id: videoBackBtn
      anchors {
        right: parent.right; rightMargin: vpx(0);
        bottom: boxContainer.bottom; bottomMargin: vpx(0);
      }
      text: "Back"
      width: vpx(70)
      height: vpx(35)
      opacity: showVideo ? 1 : 0
      Behavior on opacity { NumberAnimation { duration: 100 } }
      onFocusChanged: {
        if (focus)
          navSound.play()
      }

      //KeyNavigation.left: faveBtn
      //KeyNavigation.right: launchBtn
      Keys.onPressed: {
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
          event.accepted = true;
          toggleVideo();
        }
      }
      onClicked: {
        focus = true
        toggleVideo();
      }

      // Round the corners
      layer.enabled: true
      layer.effect: OpacityMask {
        maskSource: Item {
          width: backBtn.width
          height: backBtn.height
          Rectangle {
            anchors.centerIn: parent
            width: backBtn.width
            height: backBtn.height
            radius: vpx(3)
          }
        }
      } //OpacityMask
    }

  } //backgroundBox

} //root
