/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Item {
    id: noContents
    property int noContentSpacing: 10
    property alias notification: notificationContent.children
    property alias help: helpContent.children
    property bool isLandscape: (window.inLandscape || window.inInvertedLandscape)
    property int bottomMargin: 0
    anchors.fill: parent
    //TODO check margins
    anchors.margins: 20
    anchors.bottomMargin: anchors.margins + bottomMargin
    Column {
        id: col
        width: parent.width
        Loader {
            width: parent.width
            sourceComponent: separator
        }
        Item {
            id: notificationContent
            //TODO check margins
            width: parent.width - 2*10
            height: childrenRect.height
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Loader {
            width: parent.width
            sourceComponent: separator
        }
        Item {
            id: helpContent
            //TODO check margins
            width: parent.width
            height: noContents.height - 2*20 - notificationContent.height
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    Component {
        id: separator
        Item {
            width: parent.width
            // TODO check margin
            height: 20
            Image {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                // TODO this probably is not correct separator
                source: "image://themedimage/images/dialog-separator"
            }
        }
    }
}
