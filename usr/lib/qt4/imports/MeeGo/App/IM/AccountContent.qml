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

Column {
    id: mainArea
    anchors.left:  parent.left
    anchors.right: parent.right
    anchors.margins: 10
    height: childrenRect.height
    spacing: 10

    property int animationDuration: 100
    property alias contentGrid: contentGrid

    move: Transition {
        NumberAnimation {
            properties: "y"
            duration: mainArea.animationDuration
        }
    }

    add: Transition {
        NumberAnimation {
            properties: "opacity"
            duration: mainArea.animationDuration
        }
    }

    property QtObject accountHelper : null
    property string connectionManager
    property string protocol
    property string icon
    property string accountId: ""
    property variant accountItem: null
    property string serviceName: protocolsModel.titleForId(icon)

    property alias advancedOptionsComponent: advancedOptions.sourceComponent
    property alias advancedOptionsItem: advancedOptions.item

    property bool edit: accountId != ""

    property bool duplicated: false
    property string oldLogin: ""

    signal aboutToCreateAccount()
    signal aboutToEditAccount()
    signal finished()
    signal accountCreationAborted()

    onDuplicatedChanged: {
        if (((accountError.connectionStatus == TelepathyTypes.ConnectionStatusDisconnected) &&
            ((accountError.connectionStatusReason == TelepathyTypes.ConnectionStatusReasonAuthenticationFailed) ||
             (accountError.connectionStatusReason == TelepathyTypes.ConnectionStatusReasonNameInUse)))
              || duplicated) {
            accountError.show();
        } else {
            accountError.hide();
        }
    }

    Component.onCompleted: {
        console.log("AccountContent completed " + parent);
    }

    function createAccountHelper() {
        if (accountHelper == null) {
            console.log("Creating AccountHelper");
            var sourceCode = "import Qt 4.7;"
                           + "import TelepathyQML 0.1;"
                           + "AccountHelper {"
                           + "    onAccountSetupFinished: { mainArea.finished(); }"
                           + "}";
            accountHelper = Qt.createQmlObject(sourceCode, mainArea);
            accountHelper.connectionManager = mainArea.connectionManager;
            accountHelper.protocol = mainArea.protocol;
            accountHelper.icon = mainArea.icon;
            accountHelper.model = accountsModel;
            console.log("connectionManager = " + connectionManager);
            console.log("protocol = " + protocol);
            console.log("icon = " + icon);
            console.log("model = " + accountsModel);
        }
    }

    Connections {
        target: confirmationDialogItem
        onAccepted: {
            if (confirmationDialogItem.instanceReason != "account-setup-single-instance") {
                return;
            }
            var currentAccount = (edit ? accountId : "");
            if (confirmationDialogItem.accountId != currentAccount) {
                return;
            }

            // if the dialog was accepted we should disconnect all other accounts
            // of the same type
            accountFactory.disconnectOtherAccounts(icon, currentAccount);

            // and finally create the account
            accountHelper.createAccount();
        }
        onRejected: {
            if (confirmationDialogItem.instanceReason != "account-setup-single-instance") {
                return;
            }

            // ask the account helper not to connect the account
            accountHelper.connectAfterSetup = false;

            // and create the account
            accountHelper.createAccount();
        }
    }

    function createAccount() {
        // emit the aboutToCreate signal so that accounts that need proper setup
        accountHelper.displayName = loginBox.text;
        accountHelper.password = passwordBox.text;
        aboutToCreateAccount();

        if (accountsModel !== null && accountsModel.isAccountRegistered(connectionManager, protocol, loginBox.text)
            && oldLogin != loginBox.text) {
            duplicated = true;
            accountCreationAborted();
            loginBox.focus = true;
            return;
        }

        // check if the service allows for more than one account to be used at the same time
        if (protocolsModel.isSingleInstance(icon)) {
            // check if there is any other account of type online
            var currentAccount = (edit ? accountId : "")
            if (accountFactory.otherAccountsOnline(icon, currentAccount) > 0) {
                // TODO: show the dialog asking if the other accounts should be signed off
                confirmationDialogItem.instanceReason = "account-setup-single-instance"; // i18n ok
                confirmationDialogItem.title = qsTr("Multiple accounts connected");
                confirmationDialogItem.text = qsTr("Do you really want to connect this account? By doing this all other %1 accounts will be disconnected.").arg(serviceName);
                confirmationDialogItem.accountId = currentAccount;
                confirmationDialogItem.show();
                return;
            }
        }

        // and then creates the real account
        accountHelper.createAccount();
        accountItem = accountsModel.accountItemForId(accountId);
    }

    function removeAccount() {
        // just ask the account helper to remove the account
        accountHelper.removeAccount();
    }

    function prepareAccountEdit()
    {
        accountItem = accountsModel.accountItemForId(accountId);
        loginBox.text = accountItem.data(AccountsModel.DisplayNameRole);
        oldLogin = loginBox.text
        createAccountHelper();
        accountHelper.setAccount(accountItem);
        passwordBox.text = accountHelper.password;

        aboutToEditAccount();
    }

    function wrapUndefined(value, type)
    {
        if (typeof(value) == 'undefined') {
            if (type == "string")
                return "";
            else if (type == "number")
                return 0;
            else if (type == "bool")
                return false;
        }
        return value;
    }

    InfoBar {
        id: accountError

        property int connectionStatus: (accountItem != undefined) ? accountItem.data(AccountsModel.ConnectionStatusRole) : TelepathyTypes.ConnectionStatusDisconnected
        property int connectionStatusReason: (accountItem != undefined) ? accountItem.data(AccountsModel.ConnectionStatusReasonRole) : TelepathyTypes.ConnectionStatusReasonNoneSpecified

        Connections {
            target: (accountItem != undefined) ? accountItem : null
            onConnectionStatusChanged: {
                accountError.connectionStatus = accountItem.data(AccountsModel.ConnectionStatusRole);
                accountError.connectionStatusReason = accountItem.data(AccountsModel.ConnectionStatusReasonRole);
            }
        }

        enabled: accountItem !== null

        // TODO: check for another reasons
        onConnectionStatusChanged: {
            if (((connectionStatus == TelepathyTypes.ConnectionStatusDisconnected) &&
                ((connectionStatusReason == TelepathyTypes.ConnectionStatusReasonAuthenticationFailed) ||
                 (connectionStatusReason == TelepathyTypes.ConnectionStatusReasonNameInUse)))
                  || duplicated) {
                accountError.show();
            } else {
                accountError.hide();
            }
        }

        text: duplicated ?
                  qsTr("There is already an account configured using this login. Please check your username.") :
                  qsTr("Sorry, there was a problem logging in. Please check your username and password.")
    }

    Grid {
        id: contentGrid
        columns: 2

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        spacing: 10

        Text {
            id: loginLabel
            anchors.margins: 10
            text: qsTr("Username:")
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            height: loginBox.height
        }

        TextEntry {
            id: loginBox
            anchors.margins: 10
            width: parent.width / 2
            inputMethodHints: Qt.ImhNoAutoUppercase
            defaultText: qsTr("Name / ID")

            onTextChanged: duplicated = false
        }

        Text {
            id: passwordLabel
            anchors.margins: 10
            text: qsTr("Password:")
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            height: passwordBox.height
        }

        TextEntry {
            id: passwordBox
            anchors.margins: 10
            width: parent.width / 2
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhHiddenText
            defaultText: qsTr("Password")
        }
    }

    BorderImage {
        id: advancedHandler
        source: "image://themedimage/widgets/common/header/header"

        property bool expanded: false
        anchors.left: parent.left
        anchors.right: parent.right
        height: 32

        visible: false

        Text {
            id: advancedOptionsLabel
            text: qsTr("Advanced settings")
            anchors.margins: 10
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            font.bold: true
            color: theme_fontColorHighlight
        }

        Image {
            id: arrowIcon
            source: "image://themedimage/images/panels/pnl_icn_arrow" + (advancedHandler.expanded ? "right" : "down")

            anchors.topMargin: 5
            anchors.bottomMargin: 5
            anchors.rightMargin: 15
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            smooth: true
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            onClicked: {
                advancedHandler.expanded = !advancedHandler.expanded;
            }
        }
    }

    Item {
        id: advancedOptionsContainer
        height: visible ? childrenRect.height : 0
        anchors.left: parent.left
        anchors.right: parent.right
        visible: opacity != 0
        opacity: advancedHandler.expanded ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: mainArea.animationDuration
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: mainArea.animationDuration
            }
        }

        Loader {
            id: advancedOptions
            anchors.left: parent.left
            anchors.right: parent.right

        }
    }

    states: [
        State {
            name: "editState"
            when: accountId != ""
            PropertyChanges {
                target: advancedHandler
                // the advanced options are only available to some accounts
                visible: advancedOptionsComponent != null
            }

            StateChangeScript {
                name: "prepareEdit"
                script: mainArea.prepareAccountEdit();
            }
        }
    ]
}
