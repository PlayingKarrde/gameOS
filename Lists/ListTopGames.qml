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
        //filters: IndexFilter { maximumIndex: max }
    }

    SortFilterProxyModel {
    id: gamesWithLimit

        sourceModel: gamesFiltered
        filters: IndexFilter { maximumIndex: max }
    }

    property var collection: {
        return {
            name:       "All games",
            shortName:  "allgames",
            games:      shuffle(gamesWithLimit)
        }
    }
}