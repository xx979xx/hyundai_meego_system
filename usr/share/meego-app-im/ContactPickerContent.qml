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

AppPage {
    id: contactPickerPage

    anchors.fill: parent

    signal itemSelected(string parentId, string itemId);
    signal itemDeselected(string parentId, string itemId);

    onItemSelected: {
        var exists = false;
        for(var i = 0; i < selectedItems.count; ++i) {
            if(selectedItems.get(i).itemId == itemId) {
                exists = true;
            }
        }
        if(exists == false) {
            selectedItems.append({"itemId":itemId});
        }
    }

    onItemDeselected: {
        for(var i = 0; i < selectedItems.count; ++i) {
            if(selectedItems.get(i).itemId == itemId) {
                selectedItems.remove(i);
            }
        }
    }

    Component.onCompleted: {
        pageTitle = qsTr("Add contacts to chat");
        var contactsList;
        if(window.currentContactId == "") {
            contactsList = accountsModel.channelContacts(window.currentAccountId, window.chatAgent.channelPath);
        } else {
            contactsList = accountsModel.channelContacts(window.currentAccountId, window.currentContactId);
        }
        contactsModel.skipContacts(contactsList);
        contactsModel.setContactsOnly(true);
    }

    Component.onDestruction: {
        contactsModel.setContactsOnly(false);
        contactsModel.clearSkippedContacts();
    }

    Connections {
        target: window
        onSearch: {
            contactsModel.filterByString(needle);
        }
    }

    ListModel {
        id: selectedItems
    }

    function isItemSelected(contactId)
    {
        for(var i = 0; i < selectedItems.count; ++i) {
            if(selectedItems.get(i).itemId == contactId) {
                return true;
            }
        }
        return false;
    }

    Item {
        id: pageContent
        anchors.fill: parent

        ListView {
            id: listView

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: buttonRowImage.top
            }

            model: contactsModel
            delegate: ContactPickerDelegate {}
            clip: true
            interactive: contentHeight > height
        }

        Image {
            id: buttonRowImage

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: 100
            source: "image://themedimage/widgets/common/action-bar/action-bar-background"

            Row {
                id: buttonRow

                height:  acceptButton.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                spacing:  10

                Button {
                    id: acceptButton
                    anchors {
                        margins: 10
                        verticalCenter: parent.verticalCenter
                    }

                    text: qsTr("Add")
                    textColor: theme_buttonFontColor
                    bgSourceUp: "image://themedimage/widgets/common/button/button-positive"
                    bgSourceDn: "image://themedimage/widgets/common/button/button-positive-pressed"

                    onClicked: {
                        var contactsList = ""; // i18n ok
                        for(var i = 0; i < selectedItems.count; ++i) {
                            contactsList = contactsList + " " + selectedItems.get(i).itemId; // i18n ok
                        }

                        if(window.currentContactId == "") {
                            accountsModel.addContactsToChat(window.currentAccountId, window.chatAgent.channelPath, contactsList);
                        } else {
                            accountsModel.addContactsToChat(window.currentAccountId, window.currentContactId, contactsList);
                        }

                        // set chatActive before going back to the message screen
                        // if in the future, this screen could be called from another screen, this should be fixed
                        notificationManager.chatActive = true;
                        window.popPage();
                    }
                }

                Button {
                    id: cancelButton
                    anchors {
                        margins: 10
                        verticalCenter: parent.verticalCenter
                    }

                    text: qsTr("Cancel")
                    textColor: theme_buttonFontColor
                    bgSourceUp: "image://themedimage/widgets/common/button/button-negative"
                    bgSourceDn: "image://themedimage/widgets/common/button/button-negative-pressed"

                    // TODO: check if we need to remove the contact
                    onClicked: {
                        window.popPage();
                    }
                }
            }
        }
    }
}
