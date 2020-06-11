import QtQuick 2.0
import QtQuick.Layouts 1.11
import "qrc:/qmlutils" as PegasusUtils

Item {
id: infocontainer

    property var gameData: currentGame

    // Game title
    Text {
    id: gametitle
        
        text: gameData ? gameData.title : ""
        
        anchors {
            top:    parent.top;
            left:   parent.left;
            right:  parent.right
        }
        
        color: theme.text
        font.family: titleFont.name
        font.pixelSize: vpx(44)
        font.bold: true
        horizontalAlignment: Text.AlignHLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // Meta data
    Item {
    id: metarow

        height: vpx(50)
        anchors {
            top: gametitle.bottom; 
            left: parent.left
            right: parent.right
        }

        // Rating box
        Text {
        id: ratingtitle

            width: contentWidth
            height: parent.height
            anchors { left: parent.left; }
            verticalAlignment: Text.AlignVCenter
            text: "Rating: "
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
        id: ratingtext
            
            property real processedRating: gameData ? Math.round(gameData.rating * 100) / 100 : ""
            width: contentWidth
            height: parent.height
            anchors { left: ratingtitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: steam ? processedRating*5 : processedRating
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }

        Rectangle {
        id: divider1
            width: vpx(2)
            anchors {
                left: ratingtext.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
        }

        // Players box
        Text {
        id: playerstitle

            width: contentWidth
            height: parent.height
            anchors { left: divider1.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: "Players: "
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
        id: playerstext

            width: contentWidth
            height: parent.height
            anchors { left: playerstitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: gameData ? gameData.players : ""
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }

        Rectangle {
        id: divider2
            width: vpx(2)
            anchors {
                left: playerstext.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
        }

        // Genre box
        Text {
        id: genretitle

            width: contentWidth
            height: parent.height
            anchors { left: divider2.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: "Genre: "
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
        id: genretext

            anchors { 
                left: genretitle.right; leftMargin: vpx(5)
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            verticalAlignment: Text.AlignVCenter
            text: gameData ? gameData.genre : ""
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            elide: Text.ElideRight
            color: theme.text
        }
    }

    // Description
    PegasusUtils.AutoScroll
    {
    id: gameDescription
    
        anchors {
            left: parent.left; 
            right: parent.right;
            top: metarow.bottom
            bottom: parent.bottom;
        }

        Text {
            width: parent.width
            text: gameData && (gameData.summary || gameData.description) ? gameData.description || gameData.summary : "No description available"
            font.pixelSize: vpx(16)
            font.family: bodyFont.name
            color: theme.text
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
        }
    }
    
}