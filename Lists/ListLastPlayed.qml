import QtQuick 2.0
import SortFilterProxyModel 0.2

Item {
id: root

    property alias games: gamesFiltered
    function currentGame(index) { return api.allGames.get(lastPlayedGames.mapToSource(index)) }
    property int max: lastPlayedGames.count

    SortFilterProxyModel {
    id: lastPlayedGames

        sourceModel: api.allGames
        sorters: RoleSorter { roleName: "lastPlayed"; sortOrder: Qt.DescendingOrder }
    }

    SortFilterProxyModel {
    id: gamesFiltered

        sourceModel: lastPlayedGames
        filters: IndexFilter { maximumIndex: max }
    }

    property var collection: {
        return {
            name:       "Continue playing",
            shortName:  "lastplayed",
            games:      gamesFiltered
        }
    }
}