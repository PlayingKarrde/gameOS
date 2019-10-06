import QtQuick 2.8
import QtGraphicalEffects 1.0

FocusScope {
  id: root
  Item {
    id: background
    width: parent.width
    height: parent.height

    LinearGradient {
      id: bggradient
      z: parent.z + 1
      width: parent.width
      height: parent.height
      anchors {
        top: parent.top;
        right: parent.right
        bottom: controllerBG.top
      }
      start: Qt.point(0, 0)
      end: Qt.point(0, height)
      gradient: Gradient {
        GradientStop { position: 0.0; color: "#00000000" }
        GradientStop { position: 0.3; color: "#e6000000" }
      }
      opacity: 1
      Behavior on opacity { NumberAnimation { duration: 100 } }

      Item {
        id: buttonContainer
        width: parent.width
        height: vpx(20)
        anchors {
          bottom: parent.bottom
          bottomMargin: vpx(15)
        }
        Image {
          id: button1
          height: vpx(25)
          width: height
          source: "assets/images/controllerButton.svg"
          sourceSize: vpx(64)
          transform: Rotation { angle: 0}
          anchors {
            right: buttonBack.left
            rightMargin: vpx(5)
          }
        }

        Item {
          id: buttonBack
          width: txtBack.width
          height: parent.height
          Text {
            id: txtBack
            text: "Back"
            color: "white"
            font.pixelSize: vpx(14)
            font.family: bodyFont.name
          }
          anchors {
            right: parent.right
            rightMargin: vpx(25)
          }
        }
      }

    }//bggradient
  }//background
}//root
