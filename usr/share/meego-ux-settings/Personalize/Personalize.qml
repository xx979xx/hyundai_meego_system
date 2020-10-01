/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1
import MeeGo.Media 0.1
import MeeGo.Panels 0.1

AppPage {
    id: container
    pageTitle: qsTr("Personalize")

    Item {
        id: personalizeContainer
        anchors.fill: parent

        PanelProxyModel{
                id: panelModel
                sortType: PanelProxyModel.SortTypeDefaultIndex
        }

        Flickable {
            contentHeight: contentArea.height
            anchors.fill: parent

            Column {
                id: contentArea
                width: parent.width

                PhotoPicker {
                    id: photoPicker
                    parent: personalizeContainer
                    property string selectedPhoto

                    albumSelectionMode: false
                    onPhotoSelected: {
                        selectedPhoto = uri.split("file://")[1];
                    }
                    onAccepted: {
                        if (selectedPhoto)
                        {
                            var path = customWallpapers.model.copyImageToBackgrounds(selectedPhoto);
                            customWallpapers.model.activeWallpaper = path;
                            mainWindow.goHome();
                            personalizeContainer.close();
                        }
                    }
                }

                BuiltInWallpapers {
                    id: builtinWallpapers
                    width: parent.width
                    height: 200
                }

                CustomWallpapers {
                    id: customWallpapers
                    width: parent.width
                    opacity: height > 0 ? 1.0 : 0.0
                    height: list.count > 0 ? 200 : 0
                }

                WallpaperTools {
                    id: wallpaperTools
                    width: parent.width
                    height: 100

                    onOpenGallery: {
                        photoPicker.show();
                    }
                }

                Label {
                    text: qsTr("Panels")
                    width: parent.width
                    height: 60
                }

                Repeater {
                    width: parent.width
                    model: panelModel
                    delegate:panelDelegate
                    focus: true
                }

                Component {
                    id: panelDelegate
                    Item {
                        width: parent.width;
                        height: imgPanel.height

                        Image {
                            id: imgPanel
                            source: "image://theme/settings/btn_settingentry_up"
                            width: parent.width
                        }

                        Text {
                            id: titleText
                            text: displayName
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.right: tbPanel.left
                            anchors.rightMargin: 12
                            color: theme_fontColorNormal
                            font.pixelSize: theme_fontPixelSizeLarge
                            anchors.verticalCenter: parent.verticalCenter
                            wrapMode: Text.NoWrap
                            elide: Text.ElideRight
                        }

                        ToggleButton {
                            id: tbPanel
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 20
                            visible: allowHide
                            on: isVisible
                            onToggled: {
                                panelObj.IsVisible = isOn;
                            }
                        }
                    }
                }
            }
        }
    }
}
