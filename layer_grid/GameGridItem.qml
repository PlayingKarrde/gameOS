import QtQuick 2.11
import QtMultimedia 5.9
import QtGraphicalEffects 1.0

Item {

  id: root

  property bool selected: false
  property var game
  property int cornerradius: 0
  property var collection: api.currentCollection
  property bool steam: false

  signal clicked

  /////////////////
  // VIDEO STUFF //
  /////////////////

  onSelectedChanged: {
    if (selected) {
      videoDelay.restart();
    }
    else {
      videoPreviewLoader.sourceComponent = undefined;
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
    interval: 300
    onTriggered: {
      if (selected && game.assets.videos.length) {
        videoPreviewLoader.sourceComponent = videoPreviewWrapper;
      }
    }
  }

  ////////////////////////
  // END OF VIDEO STUFF //
  ////////////////////////

  // Border
  Rectangle {
    id: itemcontainer
    state: selected ? "SELECTED" : "UNSELECTED"

    width: root.gridItemWidth
    height: root.gridItemHeight
    anchors {
      fill: parent
      margins: gridItemSpacing
    }

    radius: cornerradius

    scale: selected ? 1.15 : 1.0
    Behavior on scale { PropertyAnimation { duration: 200; easing.type: Easing.OutQuart; easing.amplitude: 2.0; } }

    // DropShadow
    layer.enabled: selected
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 0
        radius: 10.0
        samples: 17
        color: "#80000000"
        transparentBorder: true
    }

    // Animation layer
    Rectangle {
      id: rectAnim
      width: parent.width
      height: parent.height
      visible: selected
      color: "white"
      radius: cornerradius

      // Looping colour animation
      SequentialAnimation on opacity {
        id: colorAnim
        running: true
        loops: Animation.Infinite
        NumberAnimation { to: 1; duration: 200; }
        NumberAnimation { to: 0; duration: 500; }
        PauseAnimation { duration: 200 }
      }
    }

    // Background for transparent images (to hide the border transition)
    Rectangle {
      width: root.gridItemWidth
      height: root.gridItemHeight
      anchors {
        fill: parent
        margins: vpx(3)
      }
      color: "#1a1a1a"
      radius: cornerradius
    }

    // Video preview
    Component {
      id: videoPreviewWrapper
      Video {
        source: game.assets.videos.length ? game.assets.videos[0] : ""
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
        muted: true
        loops: MediaPlayer.Infinite
        autoPlay: true


      }

    }

    Loader {
      id: videoPreviewLoader
      asynchronous: true
      anchors {
        fill: parent
        margins: vpx(4)
      }
      z: 3
    }



    // Actual art
    Image {
      id: screenshot

      width: root.gridItemWidth
      height: root.gridItemHeight
      anchors {
        fill: parent
        margins: vpx(4)
      }

      asynchronous: true
      visible: game.assets.screenshots[0] || ""

      smooth: true

      source: (steam) ? game.assets.logo : game.assets.screenshots[0] || ""
      sourceSize { width: 256; height: 256 }
      fillMode: Image.PreserveAspectCrop

      property bool rounded: true
      property bool adapt: true

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
      }
    }

    // Dim overlay
    Rectangle {
      width: root.gridItemWidth
      height: root.gridItemHeight
      anchors {
        fill: parent
        margins: vpx(3)
      }
      color: "black"
      opacity: 0.4
      visible: !steam || ""
      z:4
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

      opacity: 0
      source: (!steam) ? game.assets.logo : ""
      sourceSize { width: 256; height: 256 }
      fillMode: Image.PreserveAspectFit
      smooth: true
      visible: game.assets.logo || ""
      z:5
    }

    DropShadow {
        anchors.fill: gamelogo
        horizontalOffset: 0
        verticalOffset: 0
        radius: 8.0
        samples: 17
        color: "#80000000"
        source: gamelogo
    }

    Image {
      id: favebg
      source: "../assets/images/favebg.svg"
      width: vpx(32)
      height: vpx(32)
      anchors { top: screenshot.top; topMargin: vpx(0); right: screenshot.right; rightMargin: vpx(0) }
      visible: false

    }
    ColorOverlay {
        anchors.fill: favebg
        source: favebg
        color: "#FF9E12"
        visible: game.favorite
        z: 10
    }

    Image {
      id: star
      source: "../assets/images/star.svg"
      width: vpx(13)
      height: vpx(13)
      anchors { top: screenshot.top; topMargin: vpx(3); right: screenshot.right; rightMargin: vpx(3) }
      smooth: true
      visible: game.favorite
      z: 11
    }

    //////////////////////////
    // States for animation //
    //////////////////////////
    states: [
      State {
        name: "SELECTED"
        PropertyChanges { target: screenshot; opacity: 1 }
        PropertyChanges { target: itemcontainer; color: "#FF9E12"}
        PropertyChanges { target: rectAnim; opacity: 1 }
        PropertyChanges { target: screenshot; opacity: 1 }
        PropertyChanges { target: gamelogo; opacity: 1 }
      },
      State {
        name: "UNSELECTED"
        PropertyChanges { target: screenshot; opacity: 1 }
        PropertyChanges { target: itemcontainer; color: "transparent"}
        PropertyChanges { target: rectAnim; opacity: 0 }
        PropertyChanges { target: screenshot; opacity: 0.5 }
        PropertyChanges { target: gamelogo; opacity: 0.5 }
      }
    ]

    transitions: [
      Transition {
        from: "SELECTED"
        to: "UNSELECTED"
        PropertyAnimation { target: rectAnim; duration: 100 }
        ColorAnimation { target: itemcontainer; duration: 100 }
        PropertyAnimation { target: rectAnim; duration: 100 }
        PropertyAnimation { target: screenshot; duration: 100 }
        PropertyAnimation { target: gamelogo; duration: 100 }
      },
      Transition {
        from: "UNSELECTED"
        to: "SELECTED"
        PropertyAnimation { target: rectAnim; duration: 100 }
        ColorAnimation { target: itemcontainer; duration: 100 }
        PropertyAnimation { target: rectAnim; duration: 1000 }
        PropertyAnimation { target: screenshot; duration: 100 }
        PropertyAnimation { target: gamelogo; duration: 100 }
      }
    ]
  }

  Image {
    anchors.centerIn: parent

    visible: screenshot.status === Image.Loading
    source: "../assets/images/loading.svg"
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
      onWheel: {}
      onClicked: {
        if (selected)
          api.currentGame.launch()
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
    anchors.centerIn: parent
    elide: Text.ElideRight
    wrapMode: Text.WordWrap
    horizontalAlignment: Text.AlignHCenter

  }
}
