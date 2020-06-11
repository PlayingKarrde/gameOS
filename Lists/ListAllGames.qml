import QtQuick 2.0
import SortFilterProxyModel 0.2

Item {
id: root
    
    readonly property alias games: gamesFiltered
    function currentGame(index) { return api.allGames.get(gamesFiltered.mapToSource(index)) }
    property int max: gamesFiltered.count

    SortFilterProxyModel {
    id: gamesFiltered

        sourceModel: api.allGames
        filters: IndexFilter { maximumIndex: max }
    }

    property var collection: {
        return {
            name:       "All games",
            shortName:  "allgames",
            games:      gamesFiltered
        }
    }
}