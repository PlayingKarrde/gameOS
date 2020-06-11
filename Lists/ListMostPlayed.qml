import QtQuick 2.0
import SortFilterProxyModel 0.2

Item {
id: root

    readonly property alias games: gamesFiltered
    function currentGame(index) { return api.allGames.get(mostPlayedGames.mapToSource(index)) }
    property int max: mostPlayedGames.count

    SortFilterProxyModel {
    id: mostPlayedGames

        sourceModel: api.allGames
        sorters: RoleSorter { roleName: "playCount"; sortOrder: Qt.DescendingOrder }
    }

    SortFilterProxyModel {
    id: gamesFiltered

        sourceModel: mostPlayedGames
        filters: IndexFilter { maximumIndex: max }
    }

    property var collection: {
        return {
            name:       "Most played games",
            shortName:  "mostplayed",
            games:      gamesFiltered
        }
    }
}