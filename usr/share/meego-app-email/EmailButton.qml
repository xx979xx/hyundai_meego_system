/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0

Image {
    id: container
    source: upSource

    property string upSource
    property string downSource : upSource

    signal clicked (int mouseX, int mouseY)

    MouseArea {
        anchors.fill: parent

        onPressed: {
            source = downSource
        }
        onReleased: {
            source = upSource
        }
        onClicked: {
            container.clicked (mouse.x, mouse.y);
        }
    }
}