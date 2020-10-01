/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.App.IM 0.1

Row {
    id: container
    property bool active: true
    anchors.fill: parent

    property variant avatarList
    Repeater {

        model: avatarList

        height: parent.height

        Avatar {
            active: container.active
            source: modelData
            anchors.top:  parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 3
        }
    }
}
