/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Media 0.1 as Media

Item {
    id: container

    property int labelHeight: 20
    property color cellBackgroundColor: "black"
    property color cellTextColor: theme_fontColorHighlight
    property int cellTextPointSize: theme_fontPixelSizeNormal

    property alias model: view.model
    property alias currentItem: view.currentItem
    property alias view: view
    property alias currentIndex: view.currentIndex
    property alias noContentText: noContent.text
    property alias noContentButtonText: noContent.buttonText
    property alias noContentVisible: view.visible

    property string labelOpen: qsTr("Open")
    property string labelPlay: qsTr("Play slideshow")
    property string labelShare: qsTr("Share")
    property string labelDelete: qsTr("Delete")

    signal openAlbum(variant elementid, string title, bool isvirtual, bool fullscreen)
    signal playSlideshow(variant elementid, string title)
    signal shareAlbum(variant albumid, string title, int mouseX, int mouseY)
    signal noContentAction()

    function indexAt(x,y) {
        return view.indexAt(x,y);
    }

    ConfirmDelete {
        id: confirmer
        model: container.model

        onConfirmed: {
            allPhotosModel.clearSelected()
        }
    }

    ContextMenu {
        id: albumsContextMenu
        property alias payload: albumsActionMenu.payload
        property alias model: albumsActionMenu.model
        property int mouseX
        property int mouseY

        content: ActionMenu {
            id: albumsActionMenu
            property variant payload: undefined
            onTriggered: {
                var target = container.anchors
                if (model[index] == labelOpen) {
                    // Open the photo
                    openAlbum(payload.mitemid, payload.mtitle, payload.misvirtual, false)
                }
                else if (model[index] == labelPlay) {
                    // TODO: this is currently disabled below
                    // Play slideshow
                    playSlideshow(payload.mitemid, payload.mtitle)
                }
                else if (model[index] == labelShare) {
                    // Share
                    shareAlbum(payload.mitemid, payload.mtitle,
                               albumsContextMenu.mouseX, albumsContextMenu.mouseY)
                }
                else if (model[index] == labelDelete) {
                    // Delete
                    confirmer.text = labelDeleteAlbumText
                    confirmer.items = [ payload.mitemid ]
                    confirmer.show()
                }
                albumsContextMenu.hide()
            }
        }
    }

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
        visible: count != 0

        type: photoalbumtype
        defaultThumbnail: "image://themedimage/images/media/photo_thumb_default"
        showHeader: true

        onClicked: {
            view.currentIndex = payload.mindex;
            openAlbum(payload.mitemid, payload.mtitle, payload.misvirtual, false);
        }

        onLongPressAndHold: {
            var map = payload.mapToItem(topItem.topItem, mouseX, mouseY);

            // TODO: implement this play slideshow feature here, a little tricky
            //   Nick wants it to slide just the one page in, but later you
            //     go _back_ to the album detail view
            var options = [labelOpen, labelShare]   // labelPlay removed for now

            // only add delete option if the album is not virtual
            if (!payload.misvirtual) {
                options.push(labelDelete)
            }

            albumsContextMenu.model = options
            albumsContextMenu.payload = payload;
            albumsContextMenu.mouseX = map.x
            albumsContextMenu.mouseY = map.y
            albumsContextMenu.setPosition(map.x, map.y)
            albumsContextMenu.show()
        }
    }
}
