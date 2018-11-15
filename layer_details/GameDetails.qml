import QtQuick 2.8
import QtGraphicalEffects 1.0
import QtMultimedia 5.9
import QtQuick.Layouts 1.11
import "../layer_grid"
import "../utils.js" as Utils

Item {
  id: root

  property var gameData: api.currentGame
  property bool isSteam: false
  property int padding: vpx(30)

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
      width: vpx(1000)
      height: boxart.height + (padding*2)
      color: "#1a1a1a"
      radius: vpx(8)

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
          fillMode: Image.PreserveAspectCrop
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
            top: parent.top; left: boxart.right; leftMargin: vpx(15)
            bottom: parent.bottom; right: parent.right
          }

          Text {
            id: gameTitle

            anchors {
              top: parent.top;
            }

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
            anchors {
              top: gameTitle.bottom; topMargin: vpx(-5)
            }
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
            anchors {
              top: parent.top; right: parent.right
            }
            asynchronous: true
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
            height: vpx(200)
            anchors {
              top: metadata.bottom; topMargin: vpx(30)
              left: parent.left
            }

            text: api.currentGame.summary || api.currentGame.description
            font.pixelSize: vpx(22)
            font.family: "Open Sans"
            //font.weight: Font.Light
            color: "#fff"
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
          }

        }

      }

    }

}
