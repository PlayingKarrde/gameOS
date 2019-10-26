import QtQuick 2.8
import QtGraphicalEffects 1.0

FocusScope {
  id: root
  property string buttonText1: "Back"
  property string controllerButton1: "A"
  property string buttonText2: "Select"
  property string controllerButton2: "A"
  property string buttonText3: showFavs ? "View Last Played" : showLastPlayed ? "View Collection" : "View Favourites"
  property string controllerButton3: "A"

  function processButtonArt(buttonModel) {
    var i;
    for (i = 0; buttonModel.length; i++) {
      if (buttonModel[i].name().includes("Gamepad")) {
        var buttonValue = buttonModel[i].key.toString(16)
        return buttonValue.substring(buttonValue.length-1, buttonValue.length);
      }
    }
  }

  Item {
    id: background

    width: parent.width
    height: parent.height

    opacity: (stateMenu || stateVideoPreview) ? 0 : 1
    Behavior on opacity { NumberAnimation { duration: 200 } }

    Component.onCompleted: {
      // This is a pretty gross way of doing this... controller help deserves better
      if (stateDetails) {
        button3Te
      }
    }

    LinearGradient {
      id: bggradient
      z: parent.z + 1
      width: parent.width
      height: parent.height
      anchors {
        top: parent.top
        right: parent.right
        bottom: parent.bottom
      }
      start: Qt.point(0, 0)
      end: Qt.point(0, height)
      gradient: Gradient {
        GradientStop { position: 0.0; color: "#00000000" }
        GradientStop { position: 0.3; color: "#99000000" }
      }
      opacity: 1
      Behavior on opacity { NumberAnimation { duration: 100 } }

      Item {
        id: buttonContainer
        width: parent.width
        height: vpx(20)
        opacity: 0.5
        anchors {
          bottom: parent.bottom
          bottomMargin: vpx(18)
        }

        Image {
          id: button1
          height: vpx(24)
          width: height
          source: "../assets/images/controller/"+ processButtonArt(api.keys.cancel) + ".png"
          sourceSize.width: vpx(32)
          sourceSize.height: vpx(32)
          anchors {
            right: button1Txt.left
            rightMargin: vpx(5)
          }
        }//button1

        Item {
          id: button1Txt
          width: txt1.width
          height: parent.height
          Text {
            id: txt1
            text: buttonText1
            color: "white"
            font.pixelSize: vpx(14)
            font.family: bodyFont.name
          }
          anchors {
            right: parent.right
            rightMargin: vpx(25)
          }
        }//buttonBack

        Image {
          id: button2
          height: vpx(24)
          width: height
          source: "../assets/images/controller/"+ processButtonArt(api.keys.accept) + ".png"
          sourceSize.width: vpx(32)
          sourceSize.height: vpx(32)
          anchors {
            right: button2Txt.left
            rightMargin: vpx(5)
          }
        }//button1

        Item {
          id: button2Txt
          width: txt2.width
          height: parent.height
          Text {
            id: txt2
            text: buttonText2
            color: "white"
            font.pixelSize: vpx(14)
            font.family: bodyFont.name
          }
          anchors {
            right: button1.left
            rightMargin: vpx(20)
          }
        }//button2
        /* Commenting out until filters are fixed
        Image {
          id: button3
          height: vpx(24)
          width: height
          source: "../assets/images/controller/"+ processButtonArt(api.keys.filters) + ".png"
          sourceSize.width: vpx(32)
          sourceSize.height: vpx(32)
          anchors {
            right: button3Txt.left
            rightMargin: vpx(5)
          }
          opacity: stateDetails ? 0 : 1
          Behavior on opacity { NumberAnimation { duration: 100 } }
        }//button3

        Item {
          id: button3Txt
          width: txt3.width
          height: parent.height
          Text {
            id: txt3
            text: buttonText3
            color: "white"
            font.pixelSize: vpx(14)
            font.family: bodyFont.name
          }
          anchors {
            right: button2.left
            rightMargin: vpx(20)
          }
          opacity: stateDetails ? 0 : 1
          Behavior on opacity { NumberAnimation { duration: 100 } }
        }//button3
        */
      }//buttonContainer

    }//bggradient
  }//background
}//root
