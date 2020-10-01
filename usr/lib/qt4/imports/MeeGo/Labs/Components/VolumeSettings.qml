/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Item{
    id: main
    property bool vertical: true
    rotation:vertical? -90 : 0
    width: 100
    height: 50

    Item {
        id: container
        anchors.fill: parent

        width: parent.vertical ?  parent.width : parent.height
        height: parent.vertical ? parent.height: parent.width

        VolumeControl {
            id: volumeControl

            onVolumeChanged: {
                slider.moveSlider(value)
            }
        }


        Connections {
            target: slider
            onSliderChanged: {
                volumeControl.volume = slider.percent

            }
        }

        Slider {
            id: slider
            width: parent.vertical ?  parent.height: parent.width
            anchors.centerIn: parent
            textOverlayVertical: main.vertical
        }


    }
}
