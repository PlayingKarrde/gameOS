import QtQuick 2.8
import QtGraphicalEffects 1.0

FocusScope {
  id: root
  property string label: "Default"
  property string button: "controllerButton"
  property int buttonRotation: 0

  Image {
    id: buttonImg
    height: vpx(24)
    width: height
    source: "../assets/images/" + button + ".svg"
    sourceSize.width: vpx(32)
    sourceSize.height: vpx(32)
    transform: Rotation { origin.x: vpx(12); origin.y: vpx(12); angle: buttonRotation }
    anchors {
      right: buttonText.left
      rightMargin: vpx(10)
    }
  }

  Item {
    id: buttonText
    width: txt.width
    height: parent.height
    Text {
      id: txt
      text: label
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
