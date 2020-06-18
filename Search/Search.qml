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
import "../utils.js" as Utils

Item {
id: root

    readonly property alias games: filteredModel
    function currentGame(index) { return api.allGames.get(filteredModel.mapToSource(index)) }

    property string     title
    property var        years:      [0,2500]
    property int        maxResults: 0
    property string     sortBy:     "sortTitle"
    property bool       descending

    property var allowedDevs:   []//Utils.uniqueGameValues('developerList').filter(e => e.selected).map(e => e.name)
    property var allowedPubs:   []//Utils.uniqueGameValues('publisherList').filter(e => e.selected).map(e => e.name)
    property var allowedGenres: []//Utils.uniqueGameValues('genreList').filter(e => e.selected).map(e => e.name)
    property var allowedTags:   []//Utils.uniqueGameValues('tagList').filter(e => e.selected).map(e => e.name)
    /*readonly property var allowedCollGames: {
        const allowedCollNames = api.collections.toVarArray().map(coll => coll.name);
        const allowedColls = api.collections.toVarArray().filter(e => allowedCollNames.includes(e.name));
        return [].concat( ...allowedColls.map(coll => coll.games.toVarArray()) );
    }*/

    SortFilterProxyModel {
    id: filteredModel

        sourceModel: api.allGames
        filters: [
            RegExpFilter {
                roleName: "title"
                pattern: title
                caseSensitivity: Qt.CaseInsensitive
            },
            ExpressionFilter {
                enabled: allowedDevs.length
                expression: allowedDevs && developerList.some(v => allowedDevs.includes(v))
            },
            ExpressionFilter {
                enabled: allowedPubs.length
                expression: allowedPubs && publisherList.some(v => allowedPubs.includes(v))
            },
            ExpressionFilter {
                enabled: allowedGenres.length
                expression: allowedGenres && genreList.some(v => allowedGenres.includes(v))
            },
            ExpressionFilter {
                enabled: allowedTags.length
                expression: allowedTags && tagList.some(v => allowedTags.includes(v))
            },
            ExpressionFilter {
                enabled: years.length
                expression: releaseYear == 0 || (years[0] <= releaseYear && releaseYear <= years[1])
            },
            IndexFilter { 
                enabled: maxResults != 0
                maximumIndex: maxResults - 1
            }/*,
            ExpressionFilter {
                enabled: allowedCollGames.length
                expression: allowedCollGames.includes(api.allGames.get(index))
            }/*,
            RangeFilter {
                roleName: "players"
                minimumValue: inPlayers.min
                maximumValue: inPlayers.max
            }*/
        ]

        sorters: [
            RoleSorter {
            id: sorter

                roleName: sortBy
                sortOrder: descending ? Qt.DescendingOrder : Qt.AscendingOrder
            }
        ]
    }
}

