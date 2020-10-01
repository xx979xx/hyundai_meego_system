/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1
import "settings.js" as Settings

Rectangle {
    property alias text: label.text
    property alias value: radioButton.value
    property alias group: radioButton.group
    anchors.left: parent.left
    anchors.right: parent.right
    color: "#d5ecf6"
    height: 77

    Text {
        id: label
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 10
        font.pixelSize: theme.fontPixelSizeLarge
        color: theme.fontColorNormal
        text: Settings.textForInterval(radioButton.value)
    }

    RadioButton {
        id: radioButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 20
        group: updateInterval
    }

    //FIXME: not supported by MeeGo.Components radiobutton
    //MouseArea {
    //    anchors.fill: parent
    //    onClicked: radioButton.click(mouse)
    //}
}
