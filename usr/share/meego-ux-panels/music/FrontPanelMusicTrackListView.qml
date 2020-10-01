/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Panels 0.1
import MeeGo.Components 0.1
import MeeGo.Media 0.1

PanelColumnView {

    id: fpMusicTrackListView
    width: parent.width
    delegate: trackComponent

    property variant contextMenu


    Component {
        id: trackComponent

        Item {
            id: trackItem
            property bool isFirstItem: index == 0
            width: fpMusicTrackListView.width
            height: isFirstItem ? firstItem.height : listItem.height
            FrontPanelMusicPreviewContentItem{
                id: firstItem
                visible: isFirstItem
                imageSource: thumburi
                text: title
                description: "" + artist
            }
            TileListItem {
                id: listItem
                visible: !isFirstItem
                separatorVisible: true
                imageBackground: "item"
                imageSource: thumburi
                zoomImage: true
                text: title
                description: "" + artist
            }
            MouseArea {
                anchors.fill: parent
                onClicked:{
                    spinnerContainer.startSpinner();
                    var playCommand = "playSong";
                    if (itemtype == MediaItem.SongItem)
                        playCommand = "playSong";
                    else if (itemtype == MediaItem.MusicArtistItem)
                        playCommand = "playArtist";
                      else if (itemtype == MediaItem.MusicAlbumItem)
                          playCommand = "playAlbum";
                      else if (itemtype == MediaItem.MusicPlaylistItem)
                          playCommand = "playPlaylist";

                      appsModel.launch("/usr/bin/meego-qml-launcher --opengl --fullscreen --cmd " + playCommand + " --app meego-app-music --cdata " + urn)
                      container.notifyModel();
                }
                //For the context Menu
                onPressAndHold:{
                    var pos = trackItem.mapToItem(topItem.topItem, mouse.x, mouse.y);

                    contextMenu.currentUrn=urn;
                    contextMenu.currentUri=uri;

                    var playCommand = "playSong";
                    if (itemtype == MediaItem.SongItem)
                        playCommand = "playSong";
                    else if (itemtype == MediaItem.MusicArtistItem)
                        playCommand = "playArtist";
                    else if (itemtype == MediaItem.MusicAlbumItem)
                        playCommand = "playAlbum";
                    else if (itemtype == MediaItem.MusicPlaylistItem)
                        playCommand = "playPlaylist";

                    contextMenu.playCommand = playCommand
                    contextMenu.menuPos = pos;
                    contextMenu.setPosition(pos.x, pos.y);
                    contextMenu.show();
                }
            }
        }

    }
}
