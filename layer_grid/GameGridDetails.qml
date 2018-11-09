import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0
import "../utils.js" as Utils

Item {
  id: root

  property var gameData: api.currentGame
  anchors.horizontalCenter: parent.horizontalCenter
  clip: true

  Text {
    id: gameTitle

    anchors { top: parent.top; topMargin: vpx(60)}
    width: vpx(850)
    text: api.currentGame.title
    color: "white"
    font.pixelSize: vpx(60)
    font.family: titleFont.name
    font.bold: true
    font.capitalization: Font.AllUppercase
    elide: Text.ElideRight
    //style: Text.Outline; styleColor: "#cc000000"
  }

  DropShadow {
      anchors.fill: gameTitle
      horizontalOffset: 0
      verticalOffset: 0
      radius: 8.0
      samples: 17
      color: "#80000000"
      source: gameTitle
  }

  ColumnLayout {
    id: playinfo
    anchors { top: gameTitle.top; topMargin: vpx(30); right: parent.right; rightMargin: vpx(60)}

    width: vpx(150)
    spacing: vpx(4)


    Image {
      id: wreath
      source: "../assets/images/wreath.svg"
      asynchronous: true
      fillMode: Image.PreserveAspectFit
      smooth: true
      Layout.preferredWidth: vpx(100)
      Layout.preferredHeight: vpx(100)

      opacity: (gameData.rating != "") ? 1 : 0.3
      //visible: (gameData.rating != "") ? 1 : 0
      Layout.alignment: Qt.AlignCenter
      sourceSize.width: 128
      sourceSize.height: 128

      /*Rectangle {
        width: parent.width
        height: parent.height
        color: "#fff"
      }*/

      ColorOverlay {
          anchors.fill: wreath
          source: wreath
          color: (gameData.rating > 0.89) ? "#FFCE00" : "white"
      }

      Text {
        id: metarating
        text: (gameData.rating == "") ? "NA" : Math.round(gameData.rating * 100)
        color: (gameData.rating > 0.89) ? "#FFCE00" : "white"
        opacity: 0.90
        font.pixelSize: vpx(45)
        font.family: globalFonts.condensed
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors { top: parent.top; topMargin: vpx(20) }
        width: parent.width
        font.capitalization: Font.AllUppercase
      }

      Text {
        id: ratingtext
        text: (gameData.rating == "") ? "No Rating" : "Rating"
        color: "white"
        opacity: 0.9
        font.pixelSize: vpx(16)
        font.family: globalFonts.condensed
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors { top: parent.bottom; topMargin: vpx(-4) }
        width: parent.width
        font.capitalization: Font.AllUppercase
      }
    }

    Item {
      id: spacerhack
      Layout.preferredHeight: vpx(15)
    }

    /*GameGridMetaBox {
      metatext: gameData.developerList[0]
    }*/

    GameGridMetaBox {
      metatext: if (gameData.players > 1)
        gameData.players + " players"
      else
        gameData.players + " player"
    }



    /*
    RowLayout {
      id: lastplayedinfo
      Layout.alignment: Qt.AlignCenter

      Image {
        id: lastplayedicon
        source: "../assets/images/gamepad.svg"
        fillMode: Image.PreserveAspectFit
        smooth: true
        Layout.preferredWidth: vpx(25)
        opacity: 0.75
        Layout.alignment: Qt.AlignLeft
      }

      Text {
        id: lastplayedtext
        text: (gameData.playCount > 0) ? gameData.playCount + " times" : "Never played"
        color: "white"
        font.pixelSize: vpx(14)
        font.family: globalFonts.sans
        //font.bold: true
        Layout.alignment: Qt.AlignLeft
        font.capitalization: Font.AllUppercase
      }
    }*/

  }

  RowLayout {
    id: metadata
    anchors { top: gameTitle.bottom; topMargin: vpx(-5);  }
    height: vpx(1)
    spacing: 6

    // Platform name
    /*GameGridMetaBox {
      metatext: api.currentCollection.name
    }*/

    // Developer
    GameGridMetaBox {
      metatext: (gameData.developerList[0] != undefined) ? gameData.developerList[0] : "Unknown"
    }

    // Release year
    GameGridMetaBox {
      metatext: (gameData.release != "") ? gameData.year : ""
    }

    /*GameGridMetaBox {
      metatext: if (gameData.players > 1)
        gameData.players + " players"
      else
        gameData.players + " player"
    }*/

    /*GameGridMetaBox {
      metatext: gameData.genreList[0]
      visible: (gameData.genreList[0] != undefined)
    }*/

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

  Text {
      id: gameDescription

      width: vpx(800)
      height: vpx(100)
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

    DropShadow {
        anchors.fill: gameDescription
        horizontalOffset: 0
        verticalOffset: 0
        radius: 8.0
        samples: 17
        color: "#80000000"
        source: gameDescription
    }
}
