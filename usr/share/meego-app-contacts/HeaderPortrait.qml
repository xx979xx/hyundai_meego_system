/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

Image{
    property string etcSymbol: qsTr("#")
    id: sectionBackground
    source: "image://theme/contacts/contact_title_bg_p"
    Text {
        id: headerTitle
        text: (section ? section.toUpperCase() : etcSymbol)
        anchors.verticalCenter: sectionBackground.verticalCenter
        anchors.left: sectionBackground.left
        anchors.leftMargin: 30
        font.pixelSize: theme_fontPixelSizeLargest
        color: theme_fontColorNormal; smooth: true
    }
}

