import QtQuick 2.0
import SortFilterProxyModel 0.2

Item {
id: root
    
    readonly property alias games: gamesFiltered
    function currentGame(index) { return api.allGames.get(lastplayedFavorites.mapToSource(index)) }
    property int max: lastplayedFavorites.count

    SortFilterProxyModel {
    id: lastplayedFavorites

        sourceModel: api.allGames
        filters: ValueFilter { roleName: "favorite"; value: true }
        sorters: RoleSorter { roleName: "lastPlayed"; sortOrder: Qt.DescendingOrder; }
    }

    SortFilterProxyModel {
    id: gamesFiltered

        sourceModel: lastplayedFavorites
        filters: IndexFilter { maximumIndex: max }
    }

    property var collection: {
        return {
            name:       "Favorite games",
            shortName:  "favorites",
            games:      gamesFiltered
        }
    }
}