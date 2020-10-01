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
    id: messageScreenPage
    anchors.fill: parent
    enableCustomActionMenu: true

    property string contactId: window.currentContactId
    property string contactName: (window.contactItem != undefined? window.contactItem.data(AccountsModel.AliasRole) : "")

    Component.onCompleted: {
        notificationManager.chatActive = true;
        openingChatInfo.show()
        initPage();
    }

    Component.onDestruction: {
        if(window.chatAgent != undefined && !window.chatAgent.isConference) {
            accountsModel.disconnectConversationModel(window.currentAccountId,
                                                      contactId);
        } else {
            accountsModel.disconnectGroupConversationModel(window.currentAccountId,
                                                           window.chatAgent.channelPath);
        }

        if(window.callAgent != undefined) {
            window.callAgent.setOutgoingVideo(null);
            window.callAgent.setIncomingVideo(null);
        }
        notificationManager.chatActive = false;
    }

    onActionMenuIconClicked: {
        messageContentMenu.setPosition( mouseX, mouseY);
        messageContentMenu.show();
    }

    // small trick to reload the data() role values when the item changes
    Connections {
        target: window.contactItem
        onChanged: window.contactItem = window.contactItem
    }

    Connections {
        target: accountsModel
        onChatReady:  {
            if (accountId == window.currentAccountId && contactId == window.currentContactId) {
                setupDataFromChatAgent();
            }
        }

        onGroupChatReady:  {
            if (accountId == window.currentAccountId && channelPath == window.chatAgent.channelPath) {
                setupDataFromChatAgent();
            }
        }
    }

    Connections {
        id: callAgentConnections
        target: null
        onCallStatusChanged: {
            // Several sounds might play at once here. Should be prioritize, make a queue, or let them all play ?
            if (window.callAgent.callStatus == CallAgent.CallStatusNoCall) {
                window.fullScreen = false;
                window.fullContent = false;
                var videoWindow = messageScreenPage.getVideoWindow();
                videoWindow.opacity = 0;
                messageScreenPage.unloadVideoWindow();
            }
            // activate call ringing
            if(window.callAgent.callStatus == CallAgent.CallStatusRinging) {
                window.playOutgoingCallSound();
            } else {
                window.stopLoopedSound();
            }
            // connection established
            if (window.callAgent.callStatus == CallAgent.CallStatusTalking) {
                window.playConnectedCallSound();
            }
            if (window.callAgent.callStatus == CallAgent.CallStatusHangingUp) {
                window.playHangUpCallSound();
            }
            if (window.callAgent.error) {
                window.playErrorSound();
                // do not clear error on purpose, so other components do not miss it;
                // we might see the error twice, and cannot really tell if it is the same error or not,
                // but we don't really care as we'd just play the error sound twice,
                // which is not a bad idea if the error state persists anyway
            }
        }
    }

    Connections {
        target: window
        onSearch: {
            // only search if the message screen is active
            if (notificationManager.chatActive) {
                conversationView.model.searchByString(needle);
                searchHeader.searchActive = (needle != "");
            }
        }
    }

    Connections {
        id: conversationModelConnections
        target: null

        onCurrentRowMatchChanged: {
            conversationView.positionViewAtIndex(conversationView.model.currentRowMatch, ListView.Center);
        }

        onBackFetchable: {
            if (conversationView.model.canFetchMoreBack()) {
                historyFeeder.running = true;
            }
        }
        onBackFetched: {
            historyFeeder.fetching = false;
            if (historyFeeder.oldIndex != -1) {
                conversationView.positionViewAtIndex(historyFeeder.oldIndex + numItems, ListView.Beginning);
            } else {
                conversationView.positionViewAtIndex(0, ListView.End);
            }

            if (!conversationView.model.canFetchMoreBack()) {
                historyFeeder.running = false;
            }
        }
    }

    Item {
        id: pageContent
        parent: messageScreenPage
        anchors.fill: parent
        // if the messages roll over the main bar, uncomment this line to
        // force clipping
        //clip: true

        SearchHeader {
            id: searchHeader
            searchActive: window.showToolBarSearch
            searching: conversationView.model != undefined ? conversationView.model.searching : false
            olderActive : conversationView.model != undefined ? conversationView.model.olderActive : false
            newerActive : conversationView.model != undefined ? conversationView.model.newerActive : false
            numMatchesFound: conversationView.model != undefined ? conversationView.model.numMatchesFound : 0
            onOlderClicked: {
                conversationView.model.olderMatch();
            }
            onNewerClicked: {
                conversationView.model.newerMatch();
            }
        }

        NoNetworkHeader {
            id: noNetworkItem
            anchors.top: searchHeader.bottom
        }

        InfoBar {
            id: openingChatInfo
            text: qsTr("Opening chat...")

            anchors {
                top: noNetworkItem.top
                left: parent.left
                right: parent.right
            }
        }

        InfoBar {
            id: loadingConversation
            text: qsTr("Loading conversation history...")
            z: 10
            anchors {
                top: openingChatInfo.bottom
                left: parent.left
                right: parent.right
            }
        }

        Component {
            id: sectionDateDelegate
            Item {
                width: conversationView.width
                height: 50

                Text {
                    id: dateText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: theme_fontColorHighlight
                    font.pixelSize: theme_fontPixelSizeLarge
                    //verticalAlignment: Text.AlignVCenter
                    //horizontalAlignment: Text.AlignHCenter
                    text: section
                }

                Image {
                    anchors.top: dateText.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "image://themedimage/images/dialog-separator"
                }
            }
        }

        ListView {
            id: conversationView
            anchors {
                top: loadingConversation.bottom
                left: parent.left
                right: parent.right
                bottom: window.fullScreen ? imToolBar.top : textBar.top
                margins: 10
            }

            delegate: MessageDelegate { }
            highlightFollowsCurrentItem: true
            currentIndex: count - 1
            clip: true

            section.property : "dateString"
            section.criteria : ViewSection.FullString
            section.delegate : sectionDateDelegate

            interactive: contentHeight > height

            onCountChanged: {
                window.playIncomingMessageSound();
            }
        }

        /*
          Timer used to feed history from the logger at the beginning of the view
        */
        Timer {
            id: historyFeeder
            interval: 1000
            running: false
            repeat: true

            property bool fetching : false
            property int oldIndex : -1

            onTriggered: {
                if (conversationView.atYBeginning) {
                    if (!fetching && conversationView.model.canFetchMoreBack()) {
                        fetching = true;
                        oldIndex = 0;
                        conversationView.model.fetchMoreBack();
                    }
                }
            }

            onFetchingChanged: {
                if (fetching) {
                    loadingConversation.show();
                } else {
                    loadingConversation.hide();
                }
            }
        }

        Image {
            id: textBar
            source: "image://themedimage/widgets/common/action-bar/action-bar-background"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: imToolBar.top
            height: textBox.height
            visible: !window.fullScreen

            Item {
                id: textBox
                anchors.left: parent.left
                anchors.right: sendMessageButton.left
                anchors.rightMargin: 5

                height: textEdit.height + 2 * textEdit.anchors.margins

                TextField {
                    id: textEdit
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 10
                    textFormat: Text.RichText
                    font.pixelSize: theme_fontPixelSizeLarge
                    height: contentHeight + 2 * anchors.margins
                    enabled: (conversationView.model != undefined? true : false)
                    Keys.onEnterPressed: {
                        if(parseChatText(textEdit.text) != "") {
                            conversationView.model.sendMessage(parseChatText(textEdit.text));
                            textEdit.text = "";
                        }
                    }
                    Keys.onReturnPressed: {
                        if(parseChatText(textEdit.text) != "") {
                            conversationView.model.sendMessage(parseChatText(textEdit.text));
                            textEdit.text = "";
                        }
                    }

                    function isEmpty() {
                        var parsedText = messageScreenPage.parseChatText(textEdit.text);
                        return (parsedText.trim() == "");
                    }
                }
            }

            Button {
                id: sendMessageButton
                visible: !window.fullScreen
                anchors {
                    margins: 10
                    right: parent.right
                    verticalCenter: textBox.verticalCenter
                    topMargin: 0
                }
                height: 40
                text: qsTr("Send")
                textColor: theme_buttonFontColor

                onClicked: {
                    if(!textEdit.isEmpty()) {
                        conversationView.model.sendMessage(parseChatText(textEdit.text));
                        textEdit.text = "";
                    }
                }
            }
        }

        Component {
            id: videoWindowComponent
            VideoWindow {
                id: videoWindow
                pageContentItem: pageContent
                toolBarHeight: imToolBar.height
                parent: messageScreenPage
            }
        }

        Loader {
            id: videoWindowLoader
        }

        IMToolBar {
            id: imToolBar
            parent: pageContent

            onChatTextEnterPressed: {
                if(textEdit.text != "") {
                    conversationView.model.sendMessage(parseChatText(textEdit.text));
                    textEdit.text = "";
                }
            }

            onSmileyClicked: {
                // save the cursor position
                var position = textEdit.cursorPosition;
                textEdit.text = textEdit.text + "<img src=\"" + sourceName + "\" >";

                // give the focus back to the text editor
                textEdit.focus = true;
                textEdit.cursorPosition = position + 1;
            }
        }
    }

    ContextMenu {
        id: messageContentMenu

        width: 200
        forceFingerMode: 2

        onVisibleChanged: {
            actionMenuOpen = visible
        }

        content: MessageContentMenu {
            currentPage: messageScreenPage;
        }
    }

    function parseChatText(message)
    {
        var parsedMessage;

        // first remove the head
        var index = message.indexOf("</head>");
        parsedMessage = message.substr(index + 8, message.length);

        // remove the body tag
        index = parsedMessage.indexOf(">");
        parsedMessage = parsedMessage.substr(index + 1, message.length);

        // remove the end body tag
        index = parsedMessage.indexOf("</body>");
        parsedMessage = parsedMessage.substr(0, index);

        // remove paragraph tag
        index = parsedMessage.indexOf(">");
        parsedMessage = parsedMessage.substr(index + 1, message.length);

        //remove end paragraph tag
        index = parsedMessage.indexOf("</p>");
        parsedMessage = parsedMessage.substr(0, index);

        //recurse as long as there is an image to replace

        while(parsedMessage.indexOf("<img") > -1) {
            var imgIndex = parsedMessage.indexOf("<img");
            var srcIndex = parsedMessage.indexOf("src");
            var endIndex = parsedMessage.indexOf("/>");

            var emoticonName = parsedMessage.substr(srcIndex + 5, parsedMessage.length);
            emoticonName = emoticonName.substr(0, emoticonName.indexOf("/>") - 6);

            var nameIndex = emoticonName.indexOf("emote-");
            emoticonName = emoticonName.substr(nameIndex + 6, emoticonName.length);

            //replace the image name with ascii chars
            var asciiEmo;
            if(emoticonName == "angry") {
                asciiEmo = ":-&";
            } else if (emoticonName == "confused") {
                asciiEmo = ":-S";
            } else if (emoticonName == "embarressed") {
                asciiEmo = ":-[";
            } else if (emoticonName == "happy") {
                asciiEmo = ":-)";
            } else if (emoticonName == "love") {
                asciiEmo = "<3";
            } else if (emoticonName == "sad") {
                asciiEmo = ":'(";
            } else if (emoticonName == "star") {
                asciiEmo = "(*)";
            } else if (emoticonName == "tired") {
                asciiEmo = "|-(";
            } else if (emoticonName == "wink") {
                asciiEmo = ";-)";
            }

            parsedMessage = parsedMessage.substr(0, imgIndex) + asciiEmo + parsedMessage.substr(endIndex + 2);
        }

        while(parsedMessage.indexOf("&lt;") > -1) {
            var ltIndex = parsedMessage.indexOf("&lt;");
            parsedMessage = parsedMessage.substr(0, ltIndex) + "<" + parsedMessage.substr(ltIndex + 4);
        }

        while(parsedMessage.indexOf("&gt;") > -1) {
            var ltIndex = parsedMessage.indexOf("&gt;");
            parsedMessage = parsedMessage.substr(0, ltIndex) + ">" + parsedMessage.substr(ltIndex + 4);
        }

        while(parsedMessage.indexOf("&amp;") > -1) {
            var ltIndex = parsedMessage.indexOf("&amp;");
            parsedMessage = parsedMessage.substr(0, ltIndex) + "&" + parsedMessage.substr(ltIndex + 5);
        }

        while(parsedMessage.indexOf("&quot;") > -1) {
            var ltIndex = parsedMessage.indexOf("&quot;");
            parsedMessage = parsedMessage.substr(0, ltIndex) + "\"" + parsedMessage.substr(ltIndex + 6);
        }

        return parsedMessage;
    }

    function hideActionMenu()
    {
        messageContentMenu.hide();
    }

    function closeConversation()
    {
        // assuming we need to end the chat session when close is pressed
        if (window.chatAgent.isConference) {
            accountsModel.endChat(window.currentAccountId, window.chatAgent.channelPath);
        } else {
            accountsModel.endChat(window.currentAccountId, contactId);
        }

        if (window.callAgent != undefined) {
            window.callAgent.endCall();
        }

        window.popPage();
    }

    function loadVideoWindow()
    {
        if (videoWindowLoader.item == null) {
            videoWindowLoader.sourceComponent = videoWindowComponent;
        }
    }

    function unloadVideoWindow()
    {
        videoWindowLoader.sourceComponent = undefined;
    }

    function getVideoWindow() {
        return videoWindowLoader.item;
    }

    function setupDataFromChatAgent()
    {
        if(window.chatAgent != undefined && window.chatAgent.existsChat) {
            if (window.chatAgent.isConference) {
                pageTitle = qsTr("Group conversation");
                conversationView.model = accountsModel.groupConversationModel(window.currentAccountId,
                                                                              window.chatAgent.channelPath);
            } else {
                pageTitle = qsTr("Chat with %1").arg(window.contactItem.data(AccountsModel.AliasRole));
                conversationView.model = accountsModel.conversationModel(window.currentAccountId,
                                                                         window.currentContactId);
                if (conversationView.model != undefined) {
                    window.fileTransferAgent.setModel(conversationView.model);
                }
            }

            if (conversationView.model != undefined) {
                conversationView.positionViewAtIndex(conversationView.count - 1, ListView.End);
                conversationModelConnections.target = conversationView.model;
                textEdit.focus = true;
                if(openingChatInfo.height > 0) {
                    openingChatInfo.hide();
                }
            }
            // FIXME: do this until the bug in pageTitle update is fixed
            window.toolBarTitle = pageTitle;
        }
    }

    function initPage()
    {
        if (window.chatAgent != undefined) {
            setupDataFromChatAgent();
        } else {
            if(openingChatInfo.height == 0) {
                openingChatInfo.show()
            }
        }

        if (window.callAgent != undefined) {
            callAgentConnections.target = window.callAgent;
            var status = window.callAgent.callStatus;
            if (status != CallAgent.CallStatusNoCall) {
                messageScreenPage.loadVideoWindow();
                var videoWindow = messageScreenPage.getVideoWindow();
                videoWindow.opacity = 1;
                window.callAgent.setOutgoingVideo(videoWindow.cameraWindowSmall ? videoWindow.videoOutgoing : videoWindow.videoIncoming);
                window.callAgent.onOrientationChanged(window.orientation);
                window.callAgent.setIncomingVideo(videoWindow.cameraWindowSmall ? videoWindow.videoIncoming : videoWindow.videoOutgoing);
            }
            window.callAgent.resetMissedCalls();
        }
    }
}
