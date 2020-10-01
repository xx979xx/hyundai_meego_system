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
    id: contactsScreenPage

    anchors.fill: parent
    enableCustomActionMenu: true
    
    property int count: listView.count + contactRequestModel.rowCount
    property int accountStatus: 0
    property int contactListState: 0
    property bool showAccountOffline: (accountStatus == TelepathyTypes.ConnectionStatusDisconnected
                                       || accountStatus == TelepathyTypes.ConnectionStatusConnecting)
    property bool showLoadingContacts: (!showAccountOffline && contactListState != TelepathyTypes.ContactListStateSuccess)
    property bool showAddFriends: !count && !showAccountOffline && !window.showToolBarSearch
                                  && contactListState == TelepathyTypes.ContactListStateSuccess
    property bool showAddFriendsItem: false
    property int requestedStatusType: 0
    property string requestedStatus: ""
    property string requestedStatusMessage: ""

    Component.onCompleted: {
        pageTitle = window.currentAccountName;
        accountStatus = window.accountItem.data(AccountsModel.ConnectionStatusRole);
        contactListState = window.accountItem.data(AccountsModel.ContactListStateRole);
        setInfoBarMessage();
    }

    onAccountStatusChanged: {
        contactsModel.filterByAccountId(currentAccountId);
        contactRequestModel.filterByAccountId(currentAccountId);
        setInfoBarMessage();
    }

    onActionMenuIconClicked: {
        contactContentMenu.setPosition( mouseX, mouseY);
        contactContentMenu.show();
    }

    onShowAccountOfflineChanged: {
        setInfoBarMessage();
    }

    onShowLoadingContactsChanged: {
        setInfoBarMessage();
    }

    onShowAddFriendsChanged: {
        setInfoBarMessage();
    }

    Connections {
        target: window.accountItem

        onChanged: {
            accountStatus = window.accountItem.data(AccountsModel.ConnectionStatusRole);
            contactListState = window.accountItem.data(AccountsModel.ContactListStateRole);
        }
    }

    Connections {
        target: window

        onCurrentAccountNameChanged: {
            pageTitle = window.currentAccountName;
        }

        onSearch: {
            contactsModel.filterByString(needle);
        }

        onSearchRetracted: {
            contactsModel.filterByString("");
        }
    }

    // this connection is to handle
    Connections {
        target: confirmationDialogItem
        onAccepted: {

            var icon = window.accountItem.data(AccountsModel.IconRole);

            if (confirmationDialogItem.instanceReason != "contact-menu-single-instance") {
                return;
            }

            // if the dialog was accepted we should disconnect all other accounts
            // of the same type
            accountFactory.disconnectOtherAccounts(icon, window.currentAccountId);

            // and set the account online
            window.accountItem.setRequestedPresence(requestedStatusType, requestedStatus, requestedStatusMessage);
            window.accountItem.setAutomaticPresence(requestedStatusType, requestedStatus, requestedStatusMessage);
        }

        // no need to do anything if the dialog is rejected
        // onRejected:
    }

    Item {
        id: pageContent
        anchors.fill: parent

        NoNetworkHeader {
            id: noNetworkItem
        }

        InfoBar {
            id: infoBar

            anchors {
                top: noNetworkItem.bottom
                left: parent.left
                right: parent.right
            }
        }

        Component {
            id: requestsViewComponent

            ListView {
                id: requestsView
                interactive: false
                property int itemHeight: theme_commonBoxHeight;

                height: itemHeight * count

                anchors {
                    left: parent.left
                    right: parent.right
                }
                visible: listView.visible
                model: contactRequestModel
                delegate: ContactRequestDelegate {
                    itemHeight: requestsView.itemHeight
                }
            }

        }

        ListView {
            id: listView

            anchors {
                top: infoBar.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            visible: (!showAccountOffline)

            model: contactsModel
            delegate: ContactDelegate {}
            header: requestsViewComponent
            clip: true

            interactive: contentHeight > height
        }

        Title {
            id: friendsTitle
            anchors.top: infoBar.bottom
            text: qsTr("Add a friend")
            visible: showAddFriendsItem
        }

        AddAFriend {
            id: addAFriendItem

            visible: showAddFriendsItem
            width: 200
            anchors.top: friendsTitle.bottom
            anchors.margins: 10
            anchors.left: parent.left
        }
    }

    function hideActionMenu()
    {
        contactContentMenu.hide();
    }

    function setInfoBarMessage()
    {
        var text;

        // check first whether the account is offline or just connecting
        text = accountStatusMessage(accountStatus);
        // if not, check whether contacts are loading
        if (text == "") {
            if (showLoadingContacts) {
                text = qsTr("Loading contacts...");
                showAddFriendsItem = false;
            } else if (showAddFriends && !showLoadingContacts) {
                // check whether the contact list is really empty
                if (accountsModel.actualContactsCount(window.currentAccountId) == 0) {
                    text = qsTr("You haven't added any friends yet");
                    showAddFriendsItem = true;
                } else {
                    showAddFriendsItem = false;
                }
            } else {
                showAddFriendsItem = false;
            }
        } else {
            showAddFriendsItem = false;
        }

        // assign and show/hide as necessary
        infoBar.text = text;
        if (text == "") {
            infoBar.hide();
        } else {
            infoBar.show();
        }
    }

    function accountStatusMessage(status)
    {
        if (accountStatus == TelepathyTypes.ConnectionStatusDisconnected) {
            return qsTr("Account is offline");
        } else if (accountStatus == TelepathyTypes.ConnectionStatusConnecting) {
            return qsTr("Account is connecting...");
        } else {
            return "";
        }
    }

    ContextMenu {
        id: contactContentMenu

        width: 200
        forceFingerMode: 2

        onVisibleChanged: {
            actionMenuOpen = visible
        }

        content: ContactContentMenu {
            currentPage: contactsScreenPage;
        }
    }
}
