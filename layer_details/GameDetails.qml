import QtQuick 2.8
import QtGraphicalEffects 1.0
import QtMultimedia 5.9
import QtQuick.Layouts 1.11
import "qrc:/qmlutils" as PegasusUtils
import "../layer_grid"
import "../utils.js" as Utils

Item {
  id: root

  property var gameData//: api.currentGame
  property bool isSteam: false
  property int padding: vpx(50)
  property int cornerradius: vpx(8)
  property bool showVideo: false
  property bool boxAvailable: gameData.assets.boxFront
  property int videooffset: vpx(330)
  property int numbuttons: (gameData.assets.videos.length) ? 4 : 3

  signal launchRequested
  signal detailsCloseRequested
  signal filtersRequested
  signal switchCollection(int collectionIdx)

  onFocusChanged: {
    if(focus) {
      launchBtn.focus = true
    }
  }

  visible: (backgroundbox.opacity == 0) ? false : true

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

  Timer {
    id: videoDelay
    interval: 100
    onTriggered: {
      if (gameData.assets.videos.length) {
        videoPreviewLoader.sourceComponent = videoPreviewWrapper;
        fadescreenshot.restart();
      }
    }
  }

  Timer {
    id: fadescreenshot
    interval: 500
    onTriggered: {
      screenshot.opacity = 0;
    }
  }

  function toggleVideo() {
    if (gameData.assets.videos.length && (boxart.opacity == 0 || boxart.opacity == 1)) {
      if (showVideo) {
        // BOXART
        showVideo = false
        boxart.x = boxart.x + videooffset
        boxart.opacity = 1
        details.anchors.rightMargin = 0
        bgGradient.width = bgGradient.parent.width
        videoPreviewLoader.sourceComponent = undefined;
        fadescreenshot.stop();
        screenshot.opacity = 1
      } else {
        // VIDEO
        showVideo = true
        boxart.x = boxart.x - videooffset
        boxart.opacity = 0
        details.anchors.rightMargin = videooffset
        bgGradient.width = bgGradient.width/20
        videoDelay.restart();
        menuIntroSound.play();
      }
    }
  }

  function closedetails() {
    if (showVideo)
      toggleVideo();

    detailsCloseRequested();
  }

    Rectangle {
      id: backgroundbox
      anchors {
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
      }
      width: parent.width - vpx(182)
      height: boxAvailable ? boxart.height + (padding*2) + navigationbox.height : vpx(400)
      color: "#1a1a1a"//"#ee1a1a1a"
      radius: cornerradius
      opacity: 0
      Behavior on opacity { NumberAnimation { duration: 100 } }

      scale: 1.03
      Behavior on scale { NumberAnimation { duration: 100 } }
      // DropShadow
      layer.enabled: true
      layer.effect: DropShadow {
          horizontalOffset: 0
          verticalOffset: 0
          radius: 20.0
          samples: 17
          color: "#80000000"
          transparentBorder: true
      }

      // Background art
      Item {
        id: bgart
        width: vpx(500)
        height: parent.height - navigationbox.height
        anchors.right: parent.right

        // Video preview
        Component {
          id: videoPreviewWrapper
          Video {
            source: gameData.assets.videos.length ? gameData.assets.videos[0] : ""
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
            muted: false
            loops: MediaPlayer.Infinite
            autoPlay: true
          }

        }

        // Video
        Loader {
          id: videoPreviewLoader
          asynchronous: true
          anchors {
            fill: parent
          }
          layer.enabled: true
          layer.effect: OpacityMask {
            maskSource: Item {
              width: videoPreviewLoader.width
              height: videoPreviewLoader.height
              Rectangle {
                anchors.centerIn: parent
                width: videoPreviewLoader.width
                height: videoPreviewLoader.height
                radius: cornerradius - vpx(1)
              }
            }
          }
        }

        // Screenshot
        Image {
          id: screenshot
          width: parent.width
          height: parent.height
          source: gameData.assets.screenshots[0] || ""
          fillMode: Image.PreserveAspectCrop
          anchors {
            top: parent.top;
            verticalCenter: parent.verticalCenter
          }
          Behavior on opacity { NumberAnimation { duration: 500 } }
        }



        // Fade off
        LinearGradient {
          id: bgGradient
          z: parent.z + 1
          width: parent.width
          height: parent.height
          Behavior on width { NumberAnimation { duration: 100;  easing.type: Easing.InQuad } }
          /*anchors {
            top: parent.top;// topMargin: vpx(200)
            left: parent.left;// leftMargin: vpx(200)
            right: parent.right; //rightMargin: vpx(200)
            bottom: parent.bottom
          }*/
          start: Qt.point(width, 0)
          end: Qt.point(0, 0)
          gradient: Gradient {
            GradientStop { position: 0.0; color: "#001a1a1a" }
            GradientStop { position: 1; color: "#ff1a1a1a" }
          }
          transform: Scale { xScale: 10.0 }
          //scale: 10
        }

        // Round those corners!
        layer.enabled: true
        layer.effect: OpacityMask {
          maskSource: Item {
            width: backgroundbox.width
            height: backgroundbox.height
            Rectangle {
              anchors.centerIn: parent
              width: backgroundbox.width
              height: backgroundbox.height
              radius: cornerradius
            }
          }
        }
      }

      Item {
        id: infobox
        width: parent.width
        height: parent.height
        anchors {
          fill: parent
          margins: padding
        }

        // NOTE: Boxart
        Image {
          id: boxart
          width: vpx(300)
          source: gameData.assets.boxFront
          sourceSize { width: vpx(512); height: vpx(512) }
          fillMode: Image.PreserveAspectFit
          asynchronous: true
          visible: gameData.assets.boxFront || ""
          smooth: true
          Behavior on opacity { NumberAnimation { duration: 100 } }
          Behavior on x { NumberAnimation { duration: 100;  easing.type: Easing.InQuad } }


          // Favourite tag
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
                color: "#FF9E12"
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

          // Round the corners
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


        // NOTE: Details section
        Item {
          id: details
          anchors {
            top: parent.top; topMargin: vpx(0)
            left: boxAvailable ? boxart.right : parent.left;
            leftMargin: boxAvailable ? vpx(30) : vpx(5)
            bottom: parent.bottom; right: parent.right
          }

          Behavior on anchors.rightMargin { NumberAnimation { duration: 100; easing.type: Easing.InQuad } }

          Text {
            id: gameTitle

            anchors { top: parent.top; }

            width: parent.width - wreath.width
            text: gameData.title
            color: "white"
            font.pixelSize: vpx(50)
            font.family: titleFont.name
            font.bold: true
            //font.capitalization: Font.AllUppercase
            elide: Text.ElideRight
          }

          RowLayout {
            id: metadata
            anchors { top: gameTitle.bottom; topMargin: vpx(0) }
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

          Image {
            id: wreath
            source: (gameData.rating > 0.89) ? "../assets/images/wreath-gold.svg" : "../assets/images/wreath.svg"
            anchors { top: parent.top; right: parent.right; rightMargin: vpx(0) }
            asynchronous: false
            fillMode: Image.PreserveAspectFit
            smooth: true
            width: vpx(75)
            height: vpx(75)

            opacity: (gameData.rating != "" && !showVideo) ? 1 : 0.1
            Behavior on opacity { NumberAnimation { duration: 100 } }

            Text {
              id: metarating
              text: (gameData.rating == "") ? "NA" : Math.round(gameData.rating * 100)
              color: (gameData.rating > 0.89) ? "#FFCE00" : "white"
              font.pixelSize: vpx(35)
              font.family: globalFonts.condensed
              font.bold: true
              horizontalAlignment: Text.AlignHCenter
              anchors { top: parent.top; topMargin: vpx(15) }
              width: parent.width
              font.capitalization: Font.AllUppercase
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
          }

          // description
          Text {
            id: gameDescription
            width: parent.width
            height: boxart.height - y//parent.height - navigationbox.height
            anchors {
              top: metadata.bottom; topMargin: vpx(60);
            }
            horizontalAlignment: Text.AlignJustify
            text: (gameData.summary || gameData.description) ? gameData.summary || gameData.description : "No description available"
            font.pixelSize: vpx(22)
            font.family: "Open Sans"
            //textFormat: Text.RichText
            color: "#fff"
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            opacity: showVideo ? 0.1 : 1.0
            Behavior on opacity { NumberAnimation { duration: 100 } }
          }

        }

      }

      // NOTE: Navigation
      Item {
        id: navigation
        anchors.fill: parent
        width: parent.width
        height: parent.height

        Rectangle {
          id: navigationbox
          anchors {
            bottom: parent.bottom;
            left: parent.left; right: parent.right;
          }
          color: "#16ffffff"
          width: parent.width
          height: vpx(60)

          // Buttons
          Row {
            id: panelbuttons
            width: parent.width
            height: parent.height
            anchors.fill: parent

            // Launch button
            GamePanelButton {
              id: launchBtn
              text: "Launch"
              width: parent.width/numbuttons
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

              /*Image {
                height: vpx(20)
                sourceSize { height: vpx(20) }
                source: "../assets/images/gamepad.svg"
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                opacity: parent.focus ? 1 : 0.5
                Behavior on opacity { NumberAnimation { duration: 100 } }
                scale: parent.focus ? 1.2 : 1
                Behavior on scale { NumberAnimation { duration: 100 } }
              }*/
            }

            Rectangle {
              width: vpx(1)
              height: parent.height
              color: "#1a1a1a"
            }

            // Video button
            GamePanelButton {
              id: videoBtn
              text: (showVideo) ? "Details" : "Preview"
              width: parent.width/numbuttons
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
                focus = true
                toggleVideo();
              }
            }
            Rectangle {
              width: vpx(1)
              height: parent.height
              color: "#1a1a1a"
              visible: (numbuttons == 4)
            }

            // Favourite button
            GamePanelButton {
              id: faveBtn
              property bool isFavorite: (gameData && gameData.favorite) || false
              text: isFavorite ? "Unfavorite" : "Add to Favorites"
              width: parent.width/numbuttons
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

              /*Image {
                width: vpx(24); height: vpx(24)
                sourceSize { width: vpx(24); height: vpx(24) }
                source: "../assets/images/star.svg"
                anchors.centerIn: parent
                opacity: parent.focus ? 1 : 0.5
                Behavior on opacity { NumberAnimation { duration: 100 } }
                scale: parent.focus ? 1.2 : 1
                Behavior on scale { NumberAnimation { duration: 100 } }
              }*/
            }

            Rectangle {
              width: vpx(1)
              height: parent.height
              color: "#1a1a1a"
            }

            // Back button
            GamePanelButton {
              id: backBtn
              text: "Close"
              width: parent.width/numbuttons
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
            }

          }
        }



        // Round those corners!
        layer.enabled: true
        layer.effect: OpacityMask {
          maskSource: Item {
            width: navigation.width
            height: navigation.height
            Rectangle {
              anchors.centerIn: parent
              width: navigation.width
              height: navigation.height
              radius: cornerradius
            }
          }
        }
      }

      // Empty area for swiping on touch
      Item {
        anchors.fill: parent
        PegasusUtils.HorizontalSwipeArea {
            anchors { top: parent.top; left: parent.left; right: parent.right; bottom: parent.bottom; bottomMargin: vpx(60) }
            //visible: root.focus
            //onSwipeRight: if (showVideo) { toggleVideo() }
            //onSwipeLeft: if (!showVideo) { toggleVideo() }
            onClicked: toggleVideo()
        }

      }

    }

    function intro() {
        backgroundbox.opacity = 1;
        backgroundbox.scale = 1;
        menuIntroSound.play()
    }

    function outro() {
        backgroundbox.opacity = 0;
        backgroundbox.scale = 1.03;
        menuIntroSound.play()
    }
}
