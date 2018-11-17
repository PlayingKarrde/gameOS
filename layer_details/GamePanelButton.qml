import QtQuick 2.8


Rectangle {
    id: root

    signal clicked()

    property alias text: label.text
    //property bool activated: false

    color: focus ? "#FF9E12" : (mouseArea.containsMouse ? "#FF9E12" : "transparent")
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
        font {
            pixelSize: vpx(25)
            family: globalFonts.sans
            bold: true
        }
        anchors.centerIn: parent
    }
}
