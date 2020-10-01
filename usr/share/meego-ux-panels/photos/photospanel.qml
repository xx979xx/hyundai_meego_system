/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs

import MeeGo.Panels 0.1
import MeeGo.Sharing 0.1
import MeeGo.Media 0.1
import MeeGo.Components 0.1

FlipPanel {
    id: container

    Labs.BackgroundModel {
        id: backgroundModel
    }

    Translator {
        catalog: "meego-ux-panels-photos"
    }

    //Because we do not have a universal launcher
    //Need to modify model that this app is launched
    function notifyModel()
    {
        appsModel.favorites.append("/usr/share/meego-ux-appgrid/applications/meego-app-photos.desktop")        
    }

    ListModel{
        id: backSettingsModel

        ListElement {
            //i18n OK, as it gets properly set in the Component.onCompleted - long drama why this is necessary - limitation in QML translation capabilities
            settingsTitle: "Recently viewed"
            custPropName: "RecentlyViewed"
            isVisible: true
        }
        ListElement {
            //i18n OK, as it gets properly set in the Component.onCompleted - long drama why this is necessary - limitation in QML translation capabilities
            settingsTitle: "Albums"
            custPropName: "Albums"
            isVisible: true
        }

        //Get around i18n issues w/ the qsTr of the strings being in a different file
        Component.onCompleted: {
            backSettingsModel.setProperty(0, "settingsTitle", qsTr("Recently viewed"));
            backSettingsModel.setProperty(1, "settingsTitle", qsTr("Albums"));
        }
    }

    onPanelObjChanged: {
        allPhotosListModel.hideItemsByURN(panelObj.HiddenItems)
        allAlbumsListModel.hideItemsByURN(panelObj.HiddenItems)
    }

    PhotoListModel {
        id: allPhotosListModel
        type: PhotoListModel.ListofRecentlyViewed
        limit: 16
        sort: PhotoListModel.SortByDefault
        Component.onCompleted: {
            hideItemsByURN(panelObj.HiddenItems)
        }
    }

    PhotoListModel {
        id: allAlbumsListModel
        type: PhotoListModel.ListofUserAlbums
        limit: 0
        sort: PhotoListModel.SortByDefault
        Component.onCompleted: {
            hideItemsByURN(panelObj.HiddenItems)
        }
    }

    front: SimplePanel {
        panelTitle: qsTr("Photos")
        panelComponent: {
            var count = 0;
            if (backSettingsModel.get(0).isVisible)
                count = count + allPhotosListModel.count;
            if (backSettingsModel.get(1).isVisible)
                count = count + allAlbumsListModel.count;
            if (count)
                return photoFront;
            else
                return photoOOBE;
//            (allPhotosListModel.count + allAlbumsListModel.count == 0 ? photoOOBE : photoFront)

        }
    }

    back: BackPanelStandard {
        panelTitle: qsTr("Photos settings")
        subheaderText: qsTr("Photos panel content")
        settingsListModel: backSettingsModel
        isBackPanel: true

        onClearHistClicked:{
           allPhotosListModel.clear()
        }

    }

    Component {
        id: photoOOBE
        Item {
            height: container.height
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
                text: qsTr("See your photos.")
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                color: panelColors.panelHeaderColor
            }

            Button {
                id: btnOOBE
                active: true
                anchors.top:  textOOBE.bottom
                anchors.topMargin: panelSize.contentTopMargin
                text: qsTr("Open Photos!")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    spinnerContainer.startSpinner();
                    qApp.launchDesktopByName("/usr/share/meego-ux-appgrid/applications/meego-app-photos.desktop")
                }
            }
        }
    }

    Component {
        id: photoFront

        Flickable{

            ContextMenu {
                id: ctxMenuPhoto
                property string currentUrn
                property string currentUri
                property variant menuPos
                content: ActionMenu {
                    model:[qsTr("Open"), qsTr("Share") ,qsTr("Hide"), qsTr("Set as background")]
                    onTriggered: {
                        if (model[index] == qsTr("Open")) {
                            spinnerContainer.startSpinner();
                            appsModel.launch("/usr/bin/meego-qml-launcher --opengl --cmd showPhoto --fullscreen --app meego-app-photos --cdata " + ctxMenuPhoto.currentUrn )
                            container.notifyModel()
                        } else if (model[index] == qsTr("Hide")){
                            panelObj.addHiddenItem(ctxMenuPhoto.currentUrn)
                            allPhotosListModel.hideItemByURN(ctxMenuPhoto.currentUrn)
                        }else if (model[index] == qsTr("Share"))
                        {
                            shareObj.clearItems();
                            shareObj.addItem(ctxMenuPhoto.currentUri);
                            shareObj.shareType = MeeGoUXSharingClientQmlObj.ShareTypeImage
                            ctxMenuPhoto.hide()
                            shareObj.showContextTypes(ctxMenuPhoto.menuPos.x, ctxMenuPhoto.menuPos.y);
                        }
                        else {
                            backgroundModel.activeWallpaper = ctxMenuPhoto.currentUri;
                        }
                        ctxMenuPhoto.hide();
                    }
                }
            }

            ContextMenu {
                id: ctxMenuAlbum
                property string currentUrn


                content: ActionMenu {
                    model:[qsTr("Open"),qsTr("Hide")]

                    onTriggered: {
                        if (model[index] == qsTr("Open")) {
                            spinnerContainer.startSpinner();
                            appsModel.launch("/usr/bin/meego-qml-launcher --opengl --cmd showAlbum --fullscreen --app meego-app-photos --cdata " + ctxMenuAlbum.currentUrn )
                            container.notifyModel()
                        } else if (model[index] == qsTr("Hide")){
                            panelObj.addHiddenItem(ctxMenuAlbum.currentUrn)
                            allAlbumsListModel.hideItemByURN(ctxMenuAlbum.currentUrn)
                        } else {
                            console.log("Unhandled context action in Photos: " + model[index]);
                        }
                        ctxMenuAlbum.hide();
                    }
                }
            }


            id: photoFrontItem
            anchors.fill: parent
            interactive: (contentHeight > height)
            onInteractiveChanged: {
                if (!interactive)
                    contentY = 0;
            }
            contentHeight: fpecPhotoGrid.height + fpecAlbumList.height
            PanelExpandableContent {
                id: fpecPhotoGrid
                text: qsTr("Recently viewed")
                visible: backSettingsModel.get(0).isVisible && (count > 0)
                property int count: 0
                contents: SecondaryTileGrid{
                    model: allPhotosListModel
                    onModelCountChanged: fpecPhotoGrid.count = modelCount
                    Component.onCompleted: fpecPhotoGrid.count = modelCount
                    delegate: SecondaryTileGridItem {
                        id:photoPreview
                        imageSource: thumburi
                        zoomImage: true
                        onClicked: {
                            spinnerContainer.startSpinner();
                            appsModel.launch("/usr/bin/meego-qml-launcher --opengl --cmd showPhoto --fullscreen --app meego-app-photos --cdata " + urn )
                            container.notifyModel();
                        }
                        //For the context Menu
                        onPressAndHold:{
                            var pos = photoPreview.mapToItem(topItem.topItem, mouse.x, mouse.y);

                            ctxMenuPhoto.currentUrn= urn
                            ctxMenuPhoto.currentUri=uri;
                            ctxMenuPhoto.menuPos = pos;
                            ctxMenuPhoto.setPosition(pos.x, pos.y);
                            ctxMenuPhoto.show();
                        }

                    }
                }
            }

            PanelExpandableContent {
                id: fpecAlbumList
                anchors.top: fpecPhotoGrid.bottom
                visible: backSettingsModel.get(1).isVisible && (count > 0)
                text: qsTr("Albums")
                property int count: 0
                contents: PanelColumnView {
                    width: parent.width
                    model: allAlbumsListModel
                    onCountChanged: fpecAlbumList.count = count
                    Component.onCompleted: fpecAlbumList.count = count
                    delegate: SecondaryTileBase {
                        id:albumPreview
                        separatorVisible: index > 0
                        imageSource: thumburi == ""? "image://themedimage/images/media/photo_thumb_default":thumburi
                        imageBackground: "normal"
                        fillMode: Image.PreserveAspectCrop
                        text: title
                        zoomImage: true
                        descriptionComponent: Item {
                            Column {
                                width: parent.width
                                anchors.bottom: parent.bottom
                                Text {
                                    text: (photocount == 1 ? qsTr("%1 photo").arg(photocount) : qsTr("%1 photos").arg(photocount))
                                    width: parent.width
                                    font.pixelSize: panelSize.tileFontSize //THEME - VERIFY
                                    color: panelColors.tileDescTextColor //THEME - VERIFY
                                    wrapMode: Text.NoWrap
                                    elide: Text.ElideRight
                                }
                                Text {
                                    // TODO creationtime is empty. Use Qt.formatDateTime(t,"MMMM yyyy")
                                    // if we get creationtime as QDateTime instead of ISODate formatted string
                                    text: qsTr("Created %1").arg(""+Qt.formatDateTime(addedtime, "MMMM yyyy"))
                                    width: parent.width
                                    font.pixelSize: panelSize.tileFontSize //THEME - VERIFY
                                    color: panelColors.tileDescTextColor //THEME - VERIFY
                                    wrapMode: Text.NoWrap
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        onClicked: {
                            spinnerContainer.startSpinner();
                            appsModel.launch("/usr/bin/meego-qml-launcher --opengl --cmd showAlbum --fullscreen --app meego-app-photos --cdata " + urn)
                            container.notifyModel();
                        }

                        //For the context Menu
                        onPressAndHold:{
                            var pos = albumPreview.mapToItem(window, mouse.x, mouse.y);

                            ctxMenuAlbum.currentUrn= urn
                            ctxMenuAlbum.setPosition(pos.x, pos.y);
                            ctxMenuAlbum.show();
                        }
                    }
                }
            }
        }

    }
    
}
