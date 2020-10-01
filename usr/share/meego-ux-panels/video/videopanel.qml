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
        catalog: "meego-ux-panels-video"
    }

    //Currently no hidable sections, as we only have 1 section in video for the moment,
    //but leaving this here as a placehold for when there's more...
    ListModel{
        id: backSettingsModel
        //Get around i18n issues w/ the qsTr of the strings being in a different file
//        Component.onCompleted: {
//            backSettingsModel.append({ "settingsTitle": qsTr("Recently watched"),
//                                     "custPropName": "RecentlyWatched",
//                                     "isVisible": true });
//        }

    }

    //Because we do not have a universal launcher
    //Need to modify model that this app is launched
    function notifyModel()
    {
        appsModel.favorites.append("/usr/share/meego-ux-appgrid/applications/meego-app-video.desktop")
    }


    VideoListModel {
        id: recentlyViewed
        type: VideoListModel.ListofRecentlyViewed
        limit: 4
        sort: VideoListModel.SortByDefault
        Component.onCompleted: {
            hideItemsByURN(panelObj.HiddenItems)
        }
    }

    onPanelObjChanged: {
        recentlyViewed.hideItemsByURN(panelObj.HiddenItems)
    }

    front: SimplePanel {
        panelTitle: qsTr("Video")
        panelComponent: (recentlyViewed.count == 0 ? videoOOBE : videoFront)
    }

    back: BackPanelStandard {
        panelTitle: qsTr("Video settings")
        subheaderText: qsTr("Video panel content")
        settingsListModel: backSettingsModel
        isBackPanel: true

        onClearHistClicked:{
            recentlyViewed.clear()
        }

    }

    Component {
        id: videoOOBE
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
                text: qsTr("Watch your videos.")
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                color: panelColors.panelHeaderColor
            }

            Button {
                id: btnOOBE
                active: true
                anchors.top:  textOOBE.bottom
                anchors.topMargin: panelSize.contentTopMargin
                text: qsTr("Open Videos!")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    spinnerContainer.startSpinner();
                    qApp.launchDesktopByName("/usr/share/meego-ux-appgrid/applications/meego-app-video.desktop")
                }
            }
        }
    }

    Component {
        id: videoFront
        Flickable {
            anchors.fill: parent
            interactive: (height < contentHeight)
            onInteractiveChanged: {
                if (!interactive)
                    contentY = 0;
            }

            contentHeight: myContent.height
            clip: true
            PanelExpandableContent {
                id: myContent
                showHeader: false
                contents: PrimaryTileGrid {
                    ContextMenu {
                        id: ctxMenu
                        property string currentUrn
                        property string currentUri
                        property variant menuPos

                        content: ActionMenu {
                            model:[ qsTr("Play"),qsTr("Share"), qsTr("Hide")]


                            onTriggered: {
                                if (model[index] == qsTr("Play")) {
                                    spinnerContainer.startSpinner();
                                    appsModel.launch( "/usr/bin/meego-qml-launcher --opengl --cmd playVideo --app meego-app-video --fullscreen --cdata " + ctxMenu.currentUrn )
                                    container.notifyModel()
                                } else if (model[index] == qsTr("Hide")){
                                    panelObj.addHiddenItem(ctxMenu.currentUrn)
                                    recentlyViewed.hideItemByURN(ctxMenu.currentUrn)
                                }
                                else if (model[index] == qsTr("Share"))
                                {
                                    shareObj.clearItems();
                                    shareObj.shareType = MeeGoUXSharingClientQmlObj.ShareTypeVideo
                                    shareObj.addItem(ctxMenu.currentUri);
                                    ctxMenu.hide()
                                    shareObj.showContextTypes(ctxMenu.menuPos.x, ctxMenu.menuPos.y);
                                }
                                else {
                                    console.log("Unhandled context action in Photos: " + model[index]);
                                }
                                ctxMenu.hide();
                            }
                        }

                    }
                    model: recentlyViewed
                    delegate: PrimaryTile {
                        id:previewItem
                        imageSource:thumburi
                        text:qsTr(title)

                        onClicked: {
                            spinnerContainer.startSpinner();
                            appsModel.launch( "/usr/bin/meego-qml-launcher --opengl --cmd playVideo --app meego-app-video --fullscreen --cdata " + urn )
                            container.notifyModel()
                        }

                                //For the context Menu
                        onPressAndHold:{

                            var pos = previewItem.mapToItem(window, mouse.x, mouse.y);
                            ctxMenu.currentUrn=urn;
                            ctxMenu.currentUri=uri;
                            ctxMenu.menuPos = pos;
                            ctxMenu.setPosition(pos.x, pos.y);
                            ctxMenu.show();

                        }
                    }
                }
            }
        }
    }
}
