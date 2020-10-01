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
    property int volumeControlXmid: 0
    property int volumeControlBottomMargin: 0

    property alias controllerWidth: volumeControlItem.width
    property alias controllerHeight: volumeControlItem.height

    property variant volumeControl
    property alias closeTimer: volumeTimer
    property int volumeHeight: 300

    Timer {
        id: volumeTimer
        interval: 2000
        repeat: false
        onTriggered: {
            container.close();
        }
    }

    function setVolume(volume)
    {
        volumeTimer.interval = 500;
        volumeTimer.restart();
        if (volumeControl && volumeControl.volume != volume){
            muteVolume(false) ;
            volumeControl.volume = volume;
        }
    }

    function muteVolume(muted) {
        volumeTimer.interval = 500;
        volumeTimer.restart();
        if (volumeControl.mute != muted)
            volumeControl.mute = muted;
    }

    function maximizeVolume()
    {
        volumeTimer.interval = 500;
        volumeTimer.restart();
        muteVolume(false);
        setVolume(100);
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
        width: 80
        height: volumeHeight
        x: volumeControlXmid - width/2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: volumeControlBottomMargin
        source: "image://theme/volume_panel_bg"

        MouseArea {
            anchors.fill: parent
        }
        Image {
            id: maxVolumeBt
            source: "image://theme/icn_volume_max"
            anchors.top:parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill:parent
                onClicked: {
                    maximizeVolume();
                }
            }
        }

        Image {
            id: volumeBar
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: maxVolumeBt.bottom
            anchors.topMargin: 10
            anchors.bottom: muteBt.top
            anchors.bottomMargin: 10
            height: 0
            opacity: 0
            source: "image://theme/volumehead_bg"
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
                source: "image://theme/volumehead_track_3"
                anchors.horizontalCenter: parent.horizontalCenter
                y: {
                    if (volumeControl)
                        (1- volumeControl.volume/100) * (volumeBar.height - volumeSlider.height)
                        else
                            volumeBar.height - height;
                }
            }
            Image {
                id: volumeBody
                source: "image://theme/volumehead_track_2"
                anchors.top: volumeSlider.bottom
                anchors.bottom: volumeHead.top
                anchors.horizontalCenter:volumeBar.horizontalCenter
                z:1
            }
            Image {
                id: volumeHead
                source: "image://theme/volumehead_track_1"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter:volumeBar.horizontalCenter
                z:1
            }

            MouseArea {
                anchors.top:parent.top
                anchors.horizontalCenter:parent.horizontalCenter
                height:parent.height
                width:40
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
            source: "image://theme/icn_volume_min"
            anchors.bottom:parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill:parent
                onClicked: {
                    muteVolume(true);
                    setVolume(0);
                }
            }
        }

        SequentialAnimation {
            running: true
            PropertyAnimation  {
                target:volumeControlItem
                property: "height"
                from: 0
                to: volumeHeight
                duration: 300
            }
            PropertyAnimation {
                target:volumeBar
                property:"opacity"
                from: 0
                to:1
                duration:200
            }
        }
    }
}


