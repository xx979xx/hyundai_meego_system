/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Image {
    id: container
    opacity: active ? 1.0 : inactiveOpacity
    source: image + "_up"
    smooth: true

    property bool pressed: false
    property bool active: true
    property string image: ""
    property string sourceDown: image != "" ? image + "_dn" : source
    property string backgroundImage: ""
    property string backgroundSource: backgroundImage != "" ? backgroundImage + "_up" : ""
    property string backgroundSourceDown: backgroundImage != "" ? backgroundImage + "_dn" : backgroundSource
    property double inactiveOpacity : 0.0
    property alias title: label.text
    property alias color: label.color
    property string icon: ""

    signal clicked()

    width: label.width + iconImage.width + 30

    BorderImage {
        id: background
        source: container.pressed ? container.backgroundSourceDown : container.backgroundSource
        opacity: container.backgroundSource == "" ? 0.0 : 1.0
        anchors.centerIn: parent
        width: parent.width
        z: parent.z - 1
        border {
            top: 5
            left: 5
            bottom: 5
            right: 5
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: if (container.active) container.clicked()
        onPressed: if (container.active) container.pressed = true
        onReleased: if (container.active) container.pressed = false
    }

    states: [
        State {
            name: "pressed"
            when: container.pressed == true
            PropertyChanges {
                target: container
                source: container.sourceDown
            }
        }
    ]

    Row {
        spacing: 5
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        Image {
            id: iconImage
            width: container.height - 10
            height: container.height - 10
            anchors.verticalCenter: parent.verticalCenter
            source: container.icon
            visible: (source != "")
        }

        Text {
            id: label
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            font.pixelSize: container.height - 15
            font.weight: Font.Bold
            visible: (text != "")
        }
    }

}
