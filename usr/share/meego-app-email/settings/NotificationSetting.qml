/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1

Rectangle {
    id: root
    property alias text: label.text
    property alias on: toggle.on

    signal onChanged

    anchors.left: parent.left
    anchors.right: parent.right
    height: 77
    color: "#d5ecf6"

    Theme {
        id: theme
    }

    Text {
        id: label
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 10
        font.pixelSize: theme.fontPixelSizeLarge
    }

    ToggleButton {
        id: toggle
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 10
        onOnChanged: root.onChanged()
    }
}
