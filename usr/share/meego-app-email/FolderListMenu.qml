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
import Qt.labs.gestures 2.0

Item {
    id: folderListMenu
    property bool scrollInFolderList: false    
    property string createNewFolder: qsTr("Create new folder")

    height: {
        var realHeight = window.width;
        if (window.orientation == 1 || window.orientation == 3)
        {
           realHeight = window.height;
        }
        var maxHeight = 50 * (5 + mailFolderListModel.totalNumberOfFolders());
        if (maxHeight > (realHeight - 170))
        {
            scrollInFolderList = true;
            return (realHeight - 170);
        }
        else
            return maxHeight;
    }
    
    width: Math.max(sortTitle.width, goToFolderTitle.width, createFolderLabel.width + createButton.width) + 30

    Item {
        id: sort
        height: 50
        anchors.left: parent.left
        anchors.top: parent.top
        Text {
            id: sortTitle
            text: sortLabel
            font.bold: true
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            color:theme.fontColorNormal
            font.pixelSize: theme.fontPixelSizeLarge
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideRight
        }
    }

    SortFilter {
        id: sortFilter
        anchors.top: sort.bottom
        anchors.left: parent.left
        width: parent.width
        height: 50 * 3
        topics: [
            topicDate,
            topicSender,
            topicSubject
        ]
        onTopicTriggered: {
            if (index == 0)
            {
                messageListModel.sortByDate(folderListView.dateSortKey);
                folderListView.dateSortKey = folderListView.dateSortKey ? 0 : 1;
                folderListView.senderSortKey = 1;
                folderListView.subjectSortKey = 1;
            }
            else if (index == 1)
            {
                messageListModel.sortBySender(folderListView.senderSortKey);
                folderListView.senderSortKey = folderListView.senderSortKey ? 0 : 1;
                folderListView.dateSortKey = 1;
                folderListView.subjectSortKey = 1;
            }
            else if (index == 2)
            {
                messageListModel.sortBySubject(folderListView.subjectSortKey);
                folderListView.subjectSortKey = folderListView.subjectSortKey ? 0 : 1;
                folderListView.dateSortKey = 1;
                folderListView.senderSortKey = 1;
            }
            folderListView.closeMenu()
        }
    }
    Image {
        id: sortDivider
        anchors.top: sortFilter.bottom
        width: parent.width
        source: "image://theme/email/divider_l"
    }
    Item {
        id: goToFolder
        height: 50
        anchors.left: parent.left
        anchors.top: sortDivider.bottom
        Text {
            id: goToFolderTitle
            text: window.goToFolderLabel
            font.bold: true
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            color:theme.fontColorNormal
            font.pixelSize: theme.fontPixelSizeLarge
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideRight
        }
    }
    ListView {
        id: listView
        anchors.left: parent.left
        anchors.top: goToFolder.bottom
        anchors.bottom: createFolderDivider.top
        width: folderListMenu.width
        spacing: 1
        interactive: folderListMenu.scrollInFolderList
        clip: true
       
        model: mailFolderListModel

        delegate: Item {
            id: folderItem
            width: folderListMenu.width
            height: 50

            Image {
                width: folderListMenu.width
                source: "image://theme/email/divider_l"
            }

            Text {
                id: folderLabel
                height: 50
                text:  folderName
                font.pixelSize: theme.fontPixelSizeLarge
                color:theme.fontColorNormal
                anchors.left: parent.left
                anchors.leftMargin: 15
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            Text {
                height: 50
                font.pixelSize: theme.fontPixelSizeLarge
                text: qsTr("(%1)").arg(folderUnreadCount)
                anchors.left: folderLabel.right
                anchors.leftMargin: 10
                color:theme.fontColorNormal
                verticalAlignment: Text.AlignVCenter
                opacity: folderUnreadCount ? 1 : 0
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    window.currentFolderId = folderId;
                    window.folderListViewTitle = currentAccountDisplayName + " " + folderName;
                    folderListView.closeMenu();
                    messageListModel.setFolderKey(folderId);
                    folderList=null;
                    window.switchBook(folderList);
                }
            }
        }
    }

    Image {
        id: createFolderDivider
        anchors.bottom: createFolderLabel.top
        width: parent.width
        source: "image://theme/email/divider_l"
    }

    Text {
        id: createFolderLabel
        height: 50
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: folderListMenu.bottom
        text: createNewFolder
        verticalAlignment: Text.AlignVCenter

        font.bold: true
        color:theme.fontColorNormal
        font.pixelSize: theme.fontPixelSizeLarge
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
    }

    Image {
        id: createButton
        anchors.top: createFolderLabel.top
        anchors.bottom: createFolderLabel.bottom
        anchors.right: parent.right
        anchors.rightMargin: 5
        source: "image://theme/email/btn_addperson"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent

            onClicked: {
                createFolderDialog.show()
            }
        }

        ModalDialog {
            id: createFolderDialog

            showAcceptButton: true
            showCancelButton: true
            acceptButtonText: qsTr("Create")
            cancelButtonText: qsTr("Cancel")
            title: createNewFolder

            content: TextEntry {
                id: folderNameEntry

                anchors.centerIn: parent
                //: Default custom e-mail folder name.
                text: qsTr("Untitled Folder")
            }

            onAccepted: {
                emailAgent.createFolder(folderNameEntry.text,
                                        window.currentMailAccountId,
                                        window.currentFolderId)
            }
        }
    }

}
