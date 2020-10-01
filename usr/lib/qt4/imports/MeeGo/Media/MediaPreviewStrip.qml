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
    height: itemHeight
    property int itemHeight: 75
    property int itemWidth: 100
    property int itemSpacing: 2
    property int hideTime: 3000
    property bool showText: true
    property alias currentIndex: previewStrip.currentIndex
    property alias currentItem: previewStrip.currentItem
    property alias model: previewStrip.model
    property alias count: previewStrip.count
    signal clicked(variant payload);

    function show(disabletimer)
    {
        previewStrip.show = true;
        if(disabletimer)
            hideTimer.stop();
        else
            hideTimer.restart();
    }

    function hide()
    {
        previewStrip.show = false;
    }

    Timer {
        id: hideTimer;
        interval: hideTime; running: false; repeat: false
        onTriggered: {
           previewStrip.show = false;
        }
    }

    ListView {
        id: previewStrip

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - ((itemWidth + itemSpacing) * count))/2
        width: parent.width
        orientation: ListView.Horizontal
        height: itemHeight
        boundsBehavior: Flickable.StopAtBounds

        focus: true
        clip: true
        property bool show: false
        spacing: itemSpacing
        opacity: 0
        highlightMoveDuration: 200

        delegate:Rectangle {
            id: dinstance
            width: itemWidth;
            height: itemHeight;
            color:"black"
            property int mindex: index
            property string mtitle
            property string muri: uri
            mtitle:{
                title == undefined? "":title
            }
            property string mthumburi
            mthumburi:{
                thumburi == undefined? "":thumburi
            }
            property string mitemid
            mitemid:{
                itemid == undefined ? "":itemid
            }
            property int mitemtype
            mitemtype:{
                itemtype == undefined? -1: itemtype
            }
            property bool mfavorite
            mfavorite: {
                favorite == undefined? false: favorite;
            }

            Rectangle {
                anchors.fill: parent;
                color: "transparent"
                border.color: dinstance.ListView.isCurrentItem?"white":"transparent"
                border.width:2
                z: 10
            }

            Image {
                id: thumnail
                anchors.centerIn: parent
                height: parent.height
                width: parent.width
                fillMode:Image.PreserveAspectFit
                source:thumburi

                Text {
                    id: thumbtext
                    anchors.fill: parent
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    text: title
                    font.pixelSize: theme_fontPixelSizeSmall
                    color: "white"
                    width: parent.width - 5
                    visible: showText
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    hideTimer.restart();
                    detailItem.videoThumbList.currentIndex = index;
                    container.clicked(dinstance);
                }
            }
        }

        onFlickStarted: {
            if(hideTimer.running)
                hideTimer.restart();
        }

        states: [
            State {
                name: "showThumbnail"
                when: previewStrip.show == true
                PropertyChanges {
                    target: previewStrip
                    opacity: 1.0
                }
            },
            State {
                name: "hideThumbnail"
                when: previewStrip.show == false
                PropertyChanges {
                    target: previewStrip
                    opacity: 0
                }
            }
        ]

        transitions: [
            Transition {
                to: "hideThumbnail"
                PropertyAnimation {
                    property:"opacity"
                    duration: 400
                }
            },
            Transition {
                to: "showThumbnail"
                PropertyAnimation {
                    property:"opacity"
                    duration: 400
                }
            }
        ]
    }
}
