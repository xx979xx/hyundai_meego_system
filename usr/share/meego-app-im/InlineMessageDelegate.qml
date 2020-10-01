/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Item {
    id: inlineMessage
    width: parent.width
    height: childrenRect.height
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: 10

    property alias source : inlineMessageIcon.source
    property alias text : inlineMessageText.text

    Image {
        id: inlineMessageIcon
        anchors.right: inlineMessageText.left
        anchors.rightMargin: 20
        visible: source != ""
        height: source == "" ? 30 : null
    }

    Text {
        id: inlineMessageText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: inlineMessageIcon.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: theme_fontColorInactive
        font.pixelSize: theme_fontPixelSizeSmall
        wrapMode: Text.WordWrap
    }
}
