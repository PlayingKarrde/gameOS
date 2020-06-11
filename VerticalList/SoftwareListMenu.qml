import QtQuick 2.0
import QtQuick.Layouts 1.11
import "../Global"

FocusScope {
id: root

    property real itemheight: vpx(50)
    property int skipnum: 10

    Image {
    id: screenshot

        anchors {
            top: parent.top
            left: softwarelist.right
            right: parent.right
            bottom: parent.bottom
        }
        asynchronous: true
        source: currentGame && currentGame.assets.screenshots[0] ? currentGame.assets.screenshots[0] : ""
        fillMode: Image.PreserveAspectCrop
        smooth: true

        GameInfo {
        id: info

            anchors {
                left: parent.left; leftMargin: globalMargin
                right: parent.right; rightMargin: globalMargin
                bottom: parent.bottom; bottomMargin: globalMargin + helpMargin
            }
            height: vpx(230)
        }
    }

    HeaderBar {
    id: header
        
        anchors {
            top:    parent.top
            left:   parent.left
            right:  parent.right
        }
        height: vpx(75)
    }
    
    // Software list
    ListView {
    id: softwarelist

        currentIndex: currentGameIndex
        onCurrentIndexChanged: {
            if (currentIndex != -1)
                currentGameIndex = currentIndex;
        }

        focus: true
        
        anchors {
            top: header.bottom; topMargin: globalMargin
            bottom: parent.bottom; bottomMargin: globalMargin
            left: parent.left
        }
        width: vpx(400)

        spacing: vpx(0)
        orientation: ListView.Vertical

        preferredHighlightBegin: softwarelist.height / 2 - itemheight
        preferredHighlightEnd: softwarelist.height / 2
        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 100
        clip: true

        model: currentCustomCollection.games
        delegate: softwarelistdelegate

        // List item
        Component {
        id: softwarelistdelegate

            Item {
            id: delegatecontainer

                width: ListView.view.width
                height: itemheight
                property bool selected: ListView.isCurrentItem

                Rectangle {
                    width: vpx(3)
                    anchors { 
                        left: parent.left; leftMargin: vpx(11)
                        top: parent.top; topMargin: vpx(5)
                        bottom: parent.bottom; bottomMargin: vpx(5)
                        }
                    color: theme.text
                    visible: selected
                }

                Text {
                id: gametitle

                    text: modelData.title
                    
                    height: parent.height
                    anchors {
                        left: parent.left; leftMargin: vpx(25)
                        right: parent.right; rightMargin: vpx(25)
                    }
                    
                    color: theme.text
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(20)
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    opacity: selected ? 1 : 0.2
                }

                // Mouse/touch functionality
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (selected)
                            launchGame();
                        else
                            softwarelist.currentIndex = index
                    }
                }
            }
        }
    }

    // Handle input
    // Up
    Keys.onUpPressed: {
        if (softwarelist.currentIndex != 0)
            softwarelist.currentIndex--;
        else
            softwarelist.currentIndex = softwarelist.count - 1
    }
    // Down
    Keys.onDownPressed: {
        if (softwarelist.currentIndex != softwarelist.count - 1)
            softwarelist.currentIndex++;
        else
            softwarelist.currentIndex = 0;
    }
    // Left
    Keys.onLeftPressed: {
        if (softwarelist.currentIndex > skipnum)
            softwarelist.currentIndex = softwarelist.currentIndex - skipnum;
        else
            softwarelist.currentIndex = 0;
    }
    // Right
    Keys.onRightPressed:  {
        if (softwarelist.currentIndex < softwarelist.count - skipnum)
            softwarelist.currentIndex = softwarelist.currentIndex + skipnum;
        else
            softwarelist.currentIndex = softwarelist.count - 1
    }

    Keys.onPressed: {
        // Accept
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (softwarelist.focus) {
                launchGame();
            } else {
                currentGameIndex = 0;
                softwarelist.focus = true;
            }
            
        }
        // Back
        if (api.keys.isCancel(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (softwarelist.focus) {
                previousScreen();
            } else {
                currentGameIndex = 0;
                softwarelist.focus = true;
            }
        }
        // Filters
        if (api.keys.isFilters(event) && !event.isAutoRepeat) {
            event.accepted = true;
            toggleFavs();
        }
        // Details
        if (api.keys.isDetails(event) && !event.isAutoRepeat) {
            event.accepted = true;
            toggleSort();
        }
    }

    // Helpbar buttons
    ListModel {
        id: gridviewHelpModel

        ListElement {
            name: "Back"
            button: "cancel"
        }
        ListElement {
            name: "Order"
            button: "details"
        }
        ListElement {
            name: "Filter"
            button: "filters"
        }
        ListElement {
            name: "View details"
            button: "accept"
        }
    }
    
    onFocusChanged: { if (focus) currentHelpbarModel = gridviewHelpModel; }
}