/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.App.IM 0.1

Item {
    visible: (!networkOnline)
    height: (networkOnline? 0 : 101)
    width:  parent.width

    Rectangle {
        id: container
        anchors.fill: parent

        visible: parent.visible

        BorderImage {
            id: noNetworkBorder
            source: "image://themedimage/widgets/common/infobar/bg_overlaybar"
            anchors.fill: parent
            border {
                left: 5
                top: 5
                right: 5
                bottom: 5
            }
            visible: parent.visible
        }

        Text {
            id: noNetworkText
            text: qsTr("Your device is not connected to a network. To chat with your contacts, you need to connect to a network.")
            wrapMode: Text.WordWrap
            anchors.fill: parent
            anchors.margins: 5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: theme_fontPixelSizeLarge
            color: theme_fontColorHighlight
            visible: parent.visible
        }
    }
}
