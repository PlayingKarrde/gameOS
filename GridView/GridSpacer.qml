import QtQuick 2.0
import "../utils.js" as Utils
Image {
id: root

    property var games

    // This is a workaround that's necessary in order to accurately get the aspect ratio for the boxart
    // It grabs the first game and bases all the aspect ratios off that
    property var fakesource: {
        for (var i = 0; i < 5; i++)
        {
            var gamesource = currentCollection.games.get(i);
            if (Utils.boxArt(gamesource) !== "")
            {
                return Utils.boxArt(gamesource);
            }
        }
    }

    sourceSize { width: 50; height: 50 }
    fillMode: Image.PreserveAspectFit
    source: fakesource ? fakesource : ""
    asynchronous: false
    visible: false
}
