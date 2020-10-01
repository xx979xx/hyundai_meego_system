/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1

Item {
    id: container
    width: parent.width
    height:  90

    signal openColorstripCreator()
    signal openGallery()

    Row {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20
        Button {
            id: galleryButton
            width: parent.width/2 - 20
            elideText: true
            height: parent.height * 0.75
            text: qsTr("Pick a photo")
            //color: theme_buttonFontColor
            //font.pointSize: theme_fontSizeMedium
            onClicked: {
                container.openGallery()
            }
        }
    }
}
