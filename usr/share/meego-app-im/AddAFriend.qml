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

import Qt 4.7

Column {
    property bool alreadyAdding: false
    property alias textInput: addAFriendInput

    AddContactHelper {
        id: addContactHelper
        accountItem: accountsModel.accountItemForId(window.currentAccountId)
    }

    function resetHelper()
    {
        addContactHelper.resetHelper();
        state = "";
        addAFriendInput.text = "";
    }

    id: column
    width:  parent.width - 20
    spacing: theme_fontPixelSizeLarge
    height: childrenRect.height + 5

    Text {
        id: addAFriendMessage
        width: parent.width
        color: theme_contextMenuFontColor
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.pixelSize: theme_fontPixelSizeLarge
        wrapMode: Text.WordWrap
        visible: false
    }

    TextEntry {
        id: addAFriendInput
        width: parent.width
        text: ""
        defaultText: qsTr("Friend's username")
        visible: addContactHelper.state == AddContactHelper.StateIdle ||
                 addContactHelper.state == AddContactHelper.StateError

        onAccepted: {
            addAFriendInput.addFriend();
        }

        function addFriend()
        {
            if (!alreadyAdding) {
                alreadyAdding = true;
                addContactHelper.contactId = addAFriendInput.text;
                addContactHelper.sendRequest();
            }
        }
    }

    Button {
        id: addAFriendSend
        height: 40
        text: qsTr("Send")
        textColor: theme_buttonFontColor
        bgSourceUp: "image://themedimage/widgets/common/button/button-default"
        bgSourceDn: "image://themedimage/widgets/common/button/button-default-pressed"
        visible: addContactHelper.state == AddContactHelper.StateIdle ||
                 addContactHelper.state == AddContactHelper.StateError
        onClicked: {
            addAFriendInput.addFriend();
        }
    }

    states: [
        State {
            name: "sending"
            when: addContactHelper.state == AddContactHelper.StateSending
            PropertyChanges {
                target: addAFriendMessage
                visible: true
                text: qsTr("Sending request")
            }
        },
        State {
            name: "sent"
            when: addContactHelper.state == AddContactHelper.StateSent
            PropertyChanges {
                target: addAFriendMessage
                visible: true
                text: qsTr("Request sent")
            }
        },
        State {
            name: "error"
            when: addContactHelper.state == AddContactHelper.StateError
            PropertyChanges {
                target: addAFriendMessage
                visible: true
                text: addContactHelper.error
            }
        },
        State {
            name: "nonetwork"
            when: addContactHelper.state == AddContactHelper.StateNoNetwork
            PropertyChanges {
                target: addAFriendMessage
                visible: true
                text: qsTr("Your device is not connected to a network. Please connect and try again.")
            }
        }
    ]
}
