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
    
    readonly property alias games: gamesWithLimit
    function currentGame(index) { return api.allGames.get(gamesFiltered.mapToSource(index)) }
    property int max: gamesFiltered.count

    // Shuffle function
    function shuffle(model){
        var currentIndex = model.count, temporaryValue, randomIndex;

        // While there remain elements to shuffle...
        while (0 !== currentIndex) {
            // Pick a remaining element...
            randomIndex = Math.floor(Math.random() * currentIndex)
            currentIndex -= 1
            // And swap it with the current element.
            // the dictionaries maintain their reference so a copy should be made
            // https://stackoverflow.com/a/36645492/6622587
            temporaryValue = JSON.parse(JSON.stringify(model.get(currentIndex)))
            model.move(currentIndex, model.get(randomIndex))
            model.move(randomIndex, temporaryValue);
        }
        
        return model;
    }

    SortFilterProxyModel {
    id: gamesFiltered

        sourceModel: api.allGames
        sorters: RoleSorter { roleName: "rating"; sortOrder: Qt.DescendingOrder; }
    }

    SortFilterProxyModel {
    id: gamesWithLimit

        sourceModel: gamesFiltered
        filters: IndexFilter { maximumIndex: max - 1 }
    }
    
    property var collection: {
        return {
            name:       "All games",
            shortName:  "allgames",
            games:      shuffle(gamesWithLimit)
        }
    }
}