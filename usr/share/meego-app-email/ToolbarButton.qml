/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0

Item {
    id: container

    property string iconName: ""
    property alias rotating: imageRotation.running
    width: buttonBackground.width
    height: buttonBackground.height

    state: "up"

    signal clicked

    BorderImage {
        id: buttonBackground
        anchors.centerIn: parent
        source: "image://themedimage/widgets/common/action-item/action-item-background-active"
        opacity: (container.state == "up") ? 0 : 1
    }

    Image {
        id: image
        anchors.centerIn: parent

        source: "image://themedimage/icons/actionbar/" + iconName + ((container.state == "up") ? "" : "-active")
        NumberAnimation on rotation {
            id: imageRotation
            running: false
            from: 0; to: 360
            loops: Animation.Infinite;
            duration: 2400
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            container.state = "dn"
        }
        onReleased: {
            container.state = "up"
        }

        onClicked: {
            container.clicked ();
        }
    }

    states: [
        State {
            name: "dn"
        },
        State {
            name: "up"
        }
    ]
}
