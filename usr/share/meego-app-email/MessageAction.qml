/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1
import MeeGo.App.Email 0.1

Item {

    // The toolbar icon must have two forms in the theme such as "foo" and "foo-active".
    property alias iconName: actionButton.iconName

    // The action strategy to be executed polymorphically.
    property QtObject action: null

    height: parent.height
    width: childrenRect.width

    ToolbarButton {
        id: actionButton
        anchors.left: parent.left
        anchors.top: parent.top

        onClicked: {
            // Execute the action strategy.
            action.run()
        }
    }

    Text {
        anchors.left: actionButton.right
        anchors.verticalCenter: parent.verticalCenter
        id: numSelectedMessagesLabel
        color: "white"
        //: Arg 1 is the number of selected messages
        text: qsTr("(%1)").arg(folderListContainer.numOfSelectedMessages)
    }

    Image {
        id: separator
        anchors.left: numSelectedMessagesLabel.right
        anchors.leftMargin: 15
        anchors.top: parent.top
        height: parent.height
        source: "image://theme/email/div"
    }
}
