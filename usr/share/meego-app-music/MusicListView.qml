/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Media 0.1
import "functions.js" as Code
Item {
    id: container
    width: 640
    height: 480
    property alias model: listview.model
    property alias currentIndex: listview.currentIndex
    property alias count: listview.count
    property string labelUnknownArtist: qsTr("unknown artist")
    property string labelUnknownAlbum: qsTr("unknown album")
    property string labelItemCount: qsTr("%1")
    property alias interactive: listview.interactive
    property string defaultThumbnail: "image://themedimage/images/media/music_thumb_med"
    property bool selectionMode: false
    property int frameBorderWidth: 0
    property int entryHeight: 50
    property bool playqueue: false

    property int footerHeight: 50
    property bool showPlayIcon: false
    property color textColor: theme_fontColorNormal
    property int mode: 0
    property bool showNowPlayingIcon: true
    property alias titleBarHeight: titleBar.height
    property bool selectbyindex: false

    signal clicked(real mouseX, real mouseY, variant payload, int index)
    signal longPressAndHold(real mouseX, real mouseY, variant payload, int index)
    signal doubleClicked(real mouseX, real mouseY, variant payload, int index)

    Image {
        id: titleBar
        source: "image://themedimage/images/media/subtitle_landscape_bar"
        anchors.top:parent.top
        anchors.left:parent.left
        width: parent.width
        Text {
            id: nameLabel
            text:{
                if (mode == 1)
                    return qsTr("Playlist name");
                else if (mode == 2)
                    return qsTr("Artist name");
                else if (mode == 3)
                    return qsTr("Album name");
                return qsTr("Track name");
            }
            color:theme_fontColorHighlight
            font.pixelSize: theme_fontPixelSizeLarge
            anchors.left: parent.left
            anchors.leftMargin: entryHeight + 8
            width: parent.width* (mode !=0? 0.5: 0.35)
            height: parent.height
            horizontalAlignment:Text.Left
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        Text {
            id: artistLabel
            text: qsTr("Artist")
            color:theme_fontColorHighlight
            font.pixelSize: theme_fontPixelSizeLarge
            anchors.left: nameLabel.right
            width: parent.width*0.2
            height: parent.height
            horizontalAlignment:Text.Left
            verticalAlignment: Text.AlignVCenter
            visible: mode == 0
            elide: Text.ElideRight
        }

        Text {
            id: durationLabel
            text: qsTr("Time")
            color:theme_fontColorHighlight
            font.pixelSize: theme_fontPixelSizeLarge
            anchors.left: artistLabel.right
            width: parent.width*0.1
            height: parent.height
            horizontalAlignment:Text.Left
            verticalAlignment: Text.AlignVCenter
            visible: mode == 0
            elide: Text.ElideRight
        }

        Text {
            id: albumLabel
            text: qsTr("Album")
            color:theme_fontColorHighlight
            font.pixelSize: theme_fontPixelSizeLarge
            anchors.left: durationLabel.right
            width: parent.width*0.3
            height: parent.height
            horizontalAlignment:Text.Left
            verticalAlignment: Text.AlignVCenter
            visible: mode == 0
            elide: Text.ElideRight
        }
        Text {
            id: countLabel
            text: qsTr("Number of tracks")
            color:theme_fontColorHighlight
            font.pixelSize: theme_fontPixelSizeLarge
            anchors.left: nameLabel.right
            width: parent.width*0.2
            height: parent.height
            horizontalAlignment:Text.Left
            verticalAlignment: Text.AlignVCenter
            visible: mode != 0
            elide: Text.ElideRight
        }

    }
    ListView {
        id: listview
        anchors.top: titleBar.bottom
        width: parent.width
        height: parent.height - titleBar.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        highlightMoveSpeed: 1000
        highlightRangeMode: (playqueue)?(ListView.StrictlyEnforceRange):(ListView.NoHighlightRange)
        footer: Item{
            width: listview.width
            height: container.footerHeight
        }
        delegate:  BorderImage {
            id: dinstance
            width: parent.width
            height: entryHeight
            border.left: 5; border.top: 5
            border.right: 5; border.bottom: 5
            source: {
                if ((listview.model.playindex == index)&&(listview.model.playstatus == MusicListModel.Playing)) {
                    return "image://themedimage/images/media/music_row_highlight_landscape";
                }else if ((index%2) == 0) {
                    return "image://themedimage/images/media/music_row_landscape";
                }else {
                    return "image://themedimage/images/media/music_row_whtie_landscape";
                }

                return "";
            }

            property string mtitle
            mtitle:{
                try
                {
                    return title;
                }
                catch(err)
                {
                    return "";
                }
            }
            property string mthumburi
            mthumburi:{
                try
                {
                    if (thumburi == "" | thumburi == undefined)
                        return defaultThumbnail;
                    else
                        return thumburi;
                }
                catch(err)
                {
                    return defaultThumbnail
                }
            }
            property string mitemid
            mitemid:{
                try
                {
                    return itemid;
                }
                catch(err)
                {
                    return "";
                }
            }
            property int mitemtype
            mitemtype:{
                try
                {
                    return itemtype;
                }
                catch(err)
                {
                    return -1;
                }
            }
            property bool mfavorite
            mfavorite: {
                try
                {
                    return favorite;
                }
                catch(err)
                {
                    return false;
                }
            }
            property int mcount
            mcount: {
                try
                {
                    return tracknum;
                }
                catch(err)
                {
                    return 0;
                }
            }
            property string martist
            martist: {
                var a;
                try
                {
                    a = artist ;
                }
                catch(err)
                {
                    a = "";
                }
                a[0]== undefined ? "":a[0];
            }
            property string malbum:album
            property string muri: uri
            property string murn: urn
            property int mlength: length
            Image {
                id: rect
                width: height
                height: parent.height -2
                clip:true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                fillMode: Image.PreserveAspectCrop
                source:mthumburi

                Rectangle {
                    id: fog
                    anchors.fill: parent
                    color: "white"
                    opacity: 0.25
                    visible: false
                }
            }
            Image {
                id: playingIcon
                source: "image://themedimage/images/media/icn_currentlyplaying-albumoverlay"
                fillMode:Image.PreserveAspectFit
                width:height
                height:parent.height -2
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                visible: showNowPlayingIcon && ((listview.model.playindex == index)&&(listview.model.playstatus == MusicListModel.Playing))
            }
            BorderImage {
                id: frame
                parent: rect
                anchors.centerIn: parent
                width: parent.width - 2 * frameBorderWidth
                height: parent.height - 2 * frameBorderWidth
                smooth: true
                z: 2
            }

            Text {
                id: titleText
                height: parent.height
                width:parent.width*(mode != 0? 0.5: 0.35)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:Text.AlignLeft
                anchors.left: rect.right
                anchors.leftMargin:10
                elide: Text.ElideRight
                text: title
                font.bold: true
                color:textColor
                font.pixelSize: theme_fontPixelSizeLarge
            }

            Text {
                id:trackArtist
                text: {
                    artist[0] == undefined? labelUnknownArtist:artist[0];
                }
                height: parent.height
                width: parent.width * 0.2
                anchors.left: titleText.right
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:Text.AlignLeft
                elide: Text.ElideRight
                color:textColor
                visible: mode == 0
                font.pixelSize: theme_fontPixelSizeLarge
            }

            Text {
                id:trackLength
                text: Code.formatTime(length)
                height: parent.height
                width: parent.width*0.1
                anchors.left: trackArtist.right
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:Text.AlignLeft
                elide: Text.ElideRight
                color:textColor
                visible: mode == 0
                font.pixelSize: theme_fontPixelSizeLarge
            }
            Text {
                id:trackAlbum
                text: {
                    album == ""?labelUnknownAlbum: album;
                }
                height: parent.height
                width: parent.width*0.3
                anchors.left: trackLength.right
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:Text.AlignLeft
                elide: Text.ElideRight
                color:textColor
                visible: mode == 0
                font.pixelSize: theme_fontPixelSizeLarge
            }

            Text {
                id:numberOfTracks
                text:labelItemCount.arg(mcount)
                height: parent.height
                width: parent.width * 0.4
                anchors.left: titleText.right
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:Text.AlignLeft
                elide: Text.ElideRight
                color:textColor
                visible: mode != 0
                font.pixelSize: theme_fontPixelSizeLarge
            }

            MouseArea {
                id: mouseArea
                anchors.fill:parent
                onClicked: {
                    container.clicked(mouseX, mouseY, dinstance, index);
                }
                onPressAndHold:{
                    container.longPressAndHold(mouseX, mouseY, dinstance, index);
                }
                onDoubleClicked: {
                    container.doubleClicked(mouseX, mouseY, dinstance, index);
                }
            }

            states: [
                State {
                    name: "normal"
                    when: !selectionMode && !mouseArea.pressed
                    PropertyChanges {
                        target: frame
                        source: "image://themedimage/images/media/photos_thumb_med"
                    }
                },
                State {
                    name: "feedback"
                    when: !selectionMode && mouseArea.pressed
                    PropertyChanges {
                        target: fog
                        visible: true
                    }
                },
                State {
                    name: "selectionNotSelected"
                    when: selectionMode && (selectbyindex)?(!listview.model.isSelected(index)):(!listview.model.isSelected(itemid))
                    PropertyChanges {
                        target: frame
                        source: "image://themedimage/images/media/photos_thumb_med"
                    }
                },
                State {
                    name: "selectionSelected"
                    when: selectionMode && (selectbyindex)?(listview.model.isSelected(index)):(listview.model.isSelected(itemid))
                    PropertyChanges {
                        target: frame
                        source: "image://themedimage/images/media/photos_selected_tick"
                    }
                }

            ]
        }
    }
}
