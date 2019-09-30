import QtQuick 2.8
import QtGraphicalEffects 1.0
import "qrc:/qmlutils" as PegasusUtils

Item {
  id: root

  signal closeRequested

  Keys.onPressed: {
      if (event.isAutoRepeat)
          return;

      if (api.keys.isDetails(event)) {
          event.accepted = true;
          return;
      }
      if (api.keys.isCancel(event)) {
          event.accepted = true;
          closeRequested();
          return;
        }
      if (api.keys.isFilters(event)) {
          event.accepted = true;
          //toggleFilters()
          closeRequested()
          //filtersRequested();
          return;
      }
  }

  Rectangle {
    id: menubar
    property real contentWidth: width - vpx(100)

    width: parent.width
    height: parent.height
    color: "#000"
    opacity: 0

    }

    /*Image {
      id: logo

      width: menubar.contentWidth
      height: vpx(75)

      fillMode: Image.PreserveAspectFit
      source: "../assets/images/logos/" + collection.shortName + ".svg"
      asynchronous: true
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      anchors.topMargin: vpx(80)
      opacity: 0.75
    }*/

    // Highlight
    Component {
      id: highlight
      Rectangle {
        width: settingsList.cellWidth; height: settingsList.cellHeight
        color: "#FF9E12"
        x: settingsList.currentItem.x
        y: settingsList.currentItem.y
        Behavior on y { NumberAnimation {
          duration: 300;
          easing.type: Easing.OutQuart;
          easing.amplitude: 2.0;
          easing.period: 1.5}
        }
      }
    }

    // Menu
    ListView {
      id: settingsList
      width: parent.width

      preferredHighlightBegin: vpx(160); preferredHighlightEnd: vpx(160)
      highlightRangeMode: ListView.ApplyRange

      anchors {
        top: parent.bottom; topMargin: vpx(70)
        left: parent.left;
        right: parent.right
        bottom: parent.bottom; bottomMargin: vpx(80)
      }

      //model: collectionList

      delegate: settingsListItemDelegate
      currentIndex: collectionIdx
      onCurrentIndexChanged: navSound.play()
      highlight: highlight
      highlightFollowsCurrentItem: true
      focus: true
    }

    // Menu item
    Component {
      id: settingsListItemDelegate

      Item {
        id: menuitem
        readonly property bool selected: ListView.isCurrentItem
        width: menubar.width
        height: vpx(40)

        Text {
          text: modelData.name

          anchors { left: parent.left; leftMargin: vpx(50)}
          color: selected ? "#fff" : "#666"
          Behavior on color {
            ColorAnimation {
              duration: 200;
              easing.type: Easing.OutQuart;
              easing.amplitude: 2.0;
              easing.period: 1.5
            }
          }
          font.pixelSize: vpx(25)
          font.family: globalFonts.sans
          //font.capitalization: Font.AllUppercase
          font.bold: selected
          //width: ListView.view.width
          height: vpx(40)
          verticalAlignment: Text.AlignVCenter
          elide: Text.ElideRight

        }

        MouseArea {
          anchors.fill: menuitem
          hoverEnabled: true
          onEntered: {}
          onExited: {}
          onWheel: {}
          onClicked: {
            //switchCollection(index);
            //closeMenu();
          }
        }
      }
    }

}
