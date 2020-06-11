import QtQuick 2.0
import SortFilterProxyModel 0.2

Item {
id: root
    
    readonly property alias games: gamesFiltered
    function currentGame(index) { return api.allGames.get(genreGames.mapToSource(index)) }
    property int max: genreGames.count
    property string genre: ""

    SortFilterProxyModel {
    id: genreGames

        sourceModel: api.allGames
        filters: RegExpFilter { roleName: "genre"; pattern: genre; caseSensitivity: Qt.CaseInsensitive; }
        sorters: RoleSorter { roleName: "rating"; sortOrder: Qt.DescendingOrder }
    }

    SortFilterProxyModel {
    id: gamesFiltered

        sourceModel: genreGames
        filters: IndexFilter { maximumIndex: max }
    }

    property var collection: {
        return {
            name:       "Top " + genre + " games",
            shortName:  genre + "games",
            games:      gamesFiltered
        }
    }
}