import QtQuick 2.0
import QtQuick.Layouts 1.11

Item {
id: root

    Component {
        id: buttonhelpDelegate
        Row {
            spacing: 10
            Image {
                source: "../assets/images/controller/" + processButtonArt(button) + ".png"
                width: vpx(30)
                height: vpx(30)
            }
            Text { 
                text: name
                font.family: subtitleFont.name
                font.pixelSize: vpx(16)
                color: theme.text
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    ListView {
        anchors.fill: parent
        model: currentHelpbarModel
        delegate: buttonhelpDelegate
        orientation: ListView.Horizontal
        layoutDirection: Qt.RightToLeft
        spacing: vpx(20)
    }

    visible: currentHelpbarModel ? true : false

    // Processes the button and will display the correct art based on the button mappings set in Pegasus
    // Necessary as we can't use script in the ListModel
    function processButtonArt(button) {
        var buttonModel;
        switch (button) {
            case "accept":
            buttonModel = api.keys.accept;
            break;
            case "cancel":
            buttonModel = api.keys.cancel;
            break;
            case "filters":
            buttonModel = api.keys.filters;
            break;
            case "details":
            buttonModel = api.keys.details;
            break;
            case "nextPage":
            buttonModel = api.keys.nextPage;
            break;
            case "prevPage":
            buttonModel = api.keys.prevPage;
            break;
            case "pageUp":
            buttonModel = api.keys.pageUp;
            break;
            case "pageDown":
                buttonModel = api.keys.pageDown;
                break;
            default:
            buttonModel = api.keys.accept;
        }

        var i;
        for (i = 0; buttonModel.length; i++) {
            if (buttonModel[i].name().includes("Gamepad")) {
            var buttonValue = buttonModel[i].key.toString(16)
            return buttonValue.substring(buttonValue.length-1, buttonValue.length);
            }
        }
    }
    
}