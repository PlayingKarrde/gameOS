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
        filters: IndexFilter { maximumIndex: max - 1 }
    }

    property var collection: {
        return {
            name:       "Most Played Games",
            shortName:  "mostplayed",
            games:      gamesFiltered
        }
    }
}