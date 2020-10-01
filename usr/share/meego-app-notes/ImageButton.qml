/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Item {
    id: container

    property alias upSource: label.source
    property string dnSource;
    property bool pressed: false
    property bool active: true
    property alias imageScale: label.scale

    opacity: active ? 1.0 : 0.5

    signal clicked(variant mouse)

    Image {
        id: icon
        smooth: true
        anchors.fill: parent
        source:"image://theme/btn_grey_up"
        states: [
            State {
                name: "pressed"
                when: container.pressed
                PropertyChanges {
                    target: icon
                    source: "image://btn_grey_dn"
                }
            }
        ]
    }

    Image {
        id: label
        smooth: true
        anchors.fill: parent
        states: [
            State {
                name: "pressed"
                when: container.pressed
                PropertyChanges {
                    target: label
                    source: dnSource
                }
            }
        ]

    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (container.active)
                container.clicked(mouse)
        }
        onPressed: if (container.active) parent.pressed = true
        onReleased: if (container.active) parent.pressed = false
    }
}

