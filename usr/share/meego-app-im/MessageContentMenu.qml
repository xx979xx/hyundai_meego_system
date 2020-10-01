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
    id: container

    property variant currentPage
    property variant contactsModel

    width: 400
    height: meColumn.height

    onVisibleChanged: {
        if(visible) {
            contactsView.model = window.chatAgent.contactsModel();
        }
    }

    Column {
        id: meColumn

        height: childrenRect.height

        anchors {
            right: parent.right
            left: parent.left
        }

        Repeater {
            id: contactsView

            delegate: MessageContactDelegate {
                parent: meColumn
                anchors.left: parent.left
                anchors.right: parent.right
                currentPage: container.currentPage
            }
            clip: true
        }

        MenuItem {
            id: addContactItem
            visible: window.chatAgent != undefined ? window.chatAgent.isGroupChatCapable : false

            text: qsTr("Add contacts to chat")
            onClicked: {
                // deactivate the notification manager before switching to the add contacts screen
                notificationManager.chatActive = false;
                currentPage.hideActionMenu();
                window.pickContacts();
            }
        }

        Image {
            anchors.left: parent.left
            anchors.right: parent.right
            source: "image://themedimage/widgets/common/menu/menu-item-separator"
        }

        MenuItem {
            id: meClearHistory
            text: qsTr("Clear chat history")
            onClicked: {
                if(window.chatAgent.isConference) {
                    accountsModel.clearRoomHistory(window.currentAccountId, window.chatAgent.channelPath);
                } else {
                    accountsModel.clearContactHistory(window.currentAccountId, window.currentContactId);
                }
                currentPage.hideActionMenu();
            }
        }

        Image {
            anchors.left: parent.left
            anchors.right: parent.right
            source: "image://themedimage/widgets/common/menu/menu-item-separator"
        }

        MenuItem {
            id: meEndChat
            text: qsTr("End chat")
            onClicked: {
                currentPage.closeConversation();
                currentPage.hideActionMenu();
            }
        }
    }
}
