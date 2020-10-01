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
import TelepathyQML 0.1

Item {
    id: contactDelegate

    width: parent.width
    height: mainArea.height
    property bool tabDiv: false
    property variant currentPage
    property bool active: (model.presenceType == TelepathyTypes.ConnectionPresenceTypeAvailable
                           || model.presenceType == TelepathyTypes.ConnectionPresenceTypeBusy
                           || model.presenceType == TelepathyTypes.ConnectionPresenceTypeAway
                           || model.presenceType == TelepathyTypes.ConnectionPresenceTypeExtendedAway)

    Component.onCompleted: {
        if(model.presenceMessage != "") {
            message.text = model.presenceMessage;
        } else {
            message.text = window.presenceStatusText(model.presenceType);
        }
    }

    Item {
        id: mainArea
        width: parent.width
        height: 75

        MouseArea {
            ListModel { id: menu}

            anchors.fill: parent
            onClicked: {
                contactDelegate.ListView.view.currentIndex = index;
                var map = mapToItem(window, mouseX, mouseY);
                menu.clear();

                // Add items to menu according to contact capabilities
                if(model.textChat && window.chatAgent.isConference) {
                    menu.append({"modelData":qsTr("Private chat")});
                }
                // check if contact is known
                if(!accountsModel.isContactKnown(window.currentAccountId, window.chatAgent.channelPath, model.id)) {
                    menu.append({"modelData":qsTr("Add to contacts")});
                }

                // set the global variable to make sure it is available for the menu
                window.currentPage = contactDelegate.currentPage;

                // open menu
                contextMenu.setPosition( map.x, map.y);
                actionMenu.model = menu;
                actionMenu.payload = model;
                contextMenu.show();
            }
        }

        ContextMenu {
            id: contextMenu
            content: ActionMenu {
                id: actionMenu

                ListModel {id: menuIndex}

                onTriggered: {
                    // clear the existing menu
                    menuIndex.clear();

                    // Recreate menu according to contact capabilities
                    // this is done because the menu is dynamic, and we can't reuse the
                    // menu previously used because the contactDelegate is not available when
                    // this is called through the loader. Only the selected index and the payload
                    // are available
                    if(payload.textChat && window.chatAgent.isConference) {
                        menuIndex.append({"modelData":1});
                    }
                    if(!accountsModel.isContactKnown(window.currentAccountId, window.chatAgent.channelPath, payload.id)) {
                        menuIndex.append({"modelData":2});
                    }

                    // get the selected action and do whatever was requested
                    var actionIndex = menuIndex.get(index).modelData;
                    if (actionIndex == 1) {
                        // chat
                        var contactid = accountsModel.startPrivateChat(window.currentAccountId, window.chatAgent.channelPath, payload.id);
                        window.currentPage.hideActionMenu();
                        window.popPage();
                        window.startConversation(contactid);
                    } else if (actionIndex == 2) {
                        // add contact
                        accountsModel.addContactFromGroupChat(window.currentAccountId, window.chatAgent.channelPath, payload.id);
                        window.currentPage.hideActionMenu();
                    }

                    // By setting the sourceComponent of the loader to undefined,
                    // then the QML engine will destruct the context menu element
                    // much like doing a c++ delete
                    contextMenu.hide();
                }
            }
        }

        Avatar {
            id: avatar
            active: contactDelegate.active
            source: model.avatar
            anchors.left: parent.left
            anchors.top:  parent.top
            anchors.bottom: itemSeparator.top
            anchors.margins: 3
        }

        Column {
            id: nameColumn

            anchors {
                left: avatar.right;
                right: mainArea.right
                verticalCenter: avatar.verticalCenter
                margins: 10
            }
            height: childrenRect.height

            Text {
                id: displayText
                text: model.aliasName
                width: parent.width
                elide: Text.ElideRight
                color: theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
            }

            Row {
                spacing: 5
                width: parent.width
                height: message.height

                PresenceIcon {
                    id: presence
                    status: model.presenceType
                    anchors.verticalCenter: message.verticalCenter
                    anchors.topMargin: 5
                }

                Text {
                    id: message
                    text: ""
                    width: parent.width - presence.width - 10
                    color: theme_fontColorInactive
                    font.pixelSize: theme_fontPixelSizeNormal
                    elide: Text.ElideRight
                }
            }
        }

        Image {
            id: itemSeparator
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: height
            source: "image://themedimage/widgets/common/menu/menu-item-separator"
            visible: window.chatAgent.isGroupChatCapable
        }
    }
}
