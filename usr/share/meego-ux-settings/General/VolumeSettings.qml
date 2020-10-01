/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1 as MeeGo

Item {
    id: container
    width: parent.width
    height: childrenRect.height

    MeeGo.VolumeControl {
        id: volumeControl
        onVolumeChanged: {
            slider.value = volumeControl.volume
        }
    }

    Image {
        id: volval
        anchors.left: slider.right
        anchors.verticalCenter: slider.verticalCenter
        anchors.leftMargin: 20
        source: "image://theme/settings/icn_sound_high"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                volumeControl.volume = 100
            }
        }
    }

    Connections {
        target: slider
        onSliderChanged: {
            if(setVolumeTimer.running)
                setVolumeTimer.restart();
            else setVolumeTimer.start();
        }
    }

    Timer {
        id: setVolumeTimer
        interval: 250
        repeat:  false

        onTriggered: {
            volumeControl.volume = slider.value
            if(volumeControl.mute)
                volumeControl.mute = false;
        }
    }

    MeeGo.Slider {
        id: slider
        value: volumeControl.volume
        width: 400
        anchors.centerIn: parent
    }

    Image {
        id: volumeImage
        source: "image://theme/settings/icn_sound_low"
        anchors.right: slider.left
        anchors.verticalCenter: slider.verticalCenter

        property bool muted: volumeControl.mute

        MouseArea {
            anchors.fill: parent
            onClicked: {
                volumeControl.volume = 0
            }
        }
    }

}
