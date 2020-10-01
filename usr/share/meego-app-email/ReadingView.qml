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
import QtWebKit 1.0
import Qt.labs.gestures 2.0

Item {
    id: container
    width: parent.width
    parent: readingView
    anchors.fill: parent
    
    property string uri;
    property bool downloadInProgress: false
    property bool openFlag: false
    property string saveLabel: qsTr("Save")
    property string openLabel: qsTr("Open")
    property string musicLabel: qsTr("Music")
    property string videoLabel: qsTr("Video")
    property string pictureLabel: qsTr("Picture")
    property string attachmentSavedLabel: qsTr("Attachment saved.")

    Connections {
        target: messageListModel
        onMessageDownloadCompleted: {
            window.mailHtmlBody = messageListModel.htmlBody(window.currentMessageIndex);
        }
    }

    TopItem { id: topItem }

    ModalDialog {
        id: unsupportedFileFormat
        showCancelButton: false
        showAcceptButton: true
        acceptButtonText: qsTr("Ok")
        title: qsTr ("Warning")
        content: Item {
            anchors.fill: parent
            anchors.margins: 10
            Text {
                text: qsTr("File format is not supported.");
                color: theme.fontColorNormal
                font.pixelSize: theme.fontPixelSizeLarge
                wrapMode: Text.Wrap
            }
        }

        onAccepted: {}
    } 

    ContextMenu {
        id: attachmentContextMenu
        property alias model: attachmentActionMenu.model
        content: ActionMenu {
            id: attachmentActionMenu
        onTriggered: {
            attachmentContextMenu.hide();
            if (index == 0)  // open attachment
            {
                openFlag = true;
                emailAgent.downloadAttachment(messageListModel.messageId(window.currentMessageIndex), uri);
            }
            else if (index == 1) // Save attachment
            {
                openFlag = false;
                emailAgent.downloadAttachment(messageListModel.messageId(window.currentMessageIndex), uri);
            }
        }
        Connections {
            target: emailAgent
            onAttachmentDownloadStarted: {
                downloadInProgress = true;
            }
            onAttachmentDownloadCompleted: {
                downloadInProgress = false;
                if (openFlag == true)
                {
                   var status = emailAgent.openAttachment(uri);
                   if (status == false)
                   {
                       unsupportedFileFormat.show();
                   }
                }
            }
        }
        }
    }  // end of attachmentContextMenu

    Rectangle {
        id: fromRect
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: 43
        Image {
            anchors.fill: parent
            fillMode: Image.Tile
            source: "image://theme/email/bg_email details_l"
        }
        Row {
            spacing: 5
            height: 43
            anchors.left: parent.left
            anchors.leftMargin: 3
            anchors.topMargin: 1
            Text {
                width: subjectLabel.width
                font.pixelSize: theme.fontPixelSizeMedium
                text: qsTr("From:")
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
            }
            EmailAddress {
                anchors.verticalCenter: parent.verticalCenter
                added: false
                emailAddress: window.mailSender
            }
        }
    }

    Rectangle {
        id: toRect
        anchors.top: fromRect.bottom
        anchors.topMargin: 1
        anchors.left: parent.left
        width: parent.width
        height: 43
        Image {
            anchors.fill: parent
            fillMode: Image.Tile
            source: "image://theme/email/bg_email details_l"
        }
        Row {
            spacing: 5
            height: 43
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 3
            Text {
                width: subjectLabel.width
                id: toLabel
                font.pixelSize: theme.fontPixelSizeMedium
                text: qsTr("To:")
                horizontalAlignment: Text.AlignRight
                anchors.verticalCenter: parent.verticalCenter
            }
            EmailAddress {
                //FIX ME: There is more then one mail Recipient
                anchors.verticalCenter: parent.verticalCenter
                emailAddress: mailRecipients[0]
            }
        }
    }

    Rectangle {
        id: subjectRect
        anchors.top: toRect.bottom
        anchors.left: parent.left
        width: parent.width
        anchors.topMargin: 1
        clip: true
        height: 43
        Image {
            anchors.fill: parent
            fillMode: Image.Tile
	    source: "image://theme/email/bg_email details_l"
        }
        Row {
            spacing: 5
            height: 43
            anchors.left: parent.left
            anchors.leftMargin: 3
            Text {
                id: subjectLabel
                font.pixelSize: theme.fontPixelSizeMedium
                text: qsTr("Subject:")
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                width: subjectRect.width - subjectLabel.width - 10
                font.pixelSize: theme.fontPixelSizeLarge
                text: window.mailSubject
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
            }
        }
    }

    Rectangle {
        id: attachmentRect
        anchors.top: subjectRect.bottom
        anchors.topMargin: 1
        anchors.left: parent.left
        anchors.right: parent.right
        width: parent.width
        height: 41
        opacity: (window.numberOfMailAttachments > 0) ? 1 : 0
        AttachmentView {
            height: parent.height
            width: parent.width
            model: mailAttachmentModel

            onAttachmentSelected: {
                container.uri = uri;
                attachmentContextMenu.model = [openLabel, saveLabel];
                attachmentContextMenu.setPosition(mX, mY);
                attachmentContextMenu.show();
            }
        }
    }
    Rectangle {
        id: bodyTextArea
        anchors.top: (window.numberOfMailAttachments > 0) ? attachmentRect.bottom : subjectRect.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: downloadInProgress ? progressBarRect.top : previousNextEmailRect.top
        width: parent.width
        border.width: 1
        border.color: "black"
        color: "white"
        Flickable {
            id: flick
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 2
            width: parent.width
            height: parent.height

            property variant centerPoint

            contentWidth: {
                if (window.mailHtmlBody == "") 
                    return edit.paintedWidth;
                else
                    return htmlViewer.width;
            }
            contentHeight:  {
                if (window.mailHtmlBody == "") 
                    return edit.paintedHeight;
                else
                    return htmlViewer.height;
            }
            clip: true
         
            function ensureVisible(r)
            {
                if (contentX >= r.x)
                    contentX = r.x;
                else if (contentX+width <= r.x+r.width)
                    contentX = r.x+r.width-width;
                if (contentY >= r.y)
                    contentY = r.y;
                else if (contentY+height <= r.y+r.height)
                    contentY = r.y+r.height-height;
            }

            GestureArea {
                id: webGestureArea
                anchors.fill: parent

                Pinch {
                    id: webpinch
                    property real startScale: 1.0;
                    property real minScale: 0.5;
                    property real maxScale: 5.0;

                    onStarted: {

                        flick.interactive = false;
                        flick.centerPoint = window.mapToItem(flick, gesture.centerPoint.x, gesture.centerPoint.y);
                        startScale = htmlViewer.contentsScale;
                        htmlViewer.startZooming();
                    }

                    onUpdated: {
                        var cw = flick.contentWidth;
                        var ch = flick.contentHeight;

                        if (window.mailHtmlBody == "") {
                            var newPixelSize = edit.font.pixelSize * gesture.scaleFactor;
                            edit.font.pixelSize = Math.max(theme.fontPixelSizeLarge, Math.min(newPixelSize, theme.fontPixelSizeLargest3));
                        } else {
                            htmlViewer.contentsScale = Math.max(minScale, Math.min(startScale * gesture.totalScaleFactor, maxScale));
                        }

                        flick.contentX = (flick.centerPoint.x + flick.contentX) / cw * flick.contentWidth - flick.centerPoint.x;
                        flick.contentY = (flick.centerPoint.y + flick.contentY) / ch * flick.contentHeight - flick.centerPoint.y;

                    }


                    onFinished: {
                        htmlViewer.stopZooming();
                        flick.interactive = true;
                    }
                }
            }

            HtmlField {
                id: htmlViewer
                editable: false
                html: window.mailHtmlBody
                transformOrigin: Item.TopLeft
                anchors.left: parent.left
                anchors.topMargin: 2
                contentsScale: 1
                focus: true
                clip: true
                visible: (window.mailHtmlBody != "")
                onLinkClicked: {
                    emailAgent.openBrowser(url);
                }
            }

            TextEdit {
                id: edit
                anchors.left: parent.left
                anchors.leftMargin: 5
                width: flick.width
                height: flick.height
                focus: true
                wrapMode: TextEdit.Wrap
                //textFormat: TextEdit.RichText
                font.pixelSize: theme.fontPixelSizeLarge
                readOnly: true
                onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                text: window.mailBody
                visible:  (window.mailHtmlBody == "")
            }

        }
    }

    BorderImage {
        id: progressBarRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: previousNextEmailRect.top
        opacity: downloadInProgress ? 1 : 0
        height: 45
        source: "image://theme/navigationBar_l"

        Item {
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: downloadLabel.left
            anchors.bottom: parent.bottom
            height:parent.height
            Image {
                id: progressBar
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter:parent.verticalCenter
                fillMode: Image.Stretch
                source: "image://theme/playhead_bg"
            }
            Image {
                id: progressBarSlider
                anchors.verticalCenter:progressBar.verticalCenter
                source:"image://theme/scrub_head_sm"
                x: -width/2
                z:10
            }
            Image {
                id: elapsedHead
                source: "image://theme/media/progress_fill_1"
                anchors.left: progressBar.left
                anchors.verticalCenter:progressBar.verticalCenter
                z:1
            }
            BorderImage {
                id: elapsedBody
                source: "image://theme/media/progress_fill_2"
                anchors.left: elapsedHead.right
                anchors.right: elapsedTail.left
                anchors.verticalCenter:progressBar.verticalCenter
                border.left: 1; border.top: 1
                border.right: 1; border.bottom: 1
                z:1
            }
            Image {
                id: elapsedTail
                source: "image://theme/media/progress_fill_3"
                anchors.right: progressBarSlider.right
                anchors.rightMargin: progressBarSlider.width/2
                anchors.verticalCenter:progressBar.verticalCenter
                z:1
            }
            Connections {
                id: progressBarConnection
                target: emailAgent
                onProgressUpdate: {
                    progressBarSlider.x = percent * (progressBar.width - progressBarSlider.width) / 100 - progressBarSlider.width/2;
                }
            }
        }
        Text {
            id: downloadLabel
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            horizontalAlignment: Text.AlignLeft
            verticalAlignment:Text.AlignVCenter
            font.pixelSize: theme.fontPixelSizeLarge
            color: theme.fontColorMediaHighlight
            text: qsTr("Downloading...")
        }
    }
    Item {
        id: previousNextEmailRect
        anchors.bottom: readingViewToolbar.top
        anchors.left: parent.left
        anchors.right: parent.right
        width: parent.width
        height: previousEmailButton.height
        //color: "#0d0303"
    BorderImage {
        id: navigationBar
        width: parent.width
        source: "image://themedimage/widgets/common/action-bar/action-bar-background"
    }

        ToolbarButton  {
            id: previousEmailButton
            anchors.left: parent.left
            anchors.top: parent.top
            visible: window.currentMessageIndex > 0 ? true : false
            iconName: "mail-message-previous" 
            onClicked: {
                if (window.currentMessageIndex > 0)
                {
                    window.currentMessageIndex = window.currentMessageIndex - 1;
                    window.updateReadingView(window.currentMessageIndex);
                }
            }
        }

        ToolbarButton {
            id: nextEmailButton

            anchors.right: parent.right
            anchors.top: parent.top
            visible: (window.currentMessageIndex + 1) < messageListModel.messagesCount() ? true : false
            iconName: "mail-message-next" 

            onClicked: {
                if (window.currentMessageIndex < messageListModel.messagesCount())
                {
                    window.currentMessageIndex = window.currentMessageIndex + 1;
                    window.updateReadingView(window.currentMessageIndex);
                }
            }
        }
    } 
    ReadingViewToolbar {
        id: readingViewToolbar
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: parent.width
    }
}
