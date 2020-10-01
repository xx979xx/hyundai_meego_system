/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Panels 0.1
import MeeGo.Media 0.1

Item {
    id: fpMusicPreview
    width: parent ? parent.width : 0
    height: col.height - panelSize.contentAreaBottomMargin + 4

    property bool imagePlayStatus: false
    property bool isCurrentlyPlayingLayout: false
    property alias text: tile.text
    property alias description: tile.description
    property alias imageSource: tile.imageSource

    signal clicked(variant mouse);
    signal pressAndHold(variant mouse)

    signal backButtonClicked()
    signal playButtonClicked()
    signal forwardButtonClicked()
    Column {
        id: col
        width: parent.width
        SecondaryTile {
            id: tile
            mouseAreaActive: true
            zoomImage: true
            fallBackImage: "image://themedimage/images/media/music_thumb_med"
            imageBackground: "album"
            onClicked: {
                fpMusicPreview.clicked(mouse);
            }
            onPressAndHold: {
                fpMusicPreview.pressAndHold(mouse);
            }
        }
        MediaToolbar {
            visible: isCurrentlyPlayingLayout
            width: parent.width + 2*panelSize.contentAreaSideMargin - 4
            anchors.horizontalCenter: parent.horizontalCenter
            height: 55
            showplay: true
            showprev: true
            shownext: true
            ispause: imagePlayStatus
            onPlayPressed: fpMusicPreview.playButtonClicked();
            onPausePressed: fpMusicPreview.playButtonClicked();
            onPrevPressed: fpMusicPreview.backButtonClicked();
            onNextPressed: fpMusicPreview.forwardButtonClicked();
        }
        // Item {
        //     visible: isCurrentlyPlayingLayout
        //     width: parent.width + 2*panelSize.contentAreaSideMargin - 4
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     height: 55
        //     // Rectangle {
        //     //     width: parent.width
        //     //     height: 4
        //     //     color: "#000000"
        //     //     opacity: 0.7
        //     // }
        //     Rectangle {
        //         anchors.fill: parent
        //         radius: 4
        //         color: "#000000"
        //         opacity: 0.7
        //     }
        //     MediaToolbarButton {
        //         id: btRewind
        //         visible: true
        //         height: parent.height
        //         anchors.left: parent.left
        //         //width: parent.width/3
        //         bgSourceUp: "image://themedimage/icons/actionbar/media-backward"
        //         bgSourceDn: "image://themedimage/icons/actionbar/media-backward-active"
        //         onClicked: fpMusicPreview.backButtonClicked()
        //     }
        //     MediaToolbarButton {
        //         id: btPlay
        //         visible: true
        //         anchors.left: btRewind.right
        //         height: parent.height
        //         //width: parent.width/3
        //         bgSourceUp: ((imagePlayStatus)?"image://themedimage/icons/actionbar/media-pause":"image://themedimage/icons/actionbar/media-play")
        //         bgSourceDn: ((imagePlayStatus)?"image://themedimage/icons/actionbar/media-pause-active":"image://themedimage/icons/actionbar/media-play-active")
        //         onClicked: fpMusicPreview.playButtonClicked();
        //     }
        //     MediaToolbarButton {
        //         id: btForward
        //         visible: true
        //         anchors.left: btPlay.right
        //         height: parent.height
        //         //width: parent.width/3
        //         bgSourceUp: "image://themedimage/icons/actionbar/media-forward"
        //         bgSourceDn: "image://themedimage/icons/actionbar/media-forward-active"
        //         onClicked: fpMusicPreview.forwardButtonClicked();
        //     }
        // }
    }
}
