import QtQuick 2.8
import QtMultimedia 5.9
import QtGraphicalEffects 1.0

Item {

  id: root

  // SETTINGS
  property var thumbnailType: "video"

  property bool selected: false
  property var game
  property var collection//: api.currentCollection
  property bool steam: false
  property real videoBorderWidth
  property real titleBottomMargin

  signal details
  signal clicked


  scale: selected ? 1 : 0.95
  Behavior on scale { PropertyAnimation { duration: 200; easing.type: Easing.OutQuart; easing.amplitude: 2.0; } }

  /////////////////
  // VIDEO STUFF //
  /////////////////

  onSelectedChanged: {
    if (thumbnailType == "video")
    {
      if (selected) {
        videoDelay.restart();
      }
      else {
        fadescreenshot.stop();
        screenshot.opacity = 1;
      }
    }
  }

  onCollectionChanged: {
    if (collection.shortName == "steam") {
      steam = true
    } else {
      steam = false
    }

  }


  Timer {
    id: videoDelay
    interval: 100
    onTriggered: {
      if (selected && game.assets.videos.length) {
        //videoPreviewLoader.sourceComponent = videoPreviewWrapper;
        fadescreenshot.restart();
      }
    }
  }

  Timer {
    id: fadescreenshot
    interval: 700
    onTriggered: {
      screenshot.opacity = 0;
    }
  }

  ////////////////////////
  // END OF VIDEO STUFF //
  ////////////////////////

  // Border
  Item {
    id: itemcontainer
    state: selected ? "SELECTED" : "UNSELECTED"

    anchors {
      fill: parent
      //leftMargin: gridItemSpacing
      //rightMargin: gridItemSpacing
      //topMargin: gridItemSpacing
      bottomMargin: titleBottomMargin
    }

    // DropShadow
    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 0
        radius: 15.0
        samples: 16
        color: selected ? "#00000000" : "#80000000"
        transparentBorder: true
    }


    // Actual art
    Image {
      id: screenshot

      width: root.gridItemWidth
      height: root.gridItemHeight
      z: 3
      anchors {
        fill: parent
        //margins: vpx(5)
      }

      asynchronous: true
      visible: game.assets.screenshots[0] || game.assets.boxFront || ""

      smooth: true

      source: (steam) ? game.assets.logo : game.assets.screenshots[0] || game.assets.boxFront || ""
      sourceSize { width: 256; height: 256 }
      fillMode: Image.PreserveAspectCrop

      property bool rounded: true
      property bool adapt: true

      Behavior on opacity { PropertyAnimation { duration: 1000; easing.type: Easing.OutQuart; easing.amplitude: 2.0; } }

      layer.enabled: rounded
      layer.effect: OpacityMask {
          maskSource: Item {
              width: screenshot.width
              height: screenshot.height
              Rectangle {
                  anchors.centerIn: parent
                  width: screenshot.width
                  height: screenshot.height
                  radius: cornerradius
              }
          }
      }//OpacityMask


    }//screenshot

    // Dim overlay
    Rectangle {
      id: dimoverlay
      width: root.gridItemWidth
      height: root.gridItemHeight
      anchors {
        fill: parent
        //margins: vpx(3)
      }
      color: "black"
      opacity: selected ? 0 : 0.4
      visible: !steam || ""
      z: (selected) ? 4 : 5
      radius: cornerradius
    }

    // Logo
    Image {
      id: gamelogo

      width: root.gridItemWidth
      height: root.gridItemHeight
      anchors {
        fill: parent
        margins: vpx(20)
      }

      asynchronous: true

      //opacity: 0
      source: (!steam) ? game.assets.logo : ""
      sourceSize { width: 256; height: 256 }
      fillMode: Image.PreserveAspectFit
      smooth: true
      visible: game.assets.logo || ""
      z:5
    }

    DropShadow {
      id: logoshadow
      anchors.fill: gamelogo
      horizontalOffset: 0
      verticalOffset: 0
      radius: 8.0
      samples: 17
      color: "#80000000"
      source: gamelogo
    }

    // Favourite tag
    Item {
      id: favetag
      anchors { fill: parent; }
      opacity: game.favorite ? 1 : 0
      Behavior on opacity { NumberAnimation { duration: 100 } }
      //width: parent.width
      //height: parent.height

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

      layer.enabled: true
      layer.effect: OpacityMask {
        maskSource: Item {
          width: favetag.width
          height: favetag.height
          Rectangle {
            anchors.centerIn: parent
            width: favetag.width
            height: favetag.height
            radius: cornerradius - vpx(1)
          }//rectangle
        }//item
      }//OpacityMask
    }


  }



  Image {
    anchors.centerIn: itemcontainer

    visible: screenshot.status === Image.Loading
    source: "../assets/images/loading.png"
    width: vpx(50)
    height: vpx(50)
    smooth: true
    RotationAnimator on rotation {
        loops: Animator.Infinite;
        from: 0;
        to: 360;
        duration: 500
    }
  }

  MouseArea {
      anchors.fill: itemcontainer
      hoverEnabled: true
      onEntered: {}
      onExited: {}
      onClicked: {
        if (selected)
          root.details()
        else
          root.clicked()
      }
  }



  Text {
    text: game.title
    width: itemcontainer.width - vpx(30)
    anchors { margins: vpx(10) }
    color: selected ? "orange" : "white"
    font.pixelSize: vpx(18)
    //font.family: openSans
    font.bold: true
    style: Text.Outline; styleColor: "black"
    visible: !game.assets.logo
    anchors.centerIn: itemcontainer
    elide: Text.ElideRight
    wrapMode: Text.WordWrap
    horizontalAlignment: Text.AlignHCenter

  }

  Text {
    id: selectedGameName

    anchors {
      horizontalCenter: parent.horizontalCenter
      top: itemcontainer.bottom
      topMargin: vpx(10)
    }
    horizontalAlignment: Text.AlignHCenter
    width: itemcontainer.width
    text: game.title
    color: "white"
    opacity: selected ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 100 } }
    font.pixelSize: vpx(14)
    font.family: subtitleFont.name
    font.bold: true
    //font.capitalization: Font.AllUppercase
    elide: Text.ElideRight
    //visible: (gameData.assets.logo == "") ? true : false
    //style: Text.Outline; styleColor: "#cc000000"
  }
}
