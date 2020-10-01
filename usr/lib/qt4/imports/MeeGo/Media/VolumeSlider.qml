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
    anchors.fill:parent

    signal close();
    property alias volumeControlX: volumeControlItem.x
    property alias volumeControlY: volumeControlItem.y

    property alias controllerWidth: volumeControlItem.width
    property alias controllerHeight: volumeControlItem.height
    property variant volumeControl

    property alias closeTimer: volumeTimer
    property int volumeHeight: 300
    property int volumeWidth: 80

    Timer {
        id: volumeTimer
        interval: 3000
        repeat: false
        onTriggered: {
            container.close();
        }
    }

    function setVolume(volume)
    {
        volumeTimer.interval = 3000;
        volumeTimer.restart();
        if (volumeControl && volumeControl.volume != volume){
            volumeControl.volume = volume;
        }
        if(volume > 0)
            volumeControl.mute = false;
    }

    Item {
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            onClicked: {
                volumeTimer.stop();
                container.close();
            }
        }
    }

    Image {
        id: volumeControlItem
        width: volumeWidth
        height: volumeHeight
        source: "image://themedimage/images/volume_panel_bg"
        opacity: 0

        MouseArea {
            anchors.fill: parent
        }
        Image {
            id: maxVolumeBt
            source: "image://themedimage/icons/actionbar/media-volume-max"
            anchors.top:parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill:parent
                onClicked: {
                    setVolume(100);
                }
            }
        }

        Image {
            id: volumeBar
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: maxVolumeBt.bottom
            anchors.bottom: muteBt.top
            height: parent.height
            source: "image://themedimage/images/volumehead_bg"
            function mapFromPosToVolume(mouseY) {
                var pos = volumeBar.height -mouseY;
                pos = pos < volumeSlider.height? volumeSlider.height: pos;
                pos = pos > volumeBar.height ? volumeBar.height: pos;

                // revert Y coordinate agian to screen coordinate
                pos = volumeBar.height - pos;

                var volume =  (volumeBar.height - volumeSlider.height - pos)/(volumeBar.height - volumeSlider.height);
                if (volume < 0) {
                    volume = 0;
                }
                if (volume > 1) {
                    volume = 1;
                }
                return Math.floor(volume*100);
            }

            Image {
                id: volumeSlider
                source: "image://themedimage/images/scrub_head_sm"
                anchors.horizontalCenter: parent.horizontalCenter
                y: {
                    if (volumeControl)
                        (1- volumeControl.volume/100) * (volumeBar.height - volumeSlider.height);
                    else
                        volumeBar.height - height;
                }
                z:2
            }
            Image {
                id: volumeBody
                source: "image://themedimage/images/volumehead_track_2"
                anchors.top: volumeSlider.verticalCenter
                anchors.bottom: volumeHead.top
                anchors.horizontalCenter:volumeBar.horizontalCenter
                z:1
            }
            Image {
                id: volumeHead
                source: "image://themedimage/images/volumehead_track_1"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter:volumeBar.horizontalCenter
                z:1
            }

            MouseArea {
                anchors.top:parent.top
                anchors.horizontalCenter:parent.horizontalCenter
                height:parent.height
                width:volumeWidth
                onPressed: {
                    setVolume(volumeBar.mapFromPosToVolume(mouseY));
                }
                onPositionChanged: {
                    setVolume(volumeBar.mapFromPosToVolume(mouseY));
                }
            }
        }

        Image {
            id: muteBt
            source: "image://themedimage/icons/actionbar/media-volume-mute"
            anchors.bottom:parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill:parent
                onClicked: {
                    setVolume(0);
                }
            }
        }

        SequentialAnimation {
            running: true
            PropertyAnimation {
                target:volumeControlItem
                property:"opacity"
                from: 0
                to:1
                duration:200
            }
        }
    }
}


