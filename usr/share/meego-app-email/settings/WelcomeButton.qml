/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0

Rectangle {
    id: root
    property alias title: title.text
    property alias icon: icon.source

    anchors.left: parent.left
    anchors.right: parent.right
    height: 80
    color: mousearea.pressed ? "lightgrey" : "white"

    signal clicked()

    Image {
        id: icon
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.margins: 20
    }
    Text {
        id: title
        font.pixelSize: theme.fontPixelSizeLarge
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 100
    }
    Image {
        source: "image://theme/arrow-right"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 20
    }
    MouseArea {
        id: mousearea
        anchors.fill: parent
        onClicked: { root.clicked(); }
    }
}
