/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Media 0.1

Item {
    id: noContentElement

    property alias text: noContentLabel.text
    property alias buttonText: actionButton.text

    signal clicked()

    width: childrenRect.width
    height: childrenRect.height

    Text {
        id: noContentLabel
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        id: actionButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: noContentLabel.bottom
        anchors.margins: 10

        onClicked: noContentElement.clicked()
    }
}
