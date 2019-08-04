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
    id: temp
    anchors {
      fill: parent
    }

    color: "white"
  }
}
