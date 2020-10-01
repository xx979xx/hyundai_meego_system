/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Item{
    id: button
    visible: false
    width: (visible)?((image.height*1.4)+divider.width):0
    height: (visible)?(image.height):0
    property string bgSourceUp:""
    property string bgSourceUpToggled:""
    property string bgSourceDn:""
    property bool toggled: false
    property int iwidth: (image.height*1.4)+divider.width
    property alias iheight: image.height

    signal clicked(real mouseX, real mouseY)
    clip:true

    Image{
        id: image
        source: (toggled)?bgSourceUpToggled:bgSourceUp
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectCrop
    }

    Image{
        id: toggledBackground
        z: -1
        visible: toggled
        anchors.fill: parent
        source: "image://themedimage/widgets/common/menu/menu-item-selected"
        fillMode: Image.PreserveAspectCrop
    }

    Image{
        id: activeBackground
        z: -1
        visible: false
        anchors.fill: parent
        source: "image://themedimage/widgets/common/menu/menu-item-active"
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle{
        id: divider
        anchors.right: parent.right
        height: parent.height
        width: 1
        // TODO themeing
        color: "#454646"
        opacity: 1
    }

    states: [
        State {
            name:"pressed"
            when:mouseArea.pressed && mouseArea.containsMouse
            PropertyChanges {
                target: image
                source: bgSourceDn
            }
            PropertyChanges {
                target: activeBackground
                visible: true
            }
        }
    ]

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            button.clicked(mouseX, mouseY)
        }
    }
}
