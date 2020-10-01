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
import MeeGo.Media 0.1

Item {
    id: meTabItem

    width: 200
    height: optionColumn.height

    property variant currentPage

    signal accountChanged

    Component.onCompleted: {
        if (window.accountItem.data(AccountsModel.CurrentPresenceStatusMessageRole) != "") {
            statusMessage.text = window.accountItem.data(AccountsModel.CurrentPresenceStatusMessageRole);
        } else {
            statusMessage.text = window.presenceStatusText(window.accountItem.data(AccountsModel.CurrentPresenceTypeRole));
        }
        statusRadioGroup.select(window.accountItem.data(AccountsModel.CurrentPresenceTypeRole));
    }

    onVisibleChanged: {
        if(!visible) {
            resetMenu();
        }
    }

    Connections {
        target: window.accountItem
        // a small trick
        onChanged: {
            window.accountItem = window.accountItem
            if (window.accountItem.data(AccountsModel.CurrentPresenceStatusMessageRole) != "") {
                statusMessage.text = window.accountItem.data(AccountsModel.CurrentPresenceStatusMessageRole);
            } else {
                statusMessage.text = window.presenceStatusText(window.accountItem.data(AccountsModel.CurrentPresenceTypeRole));
            }
            displayName.text = window.accountItem.data(AccountsModel.NicknameRole);
            presenceIcon.status = window.accountItem.data(AccountsModel.CurrentPresenceTypeRole);
        }
    }

    Connections {
        target: window
        onCurrentAccountIdChanged: {
            window.accountItem = accountsModel.accountItemForId(window.currentAccountId);
        }
    }

    Column {
        id: optionColumn
        anchors.right: parent.right
        anchors.left: parent.left

        Avatar {
            id: avatarImage
            anchors.leftMargin: 10
            anchors.left: parent.left
            anchors.rightMargin: 10
            anchors.right: parent.right
            height: width
            anchors.bottomMargin: 2
            source: "image://avatars/" + window.accountItem.data(AccountsModel.IdRole) + // i18n ok
                    "?" + accountFactory.avatarSerial
            noAvatarImage: "image://themedimage/widgets/common/avatar/avatar-default"

            Component {
                id: avatarMenu
                PictureChangeMenu {
                    id: pictureChangeMenu
                    onClose: {
                        currentPage.hideActionMenu();
                    }
                }
            }

            MouseArea {
                id: avatarMouseArea
                anchors.fill: avatarImage

                onClicked: {
                    createPhotoPicker();
                    photoPicker.show();
                }
            }
        }

        Item {
            id: avatarSeparator
            height: 5
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Row {
            id: statusRow
            spacing: 5
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            Text {
                id: displayName
                width: parent.width - presenceIcon.width - 5
                text: window.accountItem.data(AccountsModel.NicknameRole)
                color: theme_fontColorNormal
                font.weight: Font.Bold
                font.pixelSize: theme_fontPixelSizeNormal
                elide: Text.ElideRight
            }

            PresenceIcon {
                id: presenceIcon
                anchors.verticalCenter: displayName.verticalCenter
                status: window.accountItem.data(AccountsModel.CurrentPresenceTypeRole)
            }
        }

        Text {
            id: statusMessage
            text: ""
            color: theme_fontColorInactive
            font.pixelSize: theme_fontPixelSizeSmall
            width: parent.width - presenceIcon.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
        }

        Item {
            id: statusMessageSeparator
            height: 15
            anchors.left: parent.left
            anchors.right: parent.right
        }

        MenuItemSeparator { id: statusSeparator }

        MenuItem {
            id: updateStatusItem
            text: qsTr("Update status")

            onClicked: {
                if(statusMenu.visible == false) {
                    statusMenu.opacity = 1;
                    customMessageBox.focus = true;
                    avatarImage.visible = false;
                    avatarSeparator.visible = false;
                    statusRow.visible = false;
                    statusMessage.visible = false;
                    statusMessageSeparator.visible = false;
                    statusSeparator.visible = false;
                    updateStatusItem.visible = false;
                    updateStatusSeparator.visible = false;
                    updateNickItem.showUpdateNick = false;
                    updateNick.visible = false;
                    nicknameSeparator.showUpdateNick = false;
                    addIMContactItem.showAddFriend = false;
                    addAFriend.visible = false;
                    friendSeparator.showAddFriend = false;
                    clearHistoryItem.visible = false;
                    historySeparator.visible = false;
                    logOutItem.visible = false;
                    customMessageBox.textInput.forceActiveFocus();
                }
            }
        }

        Item {
            id: updateStatus
            height: statusMenu.visible ? childrenRect.height + 2 * statusMenu.anchors.topMargin : 0
            width: parent.width

            Column {
                id: statusMenu
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.left: parent.left
                visible: opacity > 0
                opacity: 0
                spacing: 5

                Behavior on opacity {
                    NumberAnimation {
                        duration:  250
                    }
                }

                ListModel {
                    id: statusModel
                    ListElement {
                        status: "available"; // i18n ok
                        type: TelepathyTypes.ConnectionPresenceTypeAvailable
                        text: QT_TR_NOOP("Available")
                    }
                    ListElement {
                        status: "away"; // i18n ok
                        type: TelepathyTypes.ConnectionPresenceTypeAway
                        text: QT_TR_NOOP("Away")
                    }
                    ListElement {
                        status: "busy"; // i18n ok
                        type: TelepathyTypes.ConnectionPresenceTypeBusy
                        text: QT_TR_NOOP("Busy")
                    }
                    ListElement {
                        status: "invisible"; // i18n ok
                        type: TelepathyTypes.ConnectionPresenceTypeHidden
                        text: QT_TR_NOOP("Invisible")
                    }
                    ListElement {
                        status: "offline"; // i18n ok
                        type: TelepathyTypes.ConnectionPresenceTypeOffline
                        text: QT_TR_NOOP("Offline")
                    }
                }

                RadioGroup {
                    id: statusRadioGroup
                }

                property string statusString: ""

                Text {
                    text: qsTr("Your Status:")
                    color: theme_fontColorNormal
                    font.pixelSize: theme_fontPixelSizeNormal
                    elide: Text.ElideRight

                }

                Repeater {
                    id: statusView
                    model: statusModel
                    anchors.left: parent.left
                    anchors.right: parent.right

                    delegate: Component {
                        Item {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: childrenRect.height

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    statusRadioGroup.select(model.type);
                                    var icon = window.accountItem.data(AccountsModel.IconRole);
                                    var id = window.accountItem.data(AccountsModel.IdRole);
                                    // if the protocol doesn t allow for multiple accounts to be online
                                    // at the same time, we need to ask the user if he wants to disconnect
                                    // the other accounts
                                    if (!protocolsModel.isSingleInstance(icon) ||
                                            accountFactory.otherAccountsOnline(icon, id) == 0 ||
                                            model.type == TelepathyTypes.ConnectionPresenceTypeOffline) {
                                        window.accountItem.setRequestedPresence(model.type, model.status, customMessageBox.text);
                                        window.accountItem.setAutomaticPresence(model.type, model.status, customMessageBox.text);
                                    } else {
                                        contactsScreenPage.requestedStatusType = model.type;
                                        contactsScreenPage.requestedStatus = model.status;
                                        contactsScreenPage.requestedStatusMessage = customMessageBox.text;
                                        confirmAccountLogin();
                                    }
                                }
                            }

                            Row {
                                id: delegateRow
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.leftMargin: 5
                                height: statusRadioButton.height + 5
                                spacing: 10

                                RadioButton {
                                    id: statusRadioButton
                                    value: model.type
                                    group: statusRadioGroup
                                    anchors.verticalCenter: parent.verticalCenter
                                    height: statusText.height
                                    width: height
                                }

                                Text {
                                    id: statusText
                                    anchors.verticalCenter: statusRadioButton.verticalCenter
                                    text: qsTr(model.text)
                                    font.pixelSize: theme_contextMenuFontPixelSize
                                    color: theme_contextMenuFontColor
                                }
                            }
                        }
                    }
                }

                TextEntry {
                    id: customMessageBox
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    defaultText: qsTr("Custom status message");
                    text: window.accountItem.data(AccountsModel.CurrentPresenceStatusMessageRole)
                    onAccepted: {
                        customMessageBox.updateStatus();
                    }

                    function updateStatus()
                    {
                        var status;
                        for(var i = 0; i < statusModel.count; ++i) {
                            if (statusRadioGroup.selectedValue == statusModel.get(i).type) {
                                status = statusModel.get(i).text;
                            }
                        }

                        window.accountItem.setRequestedPresence(statusRadioGroup.selectedValue, status, customMessageBox.text);
                        window.accountItem.setAutomaticPresence(statusRadioGroup.selectedValue, status, customMessageBox.text);
                        currentPage.hideActionMenu();
                    }
                }

                Button {
                    id: updateStatusButton
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Update")
                    textColor: theme_buttonFontColor
                    bgSourceUp: "image://themedimage/widgets/common/button/button-default"
                    bgSourceDn: "image://themedimage/widgets/common/button/button-default-pressed"
                    onClicked: {
                        customMessageBox.updateStatus();
                    }
                }
            }
        }

        MenuItemSeparator { id: updateStatusSeparator }

        MenuItem {
            id: updateNickItem
            text: qsTr("Change display name")
            visible: (showUpdateNick && window.currentAccountStatus == TelepathyTypes.ConnectionStatusConnected)

            property bool showUpdateNick: true

            onClicked: {
                if (nicknameColumn.visible) {
                    updateNickItem.hideUpdateNick();
                } else {
                    nicknameColumn.opacity = 1;
                    avatarImage.visible = false;
                    avatarSeparator.visible = false;
                    statusRow.visible = false;
                    statusMessage.visible = false;
                    statusMessageSeparator.visible = false;
                    statusSeparator.visible = false;
                    updateStatusItem.visible = false;
                    updateStatusSeparator.visible = false;
                    nicknameSeparator.showUpdateNick = false;
                    addIMContactItem.showAddFriend = false;
                    addAFriend.visible = false;
                    friendSeparator.showAddFriend = false;
                    clearHistoryItem.visible = false;
                    historySeparator.visible = false;
                    logOutItem.visible = false;
                    nicknameBox.textInput.forceActiveFocus();
                }
            }

            function hideUpdateNick()
            {
                nicknameColumn.opacity = 0;
                avatarImage.visible = true;
                avatarSeparator.visible = true;
                statusRow.visible = true;
                statusMessage.visible = true;
                statusMessageSeparator.visible = true;
                statusSeparator.visible = true;
                updateStatusItem.visible = true;
                updateStatusSeparator.visible = true;
                nicknameSeparator.showUpdateNick = true;
                addIMContactItem.showAddFriend = true;
                addAFriend.visible = true;
                friendSeparator.showAddFriend = true;
                clearHistoryItem.visible = true;
                historySeparator.visible = true;
                logOutItem.visible = true;
            }
        }

        Item {
            id: updateNick
            height: nicknameColumn.visible ? childrenRect.height + 2 * nicknameColumn.spacing : 0
            width: parent.width

            Timer {
                id: nicknameHideTimer
                interval: 1000
                repeat: false

                onTriggered: {
                    updateNickItem.hideUpdateNick();
                }
            }

            Column {
                id: nicknameColumn
                anchors.top: parent.top
                anchors.topMargin: theme_contextMenuFontPixelSize / 2
                anchors.left: parent.left
                anchors.right: parent.right
                height: childrenRect.height
                spacing: 10
                visible: opacity > 0
                opacity: 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                    }
                }

                onVisibleChanged: {
                    if (visible) {
                        nicknameBox.text = window.accountItem.data(AccountsModel.NicknameRole)
                    }
                }

                TextEntry {
                    id: nicknameBox
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    defaultText: qsTr("Display name")
                    text: window.accountItem.data(AccountsModel.NicknameRole)

                    onAccepted: {
                        updateNickname();
                    }

                    function updateNickname() {
                        if (nicknameBox.text != "") {
                            window.accountItem.setNickname(nicknameBox.text);
                            nicknameHideTimer.start();
                        }
                    }
                }

                Button {
                    id: updateNicknameButton
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Update")
                    textColor: theme_buttonFontColor
                    bgSourceUp: "image://themedimage/widgets/common/button/button-default"
                    bgSourceDn: "image://themedimage/widgets/common/button/button-default-pressed"
                    onClicked: {
                        nicknameBox.updateNickname();
                    }
                }
            }
        }

        MenuItemSeparator {
            id: nicknameSeparator
            visible: (showUpdateNick && window.currentAccountStatus == TelepathyTypes.ConnectionStatusConnected)

            property bool showUpdateNick: true
        }

        MenuItem {
            id: addIMContactItem
            text: qsTr("Add a friend")
            visible: (showAddFriend && window.currentAccountStatus == TelepathyTypes.ConnectionStatusConnected)

            property bool showAddFriend: true

            onClicked: {
                if(addAFriend.opacity == 1) {
                    addAFriend.opacity = 0;
                    addAFriend.resetHelper();
                    avatarImage.visible = true;
                    avatarSeparator.visible = true;
                    statusRow.visible = true;
                    statusMessage.visible = true;
                    statusMessageSeparator.visible = true;
                    statusSeparator.visible = true;
                    updateStatusItem.visible = true;
                    updateStatusSeparator.visible = true;
                    updateNick.visible = true;
                    updateNickItem.showUpdateNick = true;
                    nicknameSeparator.showUpdateNick = true;
                    friendSeparator.showAddFriend = true;
                    clearHistoryItem.visible = true;
                    historySeparator.visible = true;
                    logOutItem.visible = true;
                } else {
                    addAFriend.resetHelper();
                    addAFriend.opacity = 1;
                    avatarImage.visible = false;
                    avatarSeparator.visible = false;
                    statusRow.visible = false;
                    statusMessage.visible = false;
                    statusMessageSeparator.visible = false;
                    statusSeparator.visible = false;
                    updateStatusItem.visible = false;
                    updateStatusSeparator.visible = false;
                    updateNick.visible = false;
                    updateNickItem.showUpdateNick = false;
                    nicknameSeparator.showUpdateNick = false;
                    friendSeparator.showAddFriend = false;
                    clearHistoryItem.visible = false;
                    historySeparator.visible = false;
                    logOutItem.visible = false;
                    addAFriend.textInput.textInput.forceActiveFocus();
                }
            }
        }

        AddAFriend {
            id: addAFriend
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            visible: opacity > 0
            opacity: 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                }
            }
        }

        MenuItemSeparator {
            id: friendSeparator
            visible: (showAddFriend && window.currentAccountStatus == TelepathyTypes.ConnectionStatusConnected)

            property bool showAddFriend: true
        }

        MenuItem {
            id: clearHistoryItem
            text: qsTr("Clear chat history")

            onClicked: {
                accountsModel.clearAccountHistory(window.currentAccountId);
                currentPage.hideActionMenu();
            }
        }

        MenuItemSeparator { id: historySeparator }

        MenuItem {
            id: logOutItem
            text: (window.currentAccountStatus == TelepathyTypes.ConnectionStatusDisconnected?
                       qsTr("Log in") : qsTr("Log out"))

            onClicked: {
                if(window.currentAccountStatus == TelepathyTypes.ConnectionStatusDisconnected) {
                    contactsScreenPage.requestedStatusType = TelepathyTypes.ConnectionPresenceTypeAvailable;
                    contactsScreenPage.requestedStatus = "available"; // i18n ok
                    contactsScreenPage.requestedStatusMessage = window.accountItem.data(AccountsModel.CurrentPresenceStatusMessageRole);

                    var icon = window.accountItem.data(AccountsModel.IconRole);
                    var id = window.accountItem.data(AccountsModel.IdRole);

                    if (!protocolsModel.isSingleInstance(icon) ||
                            accountFactory.otherAccountsOnline(icon, id) == 0) {
                        window.accountItem.setRequestedPresence(contactsScreenPage.requestedStatusType, contactsScreenPage.requestedStatus, customMessageBox.text);
                        window.accountItem.setAutomaticPresence(contactsScreenPage.requestedStatusType, contactsScreenPage.requestedStatus, customMessageBox.text);
                    } else {
                        confirmAccountLogin();
                    }
                    currentPage.hideActionMenu();
                } else {
                    window.accountItem.setRequestedPresence(TelepathyTypes.ConnectionPresenceTypeOffline,
                                                           "offline", // i18n ok
                                                           window.accountItem.data(AccountsModel.CurrentPresenceMessageRole));
                    currentPage.hideActionMenu();
                    window.popPage();
                }
            }
        }
    }

    property QtObject accountHelper : null

    function createAccountHelper() {
        if (accountHelper == null) {
            console.log("Creating AccountHelper");
            var sourceCode = "import Qt 4.7;"
                           + "import MeeGo.App.IM 0.1;"
                           + "import TelepathyQML 0.1;"
                           + "AccountHelper {}";
            accountHelper = Qt.createQmlObject(sourceCode, meTabItem);
        }
    }

    Connections {
        target: photoPicker

        onPhotoSelected: {
            createAccountHelper();
            accountHelper.setAccount(window.accountItem);
            accountHelper.avatar = uri;
            accountFactory.avatarSerial++;
            avatarImage.source = accountHelper.avatar;
        }
    }

    function confirmAccountLogin()
    {
        var serviceName = protocolsModel.titleForId(window.accountItem.data(AccountsModel.IconRole));

        // show the dialog to ask for user confirmation
        confirmationDialogItem.title = qsTr("Multiple accounts connected");
        confirmationDialogItem.text = qsTr("Do you really want to connect this account? By doing this all other %1 accounts will be disconnected.").arg(serviceName);
        confirmationDialogItem.instanceReason = "contact-menu-single-instance"; // i18n ok
        confirmationDialogItem.accountId = window.currentAccountId;
        confirmationDialogItem.show();
    }

    function resetMenu()
    {
        statusMenu.opacity = 0;
        nicknameColumn.opacity = 0;
        addAFriend.opacity = 0;
        avatarImage.visible = true;
        avatarSeparator.visible = true;
        statusRow.visible = true;
        statusMessage.visible = true;
        statusMessageSeparator.visible = true;
        statusSeparator.visible = true;
        updateStatusItem.visible = true;
        updateStatusSeparator.visible = true;
        updateNick.visible = true;
        updateNickItem.showUpdateNick = true;
        nicknameSeparator.showUpdateNick = true;
        addIMContactItem.showAddFriend = true;
        addAFriend.visible = true;
        friendSeparator.showAddFriend = true;
        clearHistoryItem.visible = true;
        historySeparator.visible = true;
        logOutItem.visible = true;
    }
}
