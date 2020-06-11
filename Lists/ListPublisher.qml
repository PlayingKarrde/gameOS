import QtQuick 2.0
import SortFilterProxyModel 0.2

Item {
id: root
    
    readonly property alias games: gamesFiltered
    function currentGame(index) { return api.allGames.get(publisherGames.mapToSource(index)) }
    property int max: publisherGames.count

    property string publisher: "Nintendo"

    SortFilterProxyModel {
    id: publisherGames

        sourceModel: api.allGames
        filters: RegExpFilter { roleName: "publisher"; pattern: publisher; caseSensitivity: Qt.CaseInsensitive; }
        sorters: RoleSorter { roleName: "rating"; sortOrder: Qt.DescendingOrder }
    }

    SortFilterProxyModel {
    id: gamesFiltered

        sourceModel: publisherGames
        filters: IndexFilter { maximumIndex: max }
    }
}