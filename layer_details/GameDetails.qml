import QtQuick 2.8
import QtGraphicalEffects 1.0
import QtMultimedia 5.9
import QtQuick.Layouts 1.11
import "qrc:/qmlutils" as PegasusUtils
import "../layer_grid"
import "../utils.js" as Utils

Item {
  id: root

  property var gameData: api.currentGame
  property bool isSteam: false
  property int padding: vpx(30)
  property int cornerradius: vpx(8)

  signal launchRequested
  signal detailsCloseRequested
  signal filtersRequested

  Keys.onPressed: {
    if (event.isAutoRepeat)
        return;

    if (api.keys.isAccept(event.key)) {
        event.accepted = true;
        api.collections.index = gameList.currentIndex
        root.launchRequested()
        return;
    }
    if (api.keys.isDetails(event.key)) {
        event.accepted = true;
        detailsCloseRequested();
        return;
    }
    if (api.keys.isCancel(event.key)) {
          event.accepted = true;
          detailsCloseRequested();
          return;
      }
    if (api.keys.isFilters(event.key)) {
        event.accepted = true;
        filtersRequested();
        return;
    }
  }

    Rectangle {
      id: backgroundbox
      anchors {
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
      }
      width: parent.width - vpx(182)
      height: boxart.height + (padding*2) + navigationbox.height
      color: "#1a1a1a"
      radius: cornerradius

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
          width: vpx(250)
          source: gameData.assets.boxFront
          sourceSize { width: vpx(256); height: vpx(256) }
          fillMode: Image.PreserveAspectFit
          asynchronous: true
          visible: gameData.assets.boxFront || ""
          smooth: true

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
            left: boxart.right; leftMargin: vpx(20)
            bottom: parent.bottom; right: parent.right
          }

          Text {
            id: gameTitle

            anchors { top: parent.top; }

            width: parent.width - wreath.width
            text: api.currentGame.title
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
              metatext: (gameData.release != "" ) ? gameData.year : ""
            }

            // Spacer
            Item {
              Layout.preferredWidth: vpx(5)
            }

            Rectangle {
              id: spacer
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

            opacity: (gameData.rating != "") ? 1 : 0.3

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
              top: metadata.bottom; topMargin: vpx(35);
            }
            //horizontalAlignment: Text.AlignJustify
            text: api.currentGame.summary || api.currentGame.description
            font.pixelSize: vpx(22)
            font.family: "Open Sans"
            //textFormat: Text.RichText
            color: "#fff"
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
          }

        }

      }

      // Navigation
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
              width: parent.width/3
              height: parent.height
              focus: true

              KeyNavigation.left: backBtn
              KeyNavigation.right: faveBtn
              Keys.onPressed: {
                if (api.keys.isAccept(event.key) && !event.isAutoRepeat) {
                  event.accepted = true;
                  api.currentGame.launch();
                }
              }
              onClicked: {
                focus = true;
                api.currentGame.launch();
              }
            }

            Item {
              width: vpx(2)
              height: parent.height
            }

            // Favourite button
            GamePanelButton {
              id: faveBtn
              text: "Favourite"
              width: parent.width/3
              height: parent.height
              property bool isFavorite: (gameData && gameData.favorite) || false

              function toggleFav() {
                  if (api.currentGame)
                      api.currentGame.favorite = !api.currentGame.favorite;
              }

              KeyNavigation.left: launchBtn
              KeyNavigation.right: backBtn
              Keys.onPressed: {
                  if (api.keys.isAccept(event.key) && !event.isAutoRepeat) {
                      event.accepted = true;
                      toggleFav();
                  }
              }

              onClicked: {
                  focus = true;
                  toggleFav();
              }
            }

            Item {
              width: vpx(2)
              height: parent.height
            }

            // Back button
            GamePanelButton {
              id: backBtn
              text: "Close"
              width: parent.width/3
              height: parent.height

              KeyNavigation.left: faveBtn
              KeyNavigation.right: launchBtn
              Keys.onPressed: {
                if (api.keys.isAccept(event.key) && !event.isAutoRepeat) {
                  event.accepted = true;
                  detailsCloseRequested();
                }
              }
              onClicked: {
                focus = true;
                detailsCloseRequested();
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

    }

}
