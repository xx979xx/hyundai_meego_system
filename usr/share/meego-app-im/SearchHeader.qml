/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.App.IM 0.1

Item {
    id: searchHader
    visible: searchActive
    height: (searchActive ? 101 : 0)
    width:  parent.width

    signal olderClicked(variant mouse)
    signal newerClicked(variant mouse)

    property bool searchActive : true
    property int numMatchesFound : 0
    property alias searching : loadingIcon.spinning
    property bool olderActive : false
    property bool newerActive : false

    Rectangle {
        id: container
        anchors.fill: parent
        visible: parent.visible

        BorderImage {
            id: searchHeaderBorder
            source: "image://themedimage/widgets/common/infobar/bg_overlaybar"
            anchors.fill: parent
            border {
                left: 5
                top: 5
                right: 5
                bottom: 5
            }
            visible: parent.visible
        }

        Text {
            id: searchText
            text: qsTr("%1 matches found").arg(numMatchesFound)
            wrapMode: Text.WordWrap
            anchors.margins: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: theme_fontPixelSizeLarge
            color: theme_fontColorHighlight
            visible: parent.visible
        }

        Item {
            anchors.verticalCenter: searchText.verticalCenter
            anchors.left: searchText.right
            anchors.leftMargin: 15
            Spinner {
                id: loadingIcon
                width: theme_fontPixelSizeLarge
                height: theme_fontPixelSizeLarge
                spinning: true
            }
        }

        Button {
            id: olderButton
            text: qsTr("Older")
            width: 180
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: newerButton.left
            anchors.margins: 10
            active: olderActive
            onClicked: {
                searchHader.olderClicked(mouse);
            }
        }
        Button {
            id: newerButton
            text: qsTr("Newer")
            width: 180
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.margins: 10
            active: newerActive
            onClicked: {
                searchHader.newerClicked(mouse);
            }
        }
    }
}
