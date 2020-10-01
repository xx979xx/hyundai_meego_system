/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0

Column {
    property alias title: titleText.text
    property alias subtitle: subtitleText.text
    property alias children: column2.children
    anchors.left: parent.left
    anchors.right: parent.right
    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        visible: titleText.text.length > 0
        Item { width: 1; height: 30; }
        Text {
            id: titleText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            font.pixelSize: theme.fontPixelSizeLarge
            visible: text.length > 0
        }
        Item { width: 1; height: 10; }
        Text {
            id: subtitleText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            font.pixelSize: theme.fontPixelSizeMedium
            wrapMode: Text.WordWrap
            visible: text.length > 0
        }
        Item { width: 1; height: 10; }
    }
    Rectangle {
        color: "#d5ecf6"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        height: column2.height
        Column {
            id: column2
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 20
        }
    }
}
