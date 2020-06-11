import QtQuick 2.0
import SortFilterProxyModel 0.2

Item {
id: root
    
    readonly property alias games: gamesFiltered
    property var collection: api.collections.get(currentCollectionIndex)
    function currentGame(index) { return collection.games.get(gamesFiltered.mapToSource(index)) }
    property int max

    SortFilterProxyModel {
    id: gamesFiltered

        sourceModel: collection.games
        filters: [
            ValueFilter { roleName: "favorite"; value: true; enabled: showFavs },
            RegExpFilter { roleName: "title"; pattern: searchTerm; caseSensitivity: Qt.CaseInsensitive; enabled: searchTerm != "" },
            IndexFilter { maximumIndex: max-1; enabled: max }
        ]
        sorters: [
            RoleSorter { roleName: sortByFilter[sortByIndex]; sortOrder: orderBy }
        ]
    }
}