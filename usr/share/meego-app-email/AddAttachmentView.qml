/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1

Item {
    id: addAttachmentPageContainer

    parent: addAttachmentPage
    width: parent.width
    height: parent.height

    property ListModel attachments

    function pickerCancelled () {
        console.log ("Cancelled picker");
    }

    function pickerSelected (uri) {
        console.log (uri + " selected");

        attachments.append ({"uri": uri});
    }

    function addPicker (pickerComponent) {
        var picker = pickerComponent.createObject (addAttachmentPageContainer);
        picker.show ();
        picker.rejected.connect (pickerCancelled);
    }

    Rectangle {
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: toolbar.top
        color: "lightgrey"

        Column {
            spacing: 5
            width: parent.width

//            AttachmentPicker {
//                pickerComponent: documentPicker
//                pickerLabel: qsTr("Documents")
//                pickerImage: "image://theme/panels/pnl_icn_documents"
//            }

            AttachmentPicker {
                pickerComponent: photoPicker
                pickerLabel: qsTr("Photos")
                pickerImage: "image://theme/panels/pnl_icn_photos"
            }

            AttachmentPicker {
                pickerComponent: moviePicker
                pickerLabel: qsTr("Movies")
                pickerImage: "image://theme/panels/pnl_icn_video"
            }

            AttachmentPicker {
                pickerComponent: musicPicker
                pickerLabel: qsTr("Music")
                pickerImage: "image://theme/panels/pnl_icn_music"
            }
        }
    }

    AddAttachmentToolbar {
        id: toolbar
        width: parent.width
        anchors.bottom: parent.bottom

        onOkay: {
            window.popPage ();
        }
    }

//    Component {
//        id: documentPicker
//        Rectangle {
//            anchors.fill: parent
//            color: "pink"
//        }
//    }

    Component {
        id: musicPicker
        MusicPicker {
            //anchors.fill: parent

            showPlaylists: false
            showAlbums: false
            selectSongs: true

            onSongSelected: {
                console.log ("Song: " + title);
                pickerSelected(uri);
            }
        }
    }

    Component {
        id: photoPicker
        PhotoPicker {
            //anchors.fill: parent

            onPhotoSelected: {
                console.log ("Photo: " + uri);
                pickerSelected(uri);
            }
        }
    }

    Component {
        id: moviePicker
        VideoPicker {
            //anchors.fill: parent

            onVideoSelected: {
                console.log ("Video: " + uri);
                pickerSelected(uri);
            }
        }
    }
}
