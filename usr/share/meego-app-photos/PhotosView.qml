/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Media 0.1 as Media

Item {
    id: container

    property color cellBackgroundColor: selectionMode ? "#5f5f5f" : "black"
    property color cellTextColor: "white"

    property bool selectionMode: false
    property bool modelConnectionReady: false

    property bool selectAll: false
    property variant selected: []
    property variant thumburis: []

    property alias model: view.model
    property alias currentItem: view.currentItem
    property alias currentIndex: view.currentIndex
    property alias noContentText: noContent.text
    property alias noContentButtonText: noContent.buttonText
    property alias noContentVisible: view.visible

    property alias footerHeight: view.footerHeight

    property string labelOpen: qsTr("Open")
    property string labelPlay: qsTr("Play slideshow")
    property string labelShare: qsTr("Share")
    property string labelFavorite: qsTr("Favorite");
    property string labelUnfavorite: qsTr("Unfavorite");
    property string labelAddToAlbum: qsTr("Add to album");
    property string labelDelete: qsTr("Delete")
    property string labelMultiSelMode: qsTr("Select multiple photos")

    signal toggleSelectedPhoto(string uri, bool selected)
    signal noContentAction()

    onSelectionModeChanged: {
        selected = [];
        thumburis = [];
        model.clearSelected();
    }

    signal openPhoto(variant mediaItem, bool fullscreen, bool startSlideshow)
    signal pressAndHold(int x, int y, variant payload)

    Rectangle {
        id: globalbgsolid
        anchors.fill: parent
        color: "black"
    }

    BorderImage {
        id: panel
        anchors.fill: parent
        anchors.topMargin: 8
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.bottomMargin: 5
        source: "image://themedimage/widgets/apps/media/content-background"
        border.left:   8
        border.top:    8
        border.bottom: 8
        border.right:  8
    }

    NoContent {
        id: noContent

        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        visible: !view.visible

        onClicked: {
            container.noContentAction();
        }
    }

    Media.MediaGridView {
        id: view

        anchors.fill: parent
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: (parent.width - Math.floor(parent.width / 110)*110) / 2
        anchors.rightMargin: anchors.leftMargin

        visible: count != 0 || !modelConnectionReady

        type: phototype
        selectionMode: container.selectionMode
        defaultThumbnail: "image://themedimage/images/media/photo_thumb_default"
        showHeader: true

        borderImageSource: "image://themedimage/widgets/apps/media/photo-border"
        borderImageTop: 3
        borderImageBottom: borderImageTop
        borderImageLeft: borderImageTop
        borderImageRight: borderImageTop

        onClicked: {
            if (container.selectionMode) {
                view.currentIndex = payload.mindex;
                var itemSelected = !view.model.isSelected(payload.mitemid)
                view.model.setSelected(payload.mitemid, itemSelected);
                container.toggleSelectedPhoto(payload.muri, itemSelected)
                selected = view.model.getSelectedIDs();
                thumburis = view.model.getSelectedURIs();
            }
            else {
                container.openPhoto(payload, false, false);
            }
        }

        onLongPressAndHold: {
            if (!container.selectionMode) {
                container.pressAndHold(mouseX, mouseY, payload);
            }
        }
    }
}

