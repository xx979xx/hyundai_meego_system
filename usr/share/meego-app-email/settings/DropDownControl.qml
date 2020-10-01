/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1

Column {
    id: root
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 90
    anchors.rightMargin: 90
    property alias label: label.text
    property alias model: dropdown.model
    property alias title: dropdown.title
    property alias selectedTitle: dropdown.selectedTitle
    property alias selectedIndex: dropdown.selectedIndex

    signal triggered (int index)

    Text {
        id: label
        height: 30
        font.pixelSize: theme.fontPixelSizeLarge
        font.italic: true
        color: "grey"
    }
    DropDown {
        id: dropdown
        width: 400
        minWidth: 400
        maxWidth: 500
        titleColor: "black"
        replaceDropDownTitle: true
        onTriggered: root.triggered(index)
    }
}
