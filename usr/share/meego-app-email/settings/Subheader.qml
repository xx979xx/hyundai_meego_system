/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0

Item {
    property alias text: label.text
    anchors.left: parent.left
    anchors.right: parent.right
    height: 60

    Text {
        id: label
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pixelSize: theme.fontPixelSizeLarge
        color: theme.fontColorNormal
        height: parent.height
        width: parent.width
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
}
