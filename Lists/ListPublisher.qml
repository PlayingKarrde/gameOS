// gameOS theme
// Copyright (C) 2018-2020 Seth Powell 
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

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
        filters: IndexFilter { maximumIndex: max - 1 }
    }

    property var collection: {
        return {
            name:       "Top Games by " + publisher,
            shortName:  "publisher",
            games:      gamesFiltered
        }
    }
}