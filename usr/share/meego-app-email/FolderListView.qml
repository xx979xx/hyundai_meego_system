/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1
import MeeGo.App.Email 0.1

Item {
    id: folderListContainer
    width: window.width
    parent: folderListView
    anchors.fill: parent

    property string chooseFolder: qsTr("Choose folder:")
    property string renameFolder: qsTr("Rename folder")
    property string deleteFolder: qsTr("Delete folder")
    property string attachments: qsTr("Attachments")
    property bool gettingMoreMessages: false
    property bool inSelectMode: false
    property int numOfSelectedMessages: 0
    property int folderServerCount: 0

    Component.onCompleted: { 
        folderServerCount = mailFolderListModel.folderServerCount(window.currentFolderId);
        window.folderListViewClickCount = 0;
        gettingMoreMessages = false;
    }

    Connections {
        target: emailAgent
        onSyncCompleted: {
            gettingMoreMessages = false;
        }
        onError: {
            gettingMoreMessages = false;
        }
        onRetrievalCompleted: {
            gettingMoreMessages = false;
        }
    }

    ListModel {
        id: toModel
    }

    ListModel {
        id: ccModel
    }

    ListModel {
        id: attachmentsModel
    }

    TopItem {
        id: folderListViewTopItem
    }

    function setMessageDetails (composer, messageID, replyToAll) {
        var dateline = qsTr ("On %1 %2 wrote:").arg(messageListModel.timeStamp (messageID)).arg(messageListModel.mailSender (messageID));

        var htmlBodyText = messageListModel.htmlBody(window.currentMessageIndex);
        if (htmlBodyText != "")
        {
            // set the composer to edit in html mode
            window.composeInTextMode = false;
            composer.quotedBody = "<DIV CONTENTEDITABLE><br><br></DIV>"
            composer.quotedBody += "<p>" + dateline + "</p>\n";
            composer.quotedBody += "<blockquote style=\"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;\">\n";
            composer.quotedBody += htmlBodyText + "\n</blockquote>\n";
        }
        else
        {
            window.composeInTextMode = true;
            composer.quotedBody = "\n" + dateline + "\n" + messageListModel.quotedBody (messageID); //i18n ok
        }

        attachmentsModel.clear();
        composer.attachmentsModel = attachmentsModel;
        toModel.clear();
        toModel.append({"name": "", "email": messageListModel.mailSender(messageID)});
        composer.toModel = toModel;

        
        if (replyToAll == true)
        {
            ccModel.clear();
            var recipients = new Array();
            recipients = messageListModel.recipients(messageID);
            var idx;
            for (idx = 0; idx < recipients.length; idx++)
                ccModel.append({"name": "", "email": recipients[idx]});
            composer.ccModel = ccModel;
        }
        // "Re:" is not supposed to be translated as per RFC 2822 section 3.6.5
        // Internet Message Format - http://www.faqs.org/rfcs/rfc2822.html
        //
        // "If this is done, only one instance of the literal string
        // "Re: " ought to be used since use of other strings or more
        // than one instance can lead to undesirable consequences."
        // Also see: http://www.chemie.fu-berlin.de/outerspace/netnews/son-of-1036.html#5.4
        // FIXME: Also need to only add Re: if it isn't already in the subject
        // to prevent "Re: Re: Re: Re: " subjects.
        composer.subject = "Re: " + messageListModel.subject (messageID);  //i18n ok
    }

    function isDraftFolder()
    {
        return folderListContainer.parent.pageTitle.indexOf( qsTr("Drafts") ) != -1 ;
    }

    ModalDialog {
        id: verifyDelete
        acceptButtonText: qsTr ("Yes")
        cancelButtonText: qsTr ("Cancel")
        title: qsTr ("Delete Email")
        content: Text {
            text: qsTr ("Are you sure you want to delete this email?")
        }

        onAccepted: { emailAgent.deleteMessage (window.mailId) }
    }

    ContextMenu {
        id: contextMenu
        property alias model: contextActionMenu.model
        content: ActionMenu {
            id: contextActionMenu
            onTriggered: {

                contextMenu.hide();
                if (index == 0)  // Reply
                {
                    var newPage;
                    window.addPage (composer);
                    newPage = window.pageStack.currentPage;
                    setMessageDetails (newPage.composer, window.currentMessageIndex, false);
                }
                else if (index == 1)   // Reply to all
                {
                    var newPage;
                    window.addPage (composer);
                    newPage = window.pageStack.currentPage;
                    setMessageDetails (newPage.composer, window.currentMessageIndex, true);
                }
                else if (index == 2)   // Forward
                {
                    var newPage;
                    window.addPage (composer);
                    newPage = window.pageStack.currentPage;

                    var htmlBodyText = messageListModel.htmlBody(window.currentMessageIndex);
                    if (htmlBodyText != "")
                    {
                        window.composeInTextMode = false;
                        newPage.composer.quotedBody = "<DIV CONTENTEDITABLE><br><br></DIV>"
                        newPage.composer.quotedBody += "<p>" + qsTr("-------- Forwarded Message --------") + "</p>\n";
                        newPage.composer.quotedBody += "<blockquote style=\"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;\">\n";
                        newPage.composer.quotedBody += htmlBodyText + "\n</blockquote>\n";
                    }
                    else
                    {
                        window.composeInTextMode = true;
                        newPage.composer.quotedBody = "\n" + qsTr("-------- Forwarded Message --------") + messageListModel.quotedBody (window.currentMessageIndex);
                    }

                    newPage.composer.subject = qsTr("[Fwd: %1]").arg(messageListModel.subject (window.currentMessageIndex));
                    window.mailAttachments = messageListModel.attachments(window.currentMessageIndex);
                    mailAttachmentModel.init();
                    newPage.composer.attachmentsModel = mailAttachmentModel;
                }
                else if (index == 3)   // Delete
                {
                    if ( emailAgent.confirmDeleteMail())
                        verifyDelete.show();
                    else
                        emailAgent.deleteMessage (window.mailId);
                }
                else if (index == 4)   // Mark as read/unread
                {
                    if (window.mailReadFlag)
                    {
                        emailAgent.markMessageAsUnread (window.mailId);
                        window.mailReadFlag = 0;
                    }
                    else
                    {
                        emailAgent.markMessageAsRead (window.mailId);
                        window.mailReadFlag = 1;
                    }
                }
            }
        }
    }

    Item {
        id: emptyMailboxView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: folderListViewToolbar.top
        anchors.top: parent.top
        opacity: messageListView.count > 0 ? 0 : 1
        Text {
            id: noMessageText
            text: qsTr ("There are no messages in this folder.")
            anchors.centerIn: emptyMailboxView
            color:theme.fontColorNormal
            font.pixelSize: theme.fontPixelSizeLarge
            elide: Text.ElideRight
        }
    }

    ListView {
        id: messageListView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: folderListViewToolbar.top
        width: parent.width
        clip: true

        opacity: count > 0 ? 1 : 0

        model: messageListModel

        footer: Rectangle {
            id: getMoreMessageRect
            height: 90
            width: parent.width
            visible: {
                if (messageListView.count < folderServerCount)
                    return true;
                else
                    return false;
            }
            Button {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                height: 45
                width: 300
                text: {
                     if(gettingMoreMessages)
                         return  qsTr("Getting more messages")
                     else
                         return  qsTr("Get more messages")
                }
                onClicked: {
                    gettingMoreMessages = true;
                    emailAgent.getMoreMessages(window.currentFolderId);
                }
            }
        }

        delegate: Rectangle {
            id: dinstance
            height: theme.listBackgroundPixelHeightTwo
            width: parent.width
            Image {
                id: itemBackground
                anchors.fill: parent
                source: {
                    if (inSelectMode)
                    {
                        return selected ? "image://theme/email/bg_unreademail_l" : "image://theme/email/bg_reademail_l";
                    }
                    else
                    {
                        return readStatus ? "image://theme/email/bg_reademail_l" : "image://theme/email/bg_unreademail_l";
                    }
                }
            }

            Image {
                id: readStatusIcon
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: "image://themedimage/widgets/apps/email/email-unread"
                opacity: {
                    if (inSelectMode == true || readStatus == true)
                        return 0;
                    else
                        return 1;
                }
            }

            Image {
                id: selectIcon
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source:"image://themedimage/widgets/common/checkbox/checkbox-background"
                opacity: (inSelectMode == true && selected == 0) ? 1 : 0
            }

            Image {
                id: selectActiveIcon
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source:"image://themedimage/widgets/common/checkbox/checkbox-background-active"
                opacity: (inSelectMode == true && selected == 1) ? 1 : 0
            }

            property string msender
            msender: {
                var a;
                try
                {
                    a = sender ;
                }
                catch(err)
                {
                    a = "";
                }
                a[0] == undefined ? "" : a[0];
            }
           
            Item {
                id: fromLine
                anchors.top: parent.top
                anchors.left: parent.left
                width: parent.width
                height: theme.listBackgroundPixelHeightTwo / 2

                Text {
                    id: senderText
                    anchors.left: parent.left
                    anchors.leftMargin: 50
                    width: (parent.width * 2) / 3
                    text: senderDisplayName != "" ? senderDisplayName : senderEmailAddress
                    font.bold: readStatus ? false : true
                    font.pixelSize: theme.fontPixelSizeNormal
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    elide: Text.ElideRight
                }
                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    font.pixelSize: theme.fontPixelSizeSmall
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    text: fuzzy.getFuzzy(qDateTime);
                }
            }
            Item {
                id: subjectLine
                anchors.top: fromLine.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 50
                width: parent.width
                height: theme.listBackgroundPixelHeightTwo / 2

                Text {
                    id: subjectText
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    text: subject
                    width: (parent.width * 2) / 3
                    font.pixelSize: theme.fontPixelSizeNormal
                    elide: Text.ElideRight
                }
                Image {
                    id: attachmentLeft
                    anchors.right: attachmentMiddle.left
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    source: "image://theme/email/bg_attachment_left"
                    opacity: numberOfAttachments ? 1 : 0
                }
                Image {
                    id: attachmentMiddle
                    anchors.right: attachmentRight.left
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    width: numberOfAttachmentLabel.width + attachmentIcon.width + 1
                    source: "image://theme/email/bg_attachment_mid"
                    Text {
                        id: numberOfAttachmentLabel
                        anchors.verticalCenter: parent.verticalCenter
                        text: numberOfAttachments + " " // i18n ok
                        font.pixelSize: theme.fontPixelSizeNormal
                    }
                    opacity: numberOfAttachments ? 1 : 0
                }
                Image {
                    id: attachmentRight
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    anchors.rightMargin: 5
                    source: "image://theme/email/bg_attachment_right"
                    opacity: numberOfAttachments ? 1 : 0
                }
                Image {
                    id: attachmentIcon
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    height: attachmentMiddle.height
                    anchors.left: attachmentLeft.right
                    anchors.leftMargin: numberOfAttachmentLabel.width + 1
                    source: "image://theme/email/icn_paperclip"
                    z: 10000
                    opacity: numberOfAttachments ? 1 : 0
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (window.folderListViewClickCount == 0)
                    {
                        if (inSelectMode)
                        {
                            if (selected)
                            {
                                messageListModel.deSelectMessage(index);
                                --folderListContainer.numOfSelectedMessages;
                            }
                            else
                            {
                                messageListModel.selectMessage(index);
                                ++folderListContainer.numOfSelectedMessages;
                            }
                        }
                        else
                        {
                            window.mailId = messageId;
                            window.mailSubject = subject;
                            window.mailSender = sender;
                            window.mailTimeStamp = timeStamp;
                            window.mailBody = body;
                            window.mailQuotedBody = quotedBody;
                            window.mailHtmlBody = htmlBody;
                            window.mailAttachments = listOfAttachments;
                            window.numberOfMailAttachments = numberOfAttachments;
                            window.mailRecipients = recipients;
                            toListModel.init();
                            window.mailCc = cc;
                            ccListModel.init();
                            window.mailBcc = bcc;
                            bccListModel.init();
                            window.currentMessageIndex = index;
                            mailAttachmentModel.init();
                            emailAgent.markMessageAsRead (messageId);
                            window.mailReadFlag = true;

                            if ( isDraftFolder() )
                            {   window.editableDraft= true
				window.addPage(composer);
                            }
                            else
                                window.addPage(reader);

                        }
                        window.folderListViewClickCount = 0;
                        return;
                    }
                    window.folderListViewClickCount++;
                }
                onPressAndHold: {
                    if (inSelectMode)
                        return;
                    window.mailId = messageId;
                    window.mailReadFlag = readStatus;
                    window.currentMessageIndex = index;
                    var map = mapToItem(folderListViewTopItem.topItem, mouseX, mouseY);
                    contextMenu.model = [qsTr("Reply"), qsTr("Reply to all"), qsTr("Forward"), qsTr("Delete"), 
                                         readStatus ? qsTr("Mark as unread") : qsTr("Mark as read")]
                    contextMenu.setPosition(map.x, map.y);
                    contextMenu.show();
                }
            }
        }
    }
    FolderListViewToolbar {
        id: folderListViewToolbar

        onEditModeBegin: {
            messageListModel.deSelectAllMessages();
            folderListContainer.inSelectMode = true;
            folderListContainer.numOfSelectedMessages = 0;
        }

        onEditModeEnd: {
            messageListModel.deSelectAllMessages();
            folderListContainer.inSelectMode = false;
        }
    }
}
