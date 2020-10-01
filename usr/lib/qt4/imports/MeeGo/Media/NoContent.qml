/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

NoContentBase {
    id: noContent
    property string title: ""
    property string description: ""
    property string button1Text: ""
    property string button2Text: ""
    property bool showButton1ContextMenu: false
    property variant button1ContextMenuModel
    signal button1Clicked();
    signal button1MenuTriggered(int index);
    signal button2Clicked();
    TopItem { id: topItem }
    ContextMenu {
        id: button1ContextMenu
        forceFingerMode: 2
        content: ActionMenu {
            model: button1ContextMenuModel
            onTriggered: {
                noContent.button1MenuTriggered(index);
                button1ContextMenu.hide();
            }
        }
    }
    notification: Item {
        id: notif
        width: parent.width
        height: isLandscape ? Math.max(col.height, buttons.height) : col.height + buttons.height
        Grid {
            width: parent.width
            columns: isLandscape ? 2 : 1
            Item {
                id: textArea
                width: isLandscape ? parent.width - buttons.width : parent.width
                height: isLandscape ? Math.max(buttonsArea.height, col.height) : col.height
                Column {
                    id: col
                    width: parent.width
                    anchors.verticalCenter: isLandscape ? parent.verticalCenter : undefined
                    Text {
                        width: parent.width
                        text: title
                        font.pixelSize: theme_fontPixelSizeLarge
                        wrapMode: Text.WordWrap
                        height: desc.visible ? paintedHeight + 20 : undefined
                    }
                    Text {
                        id: desc
                        visible: description != ""
                        width: parent.width
                        text: description
                        font.pixelSize: theme_fontPixelSizeNormal
                        wrapMode: Text.WordWrap
                        height: paintedHeight
                    }
                }
            }
            Item {
                id: buttonsArea
                width: isLandscape ? buttons.width : notif.width
                height: isLandscape ? notif.height : buttons.height
                Grid {
                    id: buttons
                    columns: isLandscape ? 1 : 3
                    visible: button1Text != "" || button2Text != ""
                    anchors.verticalCenter: isLandscape ? parent.verticalCenter : undefined
                    anchors.horizontalCenter: isLandscape ? undefined : parent.horizontalCenter
                    width: isLandscape ? Math.max(button1.width, button2.width) : button1.width + padding.width + button2.width

                    Button {
                        id: button1
                        text: button1Text
                        onClicked: {
                            if (showButton1ContextMenu) {
                                var pos = mapToItem(topItem.topItem, width-(height/2),height/2);
                                button1ContextMenu.setPosition(pos.x, pos.y);
                                button1ContextMenu.show();
                            } else {
                                noContent.button1Clicked()
                            }
                        }
                    }
                    Item {
                        id: padding
                        visible: button2.visible
                        width: 100
                        height: button2.height
                    }
                    Button {
                        id: button2
                        visible: button2Text != ""
                        text: button2Text
                        onClicked: {
                            noContent.button2Clicked()
                        }
                    }
                }
            }
        }
    }
}
