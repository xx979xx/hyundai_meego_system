/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1

Item {
    id: container

    property alias text: label.text

    width: label.width
    height: 50

    signal clicked

    Text {
        id: label
        font.pixelSize: theme.fontPixelSizeLarge
        color: theme.fontColorInactive

        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            container.clicked ();
        }
    }
}
