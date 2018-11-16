import QtQuick 2.8
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0

BorderImage {
  id: root
  property string metatext
  property string icon
  Layout.fillWidth: false
  Layout.minimumWidth: rowcontent.width + vpx(10);
  Layout.minimumHeight: rowcontent.height + vpx(5);
  Layout.alignment: Qt.AlignHCenter;

  border { left: vpx(3); top: vpx(3); right: vpx(3); bottom: vpx(3); }
  horizontalTileMode: BorderImage.Stretch
  verticalTileMode: BorderImage.Stretch
  source: "../assets/images/metabg.svg"

  RowLayout {
    id: rowcontent
    //width: parent.width
    //height: parent.height
    anchors.centerIn: parent
    Image {
      id: iconimage
      source: icon
      fillMode: Image.PreserveAspectFit
      smooth: true
      //Layout.preferredWidth: vpx(15)
      Layout.preferredHeight: vpx(15)
      Layout.maximumWidth: vpx(25)
      Layout.maximumHeight: vpx(15)
      opacity: 0.75
      visible: icon
    }

    Text {
      id: metastring
      text: (metatext) ? metatext : ""

      color: "#F2F2F2"
      font.pixelSize: vpx(12)
      //font.family: globalFonts.sans
      font.bold: true
      font.capitalization: Font.AllUppercase
      Layout.alignment: Qt.AlignVCenter
      //opacity: 0.75
    }

    // DropShadow
    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 0
        radius: 5.0
        samples: 10
        color: "#88000000"
        transparentBorder: true
    }
  }
  visible: (metatext != "") ? true : false
}
