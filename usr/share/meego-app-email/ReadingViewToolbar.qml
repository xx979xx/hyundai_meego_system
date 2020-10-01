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
    id: container

    height: navigationBar.height
    width: window.content.width

    property int buttonWidth: (parent.width - 4) / 5

    ListModel {
        id: toModel
    }

    ListModel {
        id: ccModel
    }

    ListModel {
        id: attachmentsModel
    }

    ModalDialog {
        id:verifyDelete
        showCancelButton: true
        showAcceptButton: true
        acceptButtonText: qsTr("OK")
        cancelButtonText: qsTr("Cancel")
        title: qsTr ("Delete Email")
        content: Item {
            id:confirmMsg
            anchors.fill: parent
            anchors.margins: 10

            Text {
                text: qsTr ("Are you sure you want to delete this email?")
                color:theme.fontColorNormal
                font.pixelSize: theme.fontPixelSizeLarge
                wrapMode: Text.Wrap
            }
        }
        onAccepted: {
            emailAgent.deleteMessage (window.mailId);
            window.popPage();
        }
    }

    function deleteMessage()
    {
        emailAgent.deleteMessage (window.mailId);
        window.popPage();
    }

    function setMessageDetails (composer, messageID, replyToAll) {
        var dateline = qsTr ("On %1 %2 wrote:").arg(messageListModel.timeStamp (messageID)).arg(messageListModel.mailSender (messageID));

        if (window.mailHtmlBody != "")
        {
            window.composeInTextMode = false;
            composer.quotedBody = "<DIV CONTENTEDITABLE><br><br></DIV>"
            composer.quotedBody += "<p>" + dateline + "</p>\n";
            composer.quotedBody += "<blockquote style=\"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;\">\n";
            composer.quotedBody += messageListModel.htmlBody(messageID) + "\n</blockquote>\n";
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

    BorderImage {
        id: navigationBar
        width: parent.width
        source: "image://themedimage/widgets/common/action-bar/action-bar-background"
    }
    Item  {
        anchors.left: parent.left
        width: parent.width

        Item {
            id: composeButton
            width: (parent.width - 4) / 5

            ToolbarButton {
                anchors.horizontalCenter: composeButton.horizontalCenter
                iconName: "mail-compose"
                onClicked: {
                    var newPage;
                    window.composeInTextMode = true;    // default to text mode.
                    window.addPage (composer);
                    newPage = window.pageStack.currentPage;
                    attachmentsModel.clear();
                    newPage.composer.attachmentsModel = attachmentsModel;
                }
            }
        }
        Image {
            id: separator1
            anchors.left: composeButton.right
            source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
        }

        Item {
            id: replyButton
            anchors.left: separator1.right
            width: (parent.width - 4) / 5
            ToolbarButton {
                anchors.horizontalCenter: replyButton.horizontalCenter
                iconName: "mail-reply"
                onClicked: {
                    var newPage;

                    window.addPage (composer);
                    newPage = window.pageStack.currentPage;
                    setMessageDetails (newPage.composer, window.currentMessageIndex, false);

		}
	    }
        }

        Image {
            id: separator2
            anchors.left: replyButton.right
            source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
        }

        Item {
            id:replyallButton
            anchors.left: separator2.right
            width: (parent.width - 4) / 5
            ToolbarButton {
                anchors.horizontalCenter: replyallButton.horizontalCenter
                iconName: "mail-reply-all"
                onClicked: {
                    var newPage;

                    window.addPage (composer);
                    newPage = window.pageStack.currentPage;
                    setMessageDetails (newPage.composer, window.currentMessageIndex, true);
                }
            }
        }

        Image {
            id: separator3
            anchors.left: replyallButton.right
            source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
        }

        Item {
            id:forwardButton
            anchors.left: separator3.right
            width: (parent.width - 4) / 5
            ToolbarButton {
                anchors.horizontalCenter: forwardButton.horizontalCenter
                iconName: "mail-forward"
                onClicked: {
                    var newPage;

                    window.addPage (composer);
                    newPage = window.pageStack.currentPage;

                    if (window.mailHtmlBody != "")
                    {
                        window.composeInTextMode = false;
                        newPage.composer.quotedBody = "<DIV CONTENTEDITABLE><br><br></DIV>"
                        newPage.composer.quotedBody += "<p>" + qsTr("-------- Forwarded Message --------") + "</p>\n";
                        newPage.composer.quotedBody += "<blockquote style=\"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;\">\n";
                        newPage.composer.quotedBody += window.mailHtmlBody + "\n</blockquote>\n";
                    }
                    else
                    {
                        window.composeInTextMode = true;
                        newPage.composer.quotedBody = "\n" + qsTr("-------- Forwarded Message --------") + 
                                                messageListModel.quotedBody (window.currentMessageIndex);
                    }

                    newPage.composer.subject = qsTr("[Fwd: %1]").arg(messageListModel.subject (window.currentMessageIndex));
                    newPage.composer.attachmentsModel = mailAttachmentModel;
                }
            }
        }

        Image {
            id: separator4
            anchors.left: forwardButton.right
            source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
        }

        Item {
            id: deleteButton
            anchors.left: separator4.right
            width: (parent.width - 4) / 5
            ToolbarButton {
                anchors.horizontalCenter: deleteButton.horizontalCenter
                iconName: "edit-delete"

                onClicked: {
                    if (emailAgent.confirmDeleteMail()) {
                        verifyDelete.show();
                    } else {
                        deleteMessage();
                    }
                }
            }
        }
    }
}
