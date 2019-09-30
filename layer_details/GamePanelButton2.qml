import QtQuick 2.8
import QtGraphicalEffects 1.0


Rectangle {
    id: root

    signal clicked()

    property alias text: label.text
    //property bool activated: false

    color: focus ? themeColour : (mouseArea.containsMouse ? "#404040" : "#121212")
    Behavior on color {
      ColorAnimation {
        duration: 200;
        easing.type: Easing.OutQuart;
        easing.amplitude: 2.0;
        easing.period: 1.5
      }
    }

    scale: focus ? 1.12 : 1.0
    Behavior on scale { PropertyAnimation { duration: 200; easing.type: Easing.OutQuart; easing.amplitude: 2.0; } }
    opacity: focus ? 1 : 0.8
    Behavior on opacity { NumberAnimation { duration: 100 } }
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
            pixelSize: vpx(16)
            family: subtitleFont.name
            bold: true
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
