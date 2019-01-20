import QtQuick 2.8
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0
import "../utils.js" as Utils

Item {
  id: root

  property var gameData//: api.currentGame
  property bool issteam: false
  anchors.horizontalCenter: parent.horizontalCenter
  clip: true


  /*Text {
    id: collectiontitle

    anchors {
      top: parent.top; topMargin: vpx(35);
      left: parent.left
    }
    width: parent.width
    text: (api.filters.current.enabled) ? api.currentCollection.name + " | Favorites" : api.currentCollection.name
    color: "white"
    font.pixelSize: vpx(16)
    font.family: globalFonts.sans
    //font.capitalization: Font.AllUppercase
    elide: Text.ElideRight
    //opacity: 0.5
  }

  DropShadow {
      anchors.fill: collectiontitle
      horizontalOffset: 0
      verticalOffset: 0
      radius: 8.0
      samples: 17
      color: "#80000000"
      source: collectiontitle
      //opacity: 0.5
  }*/

  /*// Logo
  // NOTE: Tried it but doubling up with the grid logo doesn't make sense.
  // Maybe if using boxart for grid it could work
  Image {
    id: detailslogo

    anchors {
      //top: parent.top;  topMargin: vpx(60);
      verticalCenter: parent.verticalCenter
      left: parent.left
    }

    asynchronous: true

    opacity: 0
    source: (!issteam) ? gameData.assets.logo : ""
    sourceSize { width: vpx(350); }
    fillMode: Image.PreserveAspectFit
    smooth: true
    visible: gameData.assets.logo || ""
    z:5
  }

  DropShadow {
      anchors.fill: detailslogo
      horizontalOffset: 0
      verticalOffset: 0
      radius: 8.0
      samples: 17
      color: "#80000000"
      source: detailslogo
      visible: gameData.assets.logo
  }*/


  Text {
    id: gameTitle

    anchors {
      verticalCenter: parent.verticalCenter
    }
    width: vpx(850)
    text: gameData.title
    color: "white"
    font.pixelSize: vpx(70)
    font.family: titleFont.name
    font.bold: true
    //font.capitalization: Font.AllUppercase
    elide: Text.ElideRight
    //visible: (gameData.assets.logo == "") ? true : false
    //style: Text.Outline; styleColor: "#cc000000"
  }

  DropShadow {
      anchors.fill: gameTitle
      horizontalOffset: 0
      verticalOffset: 0
      radius: 8.0
      samples: 17
      color: "#ff000000"
      source: gameTitle
      //visible: (gameData.assets.logo == "") ? true : false
  }

  ColumnLayout {
    id: playinfo
    anchors {
      //top: gameTitle.top; topMargin: vpx(30);
      right: parent.right; rightMargin: vpx(60)
      verticalCenter: parent.verticalCenter
    }

    width: vpx(150)
    spacing: vpx(4)


    Image {
      id: wreath
      source: (gameData.rating > 0.89) ? "../assets/images/wreath-gold.svg" : "../assets/images/wreath.svg"
      asynchronous: true
      fillMode: Image.PreserveAspectFit
      smooth: true
      Layout.preferredWidth: vpx(100)
      Layout.preferredHeight: vpx(100)

      opacity: (gameData.rating != "") ? 1 : 0.3
      //visible: (gameData.rating != "") ? 1 : 0
      Layout.alignment: Qt.AlignCenter
      sourceSize.width: vpx(128)
      sourceSize.height: vpx(128)

      Text {
        id: metarating
        text: (gameData.rating == "") ? "NA" : Math.round(gameData.rating * 100)
        color: (gameData.rating > 0.89) ? "#FFCE00" : "white"
        font.pixelSize: vpx(45)
        font.family: globalFonts.condensed
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors { top: parent.top; topMargin: vpx(20) }
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


    Text {
      id: ratingtext
      text: (gameData.rating == "") ? "No Rating" : "Rating"
      color: "white"
      font.pixelSize: vpx(16)
      font.family: globalFonts.condensed
      font.bold: true
      horizontalAlignment: Text.AlignHCenter
      Layout.topMargin: vpx(-12)
      Layout.preferredWidth: parent.width
      font.capitalization: Font.AllUppercase
    }


    Item {
      id: spacerhack
      Layout.preferredHeight: vpx(5)
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
    anchors {
      //top: (gameData.assets.logo == "") ? gameTitle.bottom : detailslogo.bottom;
      //topMargin: (gameData.assets.logo == "") ? vpx(-5) : vpx(10);
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
      metatext: (gameData.release != "") ? gameData.release.getFullYear() : ""
    }

    /*// Number of supported players
    GameGridMetaBox {
      metatext: if (gameData.players > 1)
        gameData.players + " players"
      else
        gameData.players + " player"
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

  /*Text {
      id: gameDescription

      width: vpx(800)
      height: vpx(100)
      anchors {
        top: metadata.bottom; topMargin: vpx(30)
        left: parent.left
      }

      text: gameData.summary || gameData.description
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
    }*/
}
