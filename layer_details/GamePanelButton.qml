import QtQuick 2.8
import QtGraphicalEffects 1.0


Rectangle {
    id: root

    signal clicked()

    property alias text: label.text
    //property bool activated: false

    color: focus ? "#FF9E12" : (mouseArea.containsMouse ? "#FF9E12" : "transparent")
    Behavior on color {
      ColorAnimation {
        duration: 200;
        easing.type: Easing.OutQuart;
        easing.amplitude: 2.0;
        easing.period: 1.5
      }
    }
    width: parent.width
    //border.width: vpx(1)

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
        hoverEnabled: true
    }

    Text {
        id: label
        color: (root.focus || mouseArea.containsMouse) ? "#fff" : "#666"
        Behavior on color {
          ColorAnimation {
            duration: 200;
            easing.type: Easing.OutQuart;
            easing.amplitude: 2.0;
            easing.period: 1.5
          }
        }
        font {
            pixelSize: root.focus ? vpx(28) : vpx(25)
            family: globalFonts.sans
            bold: root.focus
        }
        // DropShadow
        /*layer.enabled: (root.focus || mouseArea.containsMouse)
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 2
            radius: 3.0
            samples: 17
            color: "#80000000"
            transparentBorder: true
        }*/
        anchors.centerIn: parent

    }
}
