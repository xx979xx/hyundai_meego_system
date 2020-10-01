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

Column {
    id: header

    property alias subject: subjectEntry.text
    property int fromEmail: 0

    property alias toModel: toRecipients.model
    property alias ccModel: ccRecipients.model
    property alias bccModel: bccRecipients.model
    property alias attachmentsModel: attachmentBar.model
    property EmailAccountListModel accountsModel
    property variant emailAccountList: []
    property int priority: EmailMessage.NormalPriority

    property bool showOthers: false

    focus: true

    spacing: 5

    TopItem { id: topItem }

    function completeEmailAddresses () {
        toRecipients.complete ();
        ccRecipients.complete ();
        bccRecipients.complete ();
    }

    Connections {
        target: mailAccountListModel
        onAccountAdded: {
            emailAccountList = accountsModel.getAllEmailAddresses();
            if (window.currentMailAccountIndex == -1)
            {
                window.currentMailAccountIndex = 0;
                fromEmail = 0
                accountSelector.selectedIndex = 0;
            }
        }
    }

    // EmailAccountListModel doesn't seem to be a real ListModel
    // We need to convert it to one to set it in the DropDown
    onAccountsModelChanged: {
        emailAccountList = accountsModel.getAllEmailAddresses();
        fromEmail = window.currentMailAccountIndex;
    }

    Row {
        width: parent.width
        spacing: 5
        height: 53
        z: 1000

        VerticalAligner {
            id: fromLabel
            text: qsTr ("From:")
        }

        DropDown {
            id: accountSelector
            width: parent.width - (ccToggle.width + fromLabel.width + 30)
            minWidth: 400
            model: emailAccountList
            height: 53
            title: emailAccountList[window.currentMailAccountIndex];
            titleColor: "black"
            replaceDropDownTitle: true

            Component.onCompleted: {
                selectedIndex = window.currentMailAccountIndex;;
            }
            onTriggered: {
                fromEmail = index;
            }
        }

        Image {
            id: ccToggle
            width: ccBccLabel.width + 20
            height: parent.height

            source: "image://theme/btn_blue_up"

            Text {
                id: ccBccLabel
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Cc/Bcc")
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    header.showOthers = !header.showOthers;
                }
            }
        }
    }

    Row {
        //: The "to" recipient label.
        property string toLabel: qsTr("To")

        width: parent.width

        spacing: 5

        // Expand to fill the height correctly
        height: toRecipients.height

        EmailRecipientEntry {
            id: toRecipients

            defaultText: parent.toLabel
            width: parent.width - toAddButton.width - 20 - spacing
        }

        AddRecipient {
            id: toAddButton
            label: parent.toLabel
            recipients: toRecipients
        }
    }

    Row {
        //: The Cc (carbon copy) label.
        property string ccLabel: qsTr("Cc")

        width: parent.width
        spacing: 5

        height: ccRecipients.height
        visible: showOthers

        EmailRecipientEntry {
            id: ccRecipients

            defaultText: parent.ccLabel
            width: parent.width - ccAddButton.width - 20 - spacing
        }

        AddRecipient {
            id: ccAddButton
            label: parent.ccLabel
            recipients: ccRecipients
        }
    }

    Row {
        //: The Bcc (blind carbon copy) label.
        property string bccLabel: qsTr("Bcc")

        width: parent.width
        spacing: 5

        height: bccRecipients.height
        visible: showOthers

        EmailRecipientEntry {
            id: bccRecipients

            defaultText: parent.bccLabel
            width: parent.width - bccAddButton.width - 20 - spacing
        }

        AddRecipient {
            id: bccAddButton
            label: parent.bccLabel
            recipients: bccRecipients
        }
    }

    Row {
        width: parent.width
        height: 53
        spacing: 5

        TextEntry {
            id: subjectEntry

            width: parent.width - priorityButton.width - 20
            height: parent.height

            defaultText: qsTr ("Enter subject here")
        }

        Image {
            id: priorityButton
            source: "image://theme/email/btn_priority_up"
            height: parent.height
            fillMode: Image.PreserveAspectFit

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    var map = mapToItem(topItem.topItem, mouseX, mouseY);
                    priorityContextMenu.setPosition(map.x, map.y)

                    if (priority == EmailMessage.NormalPriority)
                        priorityContextMenu.content[0].selectedIndex = 1   // model[1]
                    else if (priority == EmailMessage.LowPriority)
                        priorityContextMenu.content[0].selectedIndex = 2   // model[2]
                    else
                        priorityContextMenu.content[0].selectedIndex = 0   // model[0]

                    console.log("Priority context menu selected index: " + priorityContextMenu.content[0].selectedIndex)

                    priorityContextMenu.show()
                }
            }

            ContextMenu {
                id: priorityContextMenu

                content: ActionMenu {
                    id: actionMenu

                    property string lowText:    qsTr("Low Priority")
                    property string normalText: qsTr("Normal Priority")
                    property string highText:   qsTr("High Priority")

                    model: [ highText, normalText, lowText ]
                    payload: [ EmailMessage.HighPriority,
                               EmailMessage.NormalPriority,
                               EmailMessage.LowPriority ]

                    highlightSelectedItem: true

                    onTriggered: {
                        priority = payload[index]

                        console.log("Message priority set to: " + priority)

                        priorityContextMenu.hide()
                    }
                }
            }
        }

    }

    AttachmentView {
        id: attachmentBar
        width: parent.width - 20
        height: 41
        opacity: (model.count > 0) ? 1 : 0
    }

}
