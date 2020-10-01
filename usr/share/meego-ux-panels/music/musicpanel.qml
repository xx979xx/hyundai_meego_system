/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Panels 0.1
import MeeGo.Sharing 0.1
import MeeGo.Media 0.1
import MeeGo.Components 0.1

FlipPanel {
    id: container

    Translator {
        catalog: "meego-ux-panels-music"
    }

    //Because we do not have a universal launcher
    //Need to modify model that this app is launched
    function notifyModel()
    {
        appsModel.favorites.append(privateData.musicDesktop)
    }
    Item {
        id: privateData
        property string musicDesktop: "/usr/share/meego-ux-appgrid/applications/meego-app-music.desktop"
    }


    ListModel{
        id: backSettingsModel

        ListElement {
            //i18n OK, as it gets properly set in the Component.onCompleted - long drama why this is necessary - limitation in QML translation capabilities
            settingsTitle: "Recently played"
            custPropName: "RecentlyPlayed"
            isVisible: true
        }
        ListElement {
            //i18n OK, as it gets properly set in the Component.onCompleted - long drama why this is necessary - limitation in QML translation capabilities
            settingsTitle: "Coming up in play queue"
            custPropName: "PlayQueue"
            isVisible: true
        }
        ListElement {
            //i18n OK, as it gets properly set in the Component.onCompleted - long drama why this is necessary - limitation in QML translation capabilities
            settingsTitle: "Playlists"
            custPropName: "Playlists"
            isVisible: true
        }

        //Get around i18n issues w/ the qsTr of the strings being in a different file
        Component.onCompleted: {
            backSettingsModel.setProperty(0, "settingsTitle", qsTr("Recently played"));
            backSettingsModel.setProperty(1, "settingsTitle", qsTr("Coming up in play queue"));
            backSettingsModel.setProperty(2, "settingsTitle", qsTr("Playlists"));
        }
    }



    MusicListModel {
        id: musicRecentsModel
        type:MusicListModel.ListofRecentlyPlayed
        limit: 2
        sort: MusicListModel.SortByDefault
        Component.onCompleted: {
            hideItemsByURN(panelObj.HiddenItems)
        }
    }

    onPanelObjChanged: {
        playlistsModel.hideItemsByURN(panelObj.HiddenItems);
        musicRecentsModel.hideItemsByURN(panelObj.HiddenItems);
    }



    MusicListModel {
        id: playlistsModel
        type:MusicListModel.ListofPlaylists
        limit: 0
        sort: MusicListModel.SortByDefault
        Component.onCompleted: {
            hideItemsByURN(panelObj.HiddenItems)
        }
    }



    front: Panel {
        panelTitle: qsTr("Music")
        panelContent: {
            var count = 0;
            if (musicIntf.state == "playing" || musicIntf.state == "paused")
                count = count+1;
            if (backSettingsModel.get(0).isVisible)
                count = count + musicRecentsModel.count;
            if (backSettingsModel.get(1).isVisible)
                count = count + playlistsModel.count;
            if (count)
                return itemModelOne;
            else
                return itemModelOOBE;
//            (((playlistsModel.count + musicRecentsModel.count == 0) && (musicIntf.state != "playing" && musicIntf.state != "paused")) ? itemModelOOBE : itemModelOne)
        }
    }

    back: BackPanelStandard {
        panelTitle: qsTr("Music settings")
        subheaderText: qsTr("Music panel content")
        settingsListModel: backSettingsModel
        isBackPanel: true

        onClearHistClicked:{
            musicRecentsModel.clear()
        }

    }

    MusicInterface {
        id: musicIntf
        property bool ready: false;
        //Work around some weird delays in the dbus propogation of the currently playing/next tracks
        //Actually, I think the issue is in the MusicListModel - my theory
        //is that, if tracker hasn't populated the URNs we're requesting into the MusicDatabase yet,
        //then we won't get anything from the model...
        //So, we're really just giving tracker time to populate the DB on startup...
        Component.onCompleted: {
            if (state == "playing" || state == "paused") {
                refreshTimer.start();
            } else {
                ready = true;
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: 3000
        onTriggered: {
            console.log("Refreshing music!");
            musicIntf.refresh()
            musicIntf.ready = true;
        }
    }

    resources: [
        VisualItemModel {
            id: itemModelOOBE
            Item {
                height: childrenRect.height
                width: container.width
                //anchors.left:  container.left
                //anchors.left: parent.left


                Text {
                    id: textOOBE
                    anchors.left: parent.left
                    anchors.right:  parent.right
                    anchors.top: parent.top
                    anchors.topMargin: panelSize.contentTopMargin
                    anchors.leftMargin: panelSize.contentSideMargin
                    anchors.rightMargin: panelSize.contentSideMargin
                    width: parent.width
                    text: qsTr("Enjoy your music.")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: panelColors.panelHeaderColor
                }

                Button {
                    id: btnOOBE
                    active: true
                    anchors.top:  textOOBE.bottom
                    anchors.topMargin: panelSize.contentTopMargin
                    text: qsTr("Open Music!")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        spinnerContainer.startSpinner();
                        qApp.launchDesktopByName("/usr/share/meego-ux-appgrid/applications/meego-app-music.desktop")
                    }
                }
            }
        },

        VisualItemModel {
            id: itemModelOne



            PanelExpandableContent {
                MusicListModel {
                    id: curPlaying
                    type: MusicListModel.Editor
                    urns: musicIntf.nowTrack
                }
                id: currentlyPlaying
                visible: ((musicIntf.state == "playing" || musicIntf.state == "paused") && musicIntf.ready)
                text:qsTr("Currently playing")

                Component.onCompleted: {
                    if (musicIntf.state == "playing")
                        musicIntf.refresh();
                }
                contents: Item{

                    height: curPlayingListView.height

                    Column {
                        id: curPlayingListView
                        width: parent.width
                        Repeater {
                            model: curPlaying
                            delegate: FrontPanelMusicPreviewContentItem{
                                id: currentlyPlayingItem
                                isCurrentlyPlayingLayout: true
                                imageSource: thumburi
                                imagePlayStatus: (musicIntf.state == "playing")
                                text: title
                                description: "" + artist
                                onBackButtonClicked: musicIntf.prev()
                                onForwardButtonClicked: musicIntf.next()
                                onPlayButtonClicked: (musicIntf.state == "playing" ? musicIntf.pause() : musicIntf.play())
                                onClicked: (musicIntf.state == "playing" ? musicIntf.pause() : musicIntf.play())
                            }
                        }
                    }
                }
            }

            PanelExpandableContent {
                id: fpRecentMusic

                visible: backSettingsModel.get(0).isVisible && (count > 0) && !currentlyPlaying.visible
                text: qsTr("Recently played")

                property int count: 0;

                ContextMenu {
                    id: ctxMenuRecent
                    property string currentUrn
                    property string currentUri
                    property variant menuPos
                    property string playCommand

                    content: ActionMenu {
                        model:[qsTr("Open"), qsTr("Play"), qsTr("Share"), qsTr("Hide")]
                        onTriggered: {
                            if (model[index] == qsTr("Open")) {
                                spinnerContainer.startSpinner();
                                appsModel.launch( "/usr/bin/meego-qml-launcher --fullscreen --opengl --cmd " + ctxMenuRecent.playCommand + " --app meego-app-music --cdata " + ctxMenuRecent.currentUrn)
                                container.notifyModel();
                            } else if (model[index] == qsTr("Play")){
                                appsModel.launch( "/usr/bin/meego-qml-launcher --fullscreen --opengl --cmd " + ctxMenuRecent.playCommand + " --app meego-app-music --noraise --cdata " + ctxMenuRecent.currentUrn )
                                //container.notifyModel();
                            }
                            else if(model[index] == qsTr("Share"))
                            {
                                shareObj.clearItems();
                                shareObj.shareType = MeeGoUXSharingClientQmlObj.ShareTypeAudio
                                shareObj.addItem(ctxMenuRecent.currentUri);
                                ctxMenuRecent.hide()
                                shareObj.showContextTypes(ctxMenuRecent.menuPos.x, ctxMenuRecent.menuPos.y);
                            }
                            else if (model[index] == qsTr("Hide"))
                            {
                                panelObj.addHiddenItem(ctxMenuRecent.currentUrn)
                                musicRecentsModel.hideItemByURN(ctxMenuRecent.currentUrn)
                            }
                            else {
                                console.log("Unhandled context action in Photos: " + model[index]);
                            }
                            ctxMenuRecent.hide();
                        }
                    }

                }

                contents: FrontPanelMusicTrackListView{
                    model: musicRecentsModel
                    contextMenu: ctxMenuRecent
                    onCountChanged: {
                        fpRecentMusic.count = count
                    }
                }
            }

            PanelExpandableContent {

                id: playqueueItem
                property int count: 0
                visible: backSettingsModel.get(1).isVisible
                //visible: (musicIntf.nextTrackCount > 0)

                text:qsTr("Coming up in play queue")
                ContextMenu {
                    id: ctxMenuQueue
                    property string currentUrn
                    property string currentUri
                    property variant menuPos
                    property string playCommand

                    content: ActionMenu {
                        model:[qsTr("Open"), qsTr("Play"), qsTr("Share")]
                        onTriggered: {
                            if (model[index] == qsTr("Open")) {
                                spinnerContainer.startSpinner();
                                appsModel.launch( "/usr/bin/meego-qml-launcher --fullscreen --opengl --cmd " + ctxMenuQueue.playCommand + " --app meego-app-music --cdata " + ctxMenuQueue.currentUrn)
                                container.notifyModel();
                            } else if (model[index] == qsTr("Play")){
                                appsModel.launch( "/usr/bin/meego-qml-launcher --fullscreen --opengl --cmd " + ctxMenuQueue.playCommand + " --app meego-app-music --noraise --cdata " + ctxMenuQueue.currentUrn )
                                //container.notifyModel();
                            }
                            else if(model[index] == qsTr("Share"))
                            {
                                shareObj.clearItems();
                                shareObj.shareType = MeeGoUXSharingClientQmlObj.ShareTypeAudio
                                shareObj.addItem(ctxMenuQueue.currentUri);
                                ctxMenuQueue.hide()
                                shareObj.showContextTypes(ctxMenuQueue.menuPos.x, ctxMenuQueue.menuPos.y);
                            }
                            else {
                                console.log("Unhandled context action in Photos: " + model[index]);
                            }
                            ctxMenuQueue.hide();
                        }
                    }

                }
                MusicListModel {
                    id: nextTwo
                    type: MusicListModel.Editor
                    urns: musicIntf.nextTracks
                }
                contents: Item {
                    property bool playQueueEmpty: playqueueItem.count == 0
                    width: parent ? parent.width : 0
                    height: playQueueEmpty ? emptyQueue.height: trackList.height
                    Item {
                        id: emptyQueue
                        visible: playQueueEmpty
                        width: parent.width
                        height: childrenRect.height
                        Column {
                            width: parent.width
                            Text {
                                id: bpText
                                text: qsTr("Your play queue is empty")
                                height: paintedHeight + 2*panelSize.contentTopMargin
                                anchors.left: parent.left
                                anchors.right:  parent.right
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft

                                font.family: panelSize.fontFamily
                                font.pixelSize: panelSize.tileFontSize //THEME - VERIFY
                                color: panelColors.tileDescTextColor
                                wrapMode: Text.Wrap
                            }
                            Item {
                                width: parent.width
                                height: addMusicToPlayQueue.height + 2*panelSize.contentTopMargin
                                Button {
                                    id: addMusicToPlayQueue
                                    active: true
                                    text: qsTr("Add music to the play queue")
                                    font.family: panelSize.fontFamily
                                    font.pixelSize: panelSize.tileFontSize //THEME - VERIFY
                                    maxWidth: parent.width
                                    anchors.bottomMargin: panelSize.contentTopMargin
                                    anchors.topMargin: panelSize.contentTopMargin
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    onClicked: {
                                        spinnerContainer.startSpinner();
                                        appsModel.launch( "/usr/bin/meego-qml-launcher --opengl --fullscreen --app meego-app-music --cmd show --cdata playqueue")
                                        container.notifyModel();
                                    }
                                }
                            }
                        }
                    }
                    FrontPanelMusicTrackListView{
                        id: trackList
                        visible: !playQueueEmpty
                        model: nextTwo
                        contextMenu: ctxMenuQueue
                        onCountChanged: {
                            playqueueItem.count = count
                            //console.log("********nextTwo count changed: " + count)
                        }
                    }
                }
            }

            PanelExpandableContent {
                id: fpPlaylists
                visible: backSettingsModel.get(2).isVisible && (count > 0)
                text: qsTr("Playlists")
                property int count: 0

                ContextMenu {
                    id: ctxMenuAlbum
                    property string currentUrn
                    content: ActionMenu {
                        model:[ qsTr("Play"), qsTr("Hide")]

                        onTriggered: {
                            if (model[index] == qsTr("Play")) {
                                spinnerContainer.startSpinner();
                                appsModel.launch( "/usr/bin/meego-qml-launcher --opengl --fullscreen --cmd playPlaylist --app meego-app-music --cdata " + ctxMenuAlbum.currentUrn)
                                container.notifyModel();
                            } else if (model[index] == qsTr("Hide"))
                            {
                                panelObj.addHiddenItem(ctxMenuAlbum.currentUrn)
                                playlistsModel.hideItemByURN(ctxMenuAlbum.currentUrn)
                            }
                            else {
                                console.log("Unhandled context action in Photos: " + model[index]);
                            }
                            ctxMenuAlbum.hide();
                        }
                    }
                }

                contents: PanelColumnView {
                    model: playlistsModel
                    width: parent.width
                    onCountChanged: fpPlaylists.count = count
                    Component.onCompleted: fpPlaylists.count = count
                    delegate: TileListItem {
                        id:albumPreview
                        text: title
                        description: "" + artist
                        separatorVisible: index > 0
                        imageBackground: "item"
                        imageSource: thumburi
                        fallBackImage: "image://themedimage/images/media/music_thumb_med"
                        zoomImage: true

                        onClicked:{
                            spinnerContainer.startSpinner();
                            appsModel.launch( "/usr/bin/meego-qml-launcher --opengl --fullscreen --cmd playPlaylist --app meego-app-music --cdata " + urn)
                            container.notifyModel();
                        }

                        //For the context Menu
                        onPressAndHold:{
                            var pos = albumPreview.mapToItem(window, mouse.x, mouse.y);

                            ctxMenuAlbum.currentUrn = urn
                            ctxMenuAlbum.setPosition(pos.x, pos.y);
                            ctxMenuAlbum.show();
                        }

                    }
                }
            }
        }
    ]
}
