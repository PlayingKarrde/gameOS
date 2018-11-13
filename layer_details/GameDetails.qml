import QtQuick 2.8
import QtGraphicalEffects 1.0
import QtMultimedia 5.9

Item {
  id: root
  signal launchRequested
  signal detailsCloseRequested

  Keys.onPressed: {
      if (event.isAutoRepeat)
          return;

      if (api.keys.isAccept(event.key)) {
          event.accepted = true;
          api.collections.index = gameList.currentIndex
          root.launchRequested()
          return;
      }
      if (api.keys.isCancel(event.key)) {
            event.accepted = true;
            detailsCloseRequested
            return;
        }
      if (api.keys.isFilters(event.key)) {
          event.accepted = true;
          filtersRequested();
          return;
      }
    }

}
