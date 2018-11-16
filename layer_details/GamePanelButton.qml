import QtQuick 2.8


Rectangle {
    id: root

    signal clicked()

    property alias text: label.text

    color: focus ? "#4ae" : (mouseArea.containsMouse ? "#999" : "transparent")
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
        color: root.focus ? "#eee" : "#666"
        font {
            pixelSize: vpx(18)
            family: globalFonts.sans
            bold: true
        }
        anchors.centerIn: parent
    }
}
