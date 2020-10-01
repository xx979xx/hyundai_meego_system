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

Window {
    id: window

    toolBarTitle: qsTr("Chat")
    fullScreen: true
    customActionMenu: true
    automaticBookSwitching: false
    disableToolBarSearch: false

    property int animationDuration: 250

    property string currentAccountId: ""
    property int    currentAccountStatus: -1 // will get filled when accountItem gets filled
    property string currentAccountName: "" // will get filled when accountItem gets filled
    property variant accountItem
    property variant contactItem
    property variant callAgent
    property variant fileTransferAgent
    property variant chatAgent
    property variant incomingContactItem
    property variant incomingCallAgent
    property variant currentPage
    property string cmdCommand: ""
    property string cmdAccountId: ""
    property string cmdContactId: ""
    property variant accountFilterModel: [ ]

    property QtObject contactsScreenContent: null
    property string contactsScreenContentString: ""

    property QtObject messageScreenContent: null
    property string messageScreenContentString: ""

    property QtObject contactPickerContent: null
    property string contactPickerContentString: ""

    // this property will be set right before opening the conversation screen
    // TODO: check how can we do that on group chat
    property string currentContactId: ""

    signal componentsLoaded

    Component {
       id: accountScreenContent
        AccountScreenContent {
            id: accountScreenItem
            anchors.fill: parent
        }
    }

    FuzzyDateTime {
        id: fuzzyDateTime
    }

    Timer {
        id: fuzzyDateTimeUpdater
        interval: /*1 */ 60 * 1000 // 1 min
        repeat: true
        running: true
    }

    onCurrentAccountIdChanged: {
        contactsModel.filterByAccountId(currentAccountId);
        contactRequestModel.filterByAccountId(currentAccountId);
        accountItem = accountsModel.accountItemForId(window.currentAccountId);
        currentAccountStatus = accountItem.data(AccountsModel.ConnectionStatusRole);
        currentAccountName = accountItem.data(AccountsModel.DisplayNameRole);
        notificationManager.currentAccount = currentAccountId;
        accountItemConnections.target = accountItem;
    }

    onCurrentContactIdChanged: {
        notificationManager.currentContact = currentContactId;
    }

    onIsActiveWindowChanged: {
        notificationManager.applicationActive = isActiveWindow;
    }

    Component.onCompleted: {
        buildComponentStrings();
        notificationManager.applicationActive = isActiveWindow;
        switchBook(accountScreenContent);
    }

    onBookMenuTriggered: {
        if(bookMenuPayload[index] != "") {
            currentAccountId = bookMenuPayload[index];
            accountItem = accountsModel.accountItemForId(currentAccountId);
            window.switchBook(accountScreenContent);
            componentsLoaded();
            window.addPage(contactsScreenContent);
        } else {
            window.switchBook(accountScreenContent);
            componentsLoaded();
        }
    }

    Connections {
        target:  null;
        id: accountItemConnections

        onChanged: {
            currentAccountStatus = accountItem.data(AccountsModel.ConnectionStatusRole);
            currentAccountName = accountItem.data(AccountsModel.DisplayNameRole);
            notificationManager.currentAccount = currentAccountId;
        }
    }

    Connections {
        // this signal is not created yet, so wait till it is, then the target will be set
        // and the connection will be made then.
        target: null;
        id: contactsModelConnections;
        onOpenLastUsedAccount: {
            // If there command line parameters,those take precedence over opening the last
            // used account
            parseWindowParameters(mainWindow.call);
            if(cmdCommand == "") {
                // only open last used account if there are no unread messages
                if (!accountsModel.existingUnreadMessages()
                        && accountId != "") {
                    currentAccountId = accountId;
                    accountItem = accountsModel.accountItemForId(window.currentAccountId);
                    currentAccountId = accountItem.data(AccountsModel.IdRole);
                    showContactsScreen();
                }
            } else {
                if(cmdCommand == "show-chat" || cmdCommand == "show-contacts") {
                    currentAccountId = cmdAccountId;
                    accountItem = accountsModel.accountItemForId(currentAccountId);

                    if(cmdCommand == "show-chat") {
                        currentContactId = cmdContactId;
                        contactItem = accountsModel.contactItemForId(currentAccountId, currentContactId);
                        startConversation(currentContactId);
                    } else if(cmdCommand == "show-contacts") {
                        addPage(contactsScreenContent);
                    }
                }
            }
        }
    }

    Connections {
        // the onComponentsLoaded signal is not created yet, but we can't use the same trick as the other
        // signals to connect them later since this is the signal that gets used to connect the others.
        // We then choose to ignore the runtime error for just this signal.
        target: accountsModel
        ignoreUnknownSignals: true
        onComponentsLoaded: {
            // the other signals should now be set up, so plug them in
            contactsModelConnections.target = contactsModel;
            accountsModelConnections.target = accountsModel;

            telepathyManager.registerClients();
            reloadFilterModel();
            componentsLoaded();
            buildBookMenuPayloadModel();
        }
    }

    Connections {
        // those signals are not created yet, so wait till they are, then the target will be set
        // and the connections will be made then.
        target: null
        id: accountsModelConnections

        onAccountConnectionStatusChanged: {
            var item = accountsModel.accountItemForId(accountId);
            if(accountId == currentAccountId) {
                contactsModel.filterByAccountId(currentAccountId);
                contactRequestModel.filterByAccountId(currentAccountId);
                accountItem = item;
                currentAccountStatus = accountItem.data(AccountsModel.ConnectionStatusRole);
            }

            // check if there is a connection error and show the config dialog
            var connectionStatus = item.data(AccountsModel.ConnectionStatusRole)
            var connectionStatusReason = item.data(AccountsModel.ConnectionStatusReasonRole)

            if ((connectionStatus == TelepathyTypes.ConnectionStatusDisconnected) &&
                ((connectionStatusReason == TelepathyTypes.ConnectionStatusReasonAuthenticationFailed) ||
                 (connectionStatusReason == TelepathyTypes.ConnectionStatusReasonNameInUse))) {
                window.addPage(accountFactory.componentForAccount(accountId, window));
            }

        }

        onIncomingFileTransferAvailable: {
            if (!notificationManager.chatActive) {
                var oldContactId = currentContactId;
                var oldAccountId = currentAccountId;

                // set the current contact property
                currentContactId = contactId;
                currentAccountId = accountId;
                contactItem = accountsModel.contactItemForId(accountId, contactId);
                callAgent = accountsModel.callAgent(accountId, contactId);
                fileTransferAgent = accountsModel.fileTransferAgent(window.currentAccountId, contactId);
                accountsModel.startChat(window.currentAccountId, contactId);
                chatAgent = accountsModel.chatAgentByKey(window.currentAccountId, contactId);

                window.showMessageScreen();
            }
        }

        onIncomingCallAvailable: {
            window.incomingContactItem = accountsModel.contactItemForId(accountId, contactId);
            window.incomingCallAgent = accountsModel.callAgent(accountId, contactId)
            incomingCallDialog.accountId = accountId;
            incomingCallDialog.contactId = contactId;
            incomingCallDialog.statusMessage = (window.incomingContactItem.data(AccountsModel.PresenceMessageRole) != "" ?
                                            window.incomingContactItem.data(AccountsModel.PresenceMessageRole) :
                                            window.presenceStatusText(window.incomingContactItem.data(AccountsModel.PresenceTypeRole)));
            incomingCallDialog.connectionTarget = window.incomingCallAgent;
            incomingCallDialog.start();
        }

        onRequestedGroupChatCreated: {
            window.chatAgent = agent;

            window.currentContactId = "";
            window.contactItem = undefined;
            window.callAgent = undefined;

            // reuse the existing message screen if possible
            if (notificationManager.chatActive) {
                window.pageStack.currentPage.initPage();
            } else {
                window.showMessageScreen();
            }

            accountsModel.startGroupChat(window.currentAccountId, window.chatAgent.channelPath)
        }

        onAcceptCallFinished: {
            window.fileTransferAgent = accountsModel.fileTransferAgent(window.currentAccountId, window.currentContactId);

            // and start the conversation
            window.showMessageScreen();
            accountsModel.startChat(window.currentAccountId, window.currentContactId);
            chatAgent = agent;
        }

        onPasswordRequestRequired: {
            window.addPage(accountFactory.componentForAccount(accountId, window));
        }

        onDataChanged: {
            reloadFilterModel();
        }

        onAccountCountChanged: {
            buildBookMenuPayloadModel();
        }
    }

    bookMenuModel: accountFilterModel

    function buildComponentStrings()
    {
        // clean it before cosntructing the string
        var contactsComponent = "import Qt 4.7;";
        contactsComponent += "import MeeGo.Components 0.1;";
        contactsComponent += "Component {";
        contactsComponent += "    ContactsScreenContent {";
        contactsComponent += "        id: contactsScreenItem;";
        contactsComponent += "        anchors.fill: parent;";
        contactsComponent += "}   }";
        contactsScreenContentString = contactsComponent;

        var messageComponent = "import Qt 4.7;";
        messageComponent += "Component {";
        messageComponent += "    MessageScreenContent {";
        messageComponent += "        id: messageScreenItem;";
        messageComponent += "        anchors.fill: parent;";
        messageComponent += "}   }";
        messageScreenContentString = messageComponent;

        var contactPicker = "import Qt 4.7;";
        contactPicker += "Component {";
        contactPicker += "    ContactPickerContent {";
        contactPicker += "        id: contactPickerItem;";
        contactPicker += "        anchors.fill: parent;";
        contactPicker += "}    }";
        contactPickerContentString = contactPicker;
    }

    function showContactsScreen()
    {
        if (contactsScreenContent == null) {
            contactsScreenContent = Qt.createQmlObject(contactsScreenContentString, window);
        }

        addPage(contactsScreenContent);
    }

    function showMessageScreen()
    {
        if (messageScreenContent == null) {
            messageScreenContent = Qt.createQmlObject(messageScreenContentString, window);
        }

        addPage(messageScreenContent);
        fastPageSwitch = false;
    }

    function buildBookMenuPayloadModel()
    {
        var payload = new Array();
        for (var i = 0; i < accountsSortedModel.length; ++i) {
            payload[i] = accountsSortedModel.dataByRow(i, AccountsModel.IdRole );
        }
        payload[accountsSortedModel.length] = "";
        bookMenuPayload = payload;
    }

    function startConversation(contactId)
    {
        console.log("window.startConversation: contactId=" + contactId);
        // set the current contact property
        currentContactId = contactId;
        contactItem = accountsModel.contactItemForId(window.currentAccountId, window.currentContactId);
        callAgent = accountsModel.callAgent(window.currentAccountId, contactId);
        fileTransferAgent = accountsModel.fileTransferAgent(window.currentAccountId, contactId);

        // and start the conversation
        if (notificationManager.chatActive) {
            fastPageSwitch = true;
            window.popPage();
        }
        window.showMessageScreen();
        accountsModel.startChat(window.currentAccountId, contactId);
        chatAgent = accountsModel.chatAgentByKey(window.currentAccountId, contactId);
    }

    function startGroupConversation(channelPath)
    {
        console.log("window.startGroupConversation: channelPath=" + channelPath);
        window.currentContactId = "";
        window.contactItem = undefined;
        window.callAgent = undefined;

        window.chatAgent = accountsModel.chatAgentByKey(window.currentAccountId, channelPath);

        // and start the conversation
        if (notificationManager.chatActive) {
            fastPageSwitch = true;
            window.popPage();
        }
        window.showMessageScreen();
        accountsModel.startGroupChat(window.currentAccountId, window.chatAgent.channelPath)
        console.log("window.startGroupConversation: finished");
    }

    function acceptCall(accountId, contactId)
    {
        if (notificationManager.chatActive) {
            fastPageSwitch = true;
            window.popPage();
        }

        // set the current contact property
        window.callAgent = window.incomingCallAgent
        window.callAgent.acceptCall();

        window.currentContactId = contactId;
        window.currentAccountId = accountId;
        window.contactItem = incomingContactItem;
    }

    function startAudioCall(contactId, page)
    {
        // set the current contact property
        currentContactId = contactId;
        contactItem = accountsModel.contactItemForId(window.currentAccountId, window.currentContactId);

        //create the audio call agent
        //the message screen will then get the already created agent
        callAgent = accountsModel.callAgent(window.currentAccountId, contactId);
        fileTransferAgent = accountsModel.fileTransferAgent(window.currentAccountId, contactId);
        accountsModel.startChat(window.currentAccountId, contactId);
        chatAgent = accountsModel.chatAgentByKey(window.currentAccountId, contactId);
        callAgent.audioCall();

        // and start the conversation
        if (notificationManager.chatActive) {
            fastPageSwitch = true;
            window.popPage();
        }
        window.showMessageScreen();
    }

    function startVideoCall(contactId, page)
    {
        // set the current contact property
        currentContactId = contactId;
        contactItem = accountsModel.contactItemForId(window.currentAccountId, window.currentContactId);

        //create the audio call agent
        //the message screen will then get the already created agent
        callAgent = accountsModel.callAgent(window.currentAccountId, contactId);
        fileTransferAgent = accountsModel.fileTransferAgent(window.currentAccountId, contactId);
        accountsModel.startChat(window.currentAccountId, contactId);
        chatAgent = accountsModel.chatAgentByKey(window.currentAccountId, contactId);
        callAgent.videoCall();

        // and start the conversation
        if (notificationManager.chatActive) {
            fastPageSwitch = true;
            window.popPage()
        }
        window.showMessageScreen();
    }

    function pickContacts()
    {
        if (contactPickerContent == null) {
            contactPickerContent = Qt.createQmlObject(contactPickerContentString, window);
        }

        addPage(contactPickerContent);
    }

    function reloadFilterModel()
    {
        // do not do anything if accountsSortedModel is not created yet
        if (typeof(accountsSortedModel) == "undefined")
            return;

        accountFilterModel = [];

        var accountsList = new Array();
        for (var i = 0; i < accountsSortedModel.length; ++i) {
            accountsList[i] = accountsSortedModel.dataByRow(i, AccountsModel.DisplayNameRole);
        }
        accountsList[accountsList.length] = qsTr("Account switcher");
        accountFilterModel = accountsList;
    }

    function presenceStatusText(type)
    {
        if(type == TelepathyTypes.ConnectionPresenceTypeAvailable) {
            return qsTr("Available");
        } else if(type == TelepathyTypes.ConnectionPresenceTypeBusy) {
            return qsTr("Busy");
        } else if(type == TelepathyTypes.ConnectionPresenceTypeAway) {
            return qsTr("Away");
        } else if(type == TelepathyTypes.ConnectionPresenceTypeExtendedAway) {
            return qsTr("Extended away");
        } else if(type == TelepathyTypes.ConnectionPresenceTypeOffline) {
            return qsTr("Offline");
        } else if(type == TelepathyTypes.ConnectionPresenceTypeHidden) {
            return qsTr("Invisible");
        } else {
            return "";
        }
    }

    function parseWindowParameters(parameters)
    {
        // only parse if not empty
        if (parameters.length == 0) {
            return;
        }

        var cmd = parameters[0];
        var cdata = parameters[1];

        if (cmd == "show-chat" || cmd == "show-contacts") {
            cmdCommand = cmd;
            var parsedParameter = cdata;
            if (parsedParameter.indexOf("&") > 0) {
                cmdAccountId = parsedParameter.substr(0, parsedParameter.indexOf("&"));
            } else {
                cmdAccountId = cdata;
            }

            //message type
            if (cmd == "show-chat") {
                //also get the contact id to open a chat with
                cmdContactId = parsedParameter.substr(parsedParameter.indexOf("&") + 1, parsedParameter.length - 1);
            }
        }
    }

    function playIncomingMessageSound()
    {
        playSound("/usr/share/sounds/meego/stereo/chat-fg.wav");
    }

    function playIncomingCallSound()
    {
        playLoopedSound("/usr/share/sounds/meego/stereo/ring-1.wav");
    }

    function playOutgoingCallSound()
    {
        playLoopedSound("/usr/share/sounds/meego/stereo/ring-4.wav");
    }

    function playConnectedCallSound()
    {
        playSound("/usr/share/sounds/meego/stereo/connect.wav");
    }

    function playHangUpCallSound()
    {
        playSound("/usr/share/sounds/meego/stereo/disconnect.wav");
    }

    function playRecordingStartSound()
    {
        playSound("/usr/share/sounds/meego/stereo/rec-start.wav");
    }

    function playRecordingStopSound()
    {
        playSound("/usr/share/sounds/meego/stereo/rec-stop.wav");
    }

    function playErrorSound()
    {
        playSound("/usr/share/sounds/meego/stereo/error.wav");
    }

    function playSound(soundSource)
    {
        console.log("playSound " + soundSource);
        imSoundPlayer.soundSource = soundSource;
        imSoundPlayer.playSound();
    }

    function playLoopedSound(soundSource)
    {
        console.log("playLoopedSound " + soundSource);
        imLoopedSoundPlayer.soundSource = soundSource;
        imLoopedSoundPlayer.playSound();
    }

    function stopLoopedSound()
    {
        if (imLoopedSoundPlayer.soundSource != "") {
            console.log("stopLoopedSound " + imLoopedSoundPlayer.soundSource);
            imLoopedSoundPlayer.stopSound();
            imLoopedSoundPlayer.soundSource = "";
        }
    }

    IMSound {
        id: imSoundPlayer
        repeat: false
    }

    IMSound {
        id: imLoopedSoundPlayer
        repeat: true
    }

    AccountContentFactory {
        id: accountFactory
    }

    IncomingCall {
        id: incomingCallDialog
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ConfirmationDialog {
        id: confirmationDialogItem
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    property alias photoPicker : photoPickerLoader.item

    function createPhotoPicker() {
        if (photoPickerLoader.item == null) {
            console.log("creating PhotoPicker");
            photoPickerLoader.sourceComponent = photoPickerComponent;
        }
    }

    Component {
        id: photoPickerComponent
        PhotoPicker {
            parent: pageStack.currentPage
        }
    }

    Loader {
        id: photoPickerLoader
    }

    property alias videoPicker : videoPickerLoader.item

    function createVideoPicker() {
        if (videoPickerLoader.item == null) {
            console.log("creating VideoPicker");
            videoPickerLoader.sourceComponent = videoPickerComponent;
        }
    }

    Component {
        id: videoPickerComponent
        VideoPicker {
            parent: pageStack.currentPage
        }
    }

    Loader {
        id: videoPickerLoader
    }

    property alias musicPicker : musicPickerLoader.item

    function createMusicPicker() {
        if (musicPickerLoader.item == null) {
            console.log("creating MusicPicker");
            musicPickerLoader.sourceComponent = musicPickerComponent;
        }
    }

    Component {
        id: musicPickerComponent
        MusicPicker {
            selectSongs: true
            parent: pageStack.currentPage
        }
    }

    Loader {
        id: musicPickerLoader
    }

    property QtObject contactsPicker : null

    function createContactsPicker() {
        if (contactsPicker == null) {
            console.log("creating ContactsPicker");
            var sourceCode = "import Qt 4.7;"
                           + "import MeeGo.Labs.Components 0.1 as Labs;"
                           + "Labs.ContactsPicker {"
                           + "  parent: pageStack.currentPage;"
                           + "  promptString: qsTr(\"Select contact\");"
                           + "}";
            contactsPicker = Qt.createQmlObject(sourceCode, pageStack.currentPage);
        }
    }

    property QtObject peopleModel : null

    function createPeopleModel() {
        if (peopleModel == null) {
            console.log("creating PeopleModel");
            var sourceCode = "import Qt 4.7;"
                           + "import MeeGo.App.Contacts 0.1;"
                           + "PeopleModel {}";
            peopleModel = Qt.createQmlObject(sourceCode, window);
        }
    }

    property QtObject appModel : null

    function createAppModel() {
        if (appModel == null) {
            console.log("creating ApplicationsModel");
            var sourceCode = "import Qt 4.7;"
                           + "import MeeGo.Labs.Components 0.1 as Labs;"
                           + "Labs.ApplicationsModel {}";
            appModel = Qt.createQmlObject(sourceCode, window);
        }
    }

}
