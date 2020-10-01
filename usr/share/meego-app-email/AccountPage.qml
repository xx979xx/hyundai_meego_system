/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1
import MeeGo.App.Email 0.1

Item {
    id: container
    width: window.width
    parent: accountListView
    anchors.fill: parent

    property int topicHeight: 58
    signal topicTriggered(int index)
    property alias currentTopic: listView.currentIndex
    property alias interactive: listView.interactive
    property alias model: listView.model

    Labs.ApplicationsModel {
        id: appModel
    }

    Component.onCompleted: {
        if (listView.count == 0)
        {
            var cmd = "/usr/bin/meego-qml-launcher --app meego-ux-settings --opengl --fullscreen --cmd showPage --cdata \"Email\"";  //i18n ok
            appModel.launch(cmd);
        }
        window.currentMailAccountIndex = 0;
    }


    ListView {
        id: listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: accountListViewToolbar.top
        width: parent.width
        clip: true
        model: mailAccountListModel
        spacing: 1

        onCurrentIndexChanged: container.topicTriggered(currentIndex)

        delegate: Rectangle {
            id: accountItem
            width: container.width
            height: theme.listBackgroundPixelHeightTwo

            property string accountDisplayName;
            accountDisplayName: {
                accountDisplayName = displayName;
                window.currentAccountDisplayName = displayName;
                if (index == 0)
                    window.currentMailAccountId = mailAccountId;
            }

            Image {
                anchors.fill: parent
                source: "image://theme/email/bg_email details_p"
            }

            property string accountImage

            accountImage: {
                if (mailServer == "gmail")
                {
                    "image://themedimage/icons/services/gmail"
                }
                else if (mailServer == "msn" || mailServer == "hotmail")
                {
                    "image://themedimage/icons/services/msmail"
                }
                else if (mailServer == "facebook")
                {
                    "image://themedimage/icons/services/facebook"
                }
                else if (mailServer == "yahoo")
                {
                    "image://themedimage/icons/services/yahoo"
                }
                else if (mailServer == "aol")
                {
                    "image://themedimage/icons/services/aim"
                }
                else
                {
                    "image://themedimage/icons/services/generic"
                }
            }

            Image {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                source: accountImage
            }

            Text {
                id: accountName
                height: parent.height
                font.pixelSize: theme.fontPixelSizeLarge
                anchors.left: parent.left
                anchors.leftMargin: 100
                verticalAlignment: Text.AlignVCenter
                text: qsTr("%1 - %2").arg(emailAddress).arg(displayName)
            }

            Image {
                id: unreadImage
                anchors.right: goToFolderListIcon.left 
                anchors.rightMargin:10 
                anchors.verticalCenter: parent.verticalCenter
                width: 50
                fillMode: Image.Stretch
                source: "image://themedimage/widgets/apps/email/accounts-unread"

                Text {
                    id: text
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalAlignment: Text.AlignVCenter
                    text: unreadCount
                    font.pixelSize: theme.fontPixelSizeMedium
                    color: theme.fontColorNormal
                }
            }

            Image {
                id: goToFolderListIcon
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                source: "image://theme/arrow-right"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (window.accountPageClickCount == 0)
                    {
                        listView.currentIndex = index;
                        window.currentMailAccountId = mailAccountId;
                        window.currentMailAccountIndex = index;
                        window.currentAccountDisplayName = displayName;
                        messageListModel.setAccountKey (mailAccountId);
                        mailFolderListModel.setAccountKey(mailAccountId);
                        window.folderListViewTitle = window.currentAccountDisplayName + " " + mailFolderListModel.inboxFolderName();
                        window.currentFolderId = mailFolderListModel.inboxFolderId();
                        window.switchBook (folderList);
                    }
                    window.accountPageClickCount++;
                }
            }
        }
    }
    Item {
        id: accountListViewToolbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: window.width
        height: 120
        AccountViewToolbar {}
    }
}
